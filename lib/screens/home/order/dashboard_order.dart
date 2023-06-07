import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mammi/colors/colors.dart';
import 'package:mammi/models/order.dart';
import 'package:mammi/models/product.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../models/user.dart';

class DashboardOrdersPage extends StatefulWidget {
  const DashboardOrdersPage({Key? key}) : super(key: key);

  @override
  _DashboardOrdersPageState createState() => _DashboardOrdersPageState();
}

class _DashboardOrdersPageState extends State<DashboardOrdersPage> {
  Future<List<String>>? _productIdsFuture;

  @override
  void initState() {
    super.initState();
    _fetchProductIds();
  }

  Future<void> _fetchProductIds() async {
    final user = Provider.of<UserApp>(context, listen: false);
    _productIdsFuture = _getUserProductIds(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Orders'),
        backgroundColor: AppColors.mainColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchProductIds();
        },
        child: FutureBuilder<List<String>>(
          future: _productIdsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text('Error fetching product IDs'),
              );
            }

            final productIds = snapshot.data;

            if (productIds == null || productIds.isEmpty) {
              return const Center(
                child: Text('No product found'),
              );
            }

            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('status', isEqualTo: 'pending')
                  .where('productId', whereIn: productIds)
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

                      return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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
                              title: Text('Order ID: ${order.orderId}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Product Name: ${product.name}'),
                                  Text('Quantity: ${order.quantity}'),
                                  Text('Price: ${product.price}'),
                                  Text('Total Price: $totalPrice'),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _callOrderContactNumber(context, order.contactNumber),
                                    child: const Text('Call'),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () => _completeOrder(order.orderId),
                                    child: const Text('Complete'),
                                  ),
                                ],
                              ),
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
            );
          },
        ),
      ),
    );
  }

  Future<List<String>> _getUserProductIds(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<void> _callOrderContactNumber(BuildContext context, String contactNumber) async {
    final url = 'tel:$contactNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Permission denied, request permission
      final status = await Permission.phone.request();
      if (status.isGranted) {
        await launch(url);
      } else {
        // Permission denied
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone call permission denied.')),
        );
      }
    }
  }

  Future<void> _completeOrder(String orderId) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .update({'status': 'completed'});
  }
}
