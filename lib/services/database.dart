import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

/// DatabaseService provides access to Firestore database and handles user-specific data.
class DatabaseService {
  final String uid;

  DatabaseService(this.uid);

  final CollectionReference productCollection = FirebaseFirestore.instance.collection('products');

  /// Converts a QuerySnapshot of products to a list of Product objects.
  List<Product> _userProductListFormSnapshot(QuerySnapshot snapshots) {
    return snapshots.docs.map((doc) {
      return Product(
        id: doc.id,
        userId: doc['userId'] ?? '',
        name: doc['name'] ?? '',
        description: doc['description'] ?? '',
        price: (doc['price'] ?? 0).toDouble(),
        quantity: (doc['quantity'] ?? 0),
        imageUrl: doc['imageUrl'] ?? '',
      );
    }).toList();
  }

  /// Updates the user's product data in the database.
  Future updateUserData(Product product) async {
    return await productCollection.doc(product.id).set({
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'quantity': product.quantity,
      'imageUrl': product.imageUrl,
    });
  }

  /// Retrieves a stream of products from the database.
  Stream<List<Product>> get products {
    return productCollection.snapshots().map(_userProductListFormSnapshot);
  }
}
