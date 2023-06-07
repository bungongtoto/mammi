import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  final String cartId;
  final String userId;
  final String productId;
  final int quantity;
  final String contactNumber;

  Cart({
    required this.cartId,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.contactNumber,
  });

  factory Cart.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Cart(
      cartId: snapshot.id,
      userId: data['userId'],
      productId: data['productId'],
      quantity: data['quantity'],
      contactNumber: data['contactNumber'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'productId': productId,
      'quantity': quantity,
      'contactNumber': contactNumber,
    };
  }
}
