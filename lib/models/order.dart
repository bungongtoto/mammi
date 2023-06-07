import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents an order in the application.
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

  /// Factory method to create an Orders object from a DocumentSnapshot.
  factory Orders.fromSnapshot(DocumentSnapshot snapshot) {
    /// Extract data from the snapshot
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
