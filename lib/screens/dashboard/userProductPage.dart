import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mammi/colors/colors.dart';
import 'package:mammi/models/product.dart';
import 'package:mammi/screens/dashboard/update_product.dart';
import 'package:mammi/utills/dimensions.dart';
import 'package:mammi/widgets/big_text.dart';
import 'package:mammi/widgets/icon_text_widget.dart';

import '../../widgets/small_text_with_overflow.dart';
import '../home/order/dashboard_order.dart';
import 'add_product.dart';

class UserProductsPage extends StatefulWidget {
  final String userId;

  UserProductsPage({required this.userId});

  @override
  _UserProductsPageState createState() => _UserProductsPageState();
}

class _UserProductsPageState extends State<UserProductsPage> {
  List<Product> products = [];

  Future<void> fetchProducts() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('userId', isEqualTo: widget.userId)
          .get();

      setState(() {
        products = querySnapshot.docs
            .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      });
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(error.toString()),
          );
        },
      );
    }
  }

  Future<void> deleteProduct(Product product) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(product.id).delete();
      /// Product deleted successfully
      /// Refresh the product list after deletion
      await fetchProducts();
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(error.toString()),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    /// Fetch the products for the specified user ID
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    void openAddProductPage() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddProductPage()),
      );
    }

    void openProductOrderDashboard() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DashboardOrdersPage()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: const Text('My Products'),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () => openProductOrderDashboard(),
            icon: const Icon(Icons.sell),
            label: const Text('Orders'),
          ),
          TextButton.icon(
            onPressed: () => openAddProductPage(),
            icon: const Icon(Icons.add),
            label: const Text('Add'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchProducts,
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final Product product = products[index];
            return Dismissible(
              key: Key(product.id!),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Deletion'),
                      content: const Text('Are you sure you want to delete this product?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('DELETE'),
                        ),
                      ],
                    );
                  },
                );
              },
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  deleteProduct(product);
                }
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdateProductPage(product: product)),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height10),
                  child: Row(
                    children: [
                      //Image section
                      Container(
                        width: Dimensions.listViewIm,
                        height: Dimensions.listViewIm,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radius20),
                          color: AppColors.mainColor,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              product.imageUrl!,
                            ),
                          ),
                        ),
                      ),

                      //Text container
                      Expanded(
                        child: Container(
                          height: Dimensions.listViewText,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(Dimensions.radius20),
                              bottomRight: Radius.circular(Dimensions.radius20),
                            ),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: Dimensions.width5, right: Dimensions.width10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BigText(text: "${product.name}", color: Colors.black,),
                                SizedBox(height: Dimensions.height10,),
                                SmallTextOverflow(text: "${product.description}"),
                                SizedBox(height: Dimensions.height10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconAndTextWidget(icon: Icons.production_quantity_limits_outlined, text: "${product.quantity} available", iconColor: AppColors.iconColor1),
                                    IconAndTextWidget(icon: Icons.price_check, text: "${product.price} FCFA", iconColor: AppColors.mainColor),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
