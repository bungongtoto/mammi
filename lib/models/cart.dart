import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a Cart item in the application.
class Cart {
  final String cartId;
  final String userId;
  final String productId;
  final int quantity;
  final String contactNumber;
 ///  this is the constructor of the Cart object
  Cart({
    required this.cartId,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.contactNumber,
  });

  /// Factory method to create a Cart object from a DocumentSnapshot.
  factory Cart.fromSnapshot(DocumentSnapshot snapshot) {
    // Extract data from the snapshot
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Cart(
      cartId: snapshot.id,
      userId: data['userId'],
      productId: data['productId'],
      quantity: data['quantity'],
      contactNumber: data['contactNumber'], 
    );
  }

  /// Converts the Cart object to a JSON format.
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'productId': productId,
      'quantity': quantity,
      'contactNumber': contactNumber,
    };
  }
}
