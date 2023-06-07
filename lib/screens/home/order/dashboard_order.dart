import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mammi/colors/colors.dart';
import 'package:mammi/models/cart.dart';
import 'package:mammi/models/product.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/user.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserApp>(context);
    final TextEditingController _contactNumberController = TextEditingController();

    /// Function to validate Cameroonian phone numbers
    bool isValidCameroonianPhoneNumber(String number) {
      /// Regular expression to validate Cameroonian phone numbers
      final cameroonianNumberRegex = r'^\+237[2368]\d{7,8}$';
      final regExp = RegExp(cameroonianNumberRegex);
      return regExp.hasMatch(number);
    }

    /// Function to place the order
    Future<void> _placeOrder(List<Cart> cartItems, String contactNumber) async {
      if (contactNumber.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a contact number'),
          ),
        );
        return;
      }

      final isValidPhoneNumber = isValidCameroonianPhoneNumber(contactNumber);
      if (!isValidPhoneNumber) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid Cameroonian phone number'),
          ),
        );
        return;
      }

      for (var cartItem in cartItems) {
        FirebaseFirestore.instance.collection('orders').add({
          'productId': cartItem.productId,
          'userId': cartItem.userId,
          'quantity': cartItem.quantity,
          'contactNumber': contactNumber,
          'status': 'pending', // Set the order status as 'pending'
        });
      }

      // Clear the cart
      for (var cartItem in cartItems) {
        FirebaseFirestore.instance
            .collection('cart')
            .doc(cartItem.cartId)
            .delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: AppColors.mainColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error fetching cart products');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final cartItems = snapshot.data!.docs
                .map((doc) => Cart.fromSnapshot(doc))
                .toList();

            return ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('products')
                      .doc(cartItem.productId)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Error fetching product details');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(color: AppColors.mainColor);
                    }

                    if (snapshot.hasData && snapshot.data!.exists) {
                      final product = Product.fromMap(
                        snapshot.data!.data() as Map<String, dynamic>,
                        snapshot.data!.id,
                      );

                      final totalPrice = product.price! * cartItem.quantity;

                      return ListTile(
                        leading: Image.network(
                          product.imageUrl!,
                          width: 50,
                          height: 50,
                        ),
                        title: Text(product.name!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quantity: ${cartItem.quantity}'),
                            Text('Total Price: ${totalPrice.toString()} FCFA'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Delete the cart item
                            FirebaseFirestore.instance
                                .collection('cart')
                                .doc(cartItem.cartId)
                                .delete()
                                .then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Product removed from cart'),
                                ),
                              );
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Error removing product from cart: $error'),
                                ),
                              );
                            });
                          },
                        ),
                      );
                    }

                    return const Text('Product not found');
                  },
                );
              },
            );
          }

          return const Text('Your cart is empty');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final contactNumber = await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Enter Contact Number'),
                content: TextField(
                  controller: _contactNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Contact Number',
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(_contactNumberController.text);
                    },
                    child: Text('Submit'),
                  ),
                ],
              );
            },
          );

          FirebaseFirestore.instance
              .collection('cart')
              .where('userId', isEqualTo: user.uid)
              .get()
              .then((snapshot) {
            if (snapshot.docs.isNotEmpty) {
              final cartItems = snapshot.docs
                  .map((doc) => Cart.fromSnapshot(doc))
                  .toList();

              _placeOrder(cartItems, contactNumber!);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Your cart is empty'),
                ),
              );
            }
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error placing order: $error'),
              ),
            );
          });
        },
        child: const Text('Place Order'),
      ),
    );
  }
}
