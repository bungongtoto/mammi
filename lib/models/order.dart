import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  final String orderId;
  final String productId;
  final String userId;
  final int quantity;
  final String contactNumber;
  final String status;

  Orders({
    required this.orderId,
    required this.productId,
    required this.userId,
    required this.quantity,
    required this.contactNumber,
    required this.status,
  });

  factory Orders.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Orders(
      orderId: snapshot.id,
      productId: data['productId'],
      userId: data['userId'],
      quantity: data['quantity'],
      contactNumber: data['contactNumber'],
      status: data['status'],
    );
  }
}
