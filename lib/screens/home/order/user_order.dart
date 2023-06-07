import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mammi/colors/colors.dart';
import 'package:mammi/models/order.dart';
import 'package:mammi/models/product.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserApp>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: AppColors.mainColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error fetching orders');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final orders = snapshot.data!.docs
                .map((doc) => Orders.fromSnapshot(doc))
                .toList();

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('products')
                      .doc(order.productId)
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

                      final totalPrice = product.price! * order.quantity;

                      return ListTile(
                        title: Text('Product Name: ${product.name}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quantity: ${order.quantity}'),
                            Text('Price: ${product.price}'),
                            Text('Total Price: $totalPrice'),
                          ],
                        ),
                        trailing: Text('Status: ${order.status}'),
                      );
                    }

                    return const Text('Product not found');
                  },
                );
              },
            );
          }

          return const Text('No orders found');
        },
      ),
    );
  }
}
