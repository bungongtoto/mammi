import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';

class DatabaseService{

   final CollectionReference brewCollection = FirebaseFirestore.instance.collection('products');

   List<Product> _productListFormSnapshot(QuerySnapshot snapshots){
    return snapshots.docs.map((doc) {
      return Product(
        id: doc['id'],
        userId: doc['userId'] ?? '',
        name: doc['name'] ?? '',
        description: doc['description'] ?? '',
        price: (doc['price'] ?? 0).toDouble(),
        quantity: (doc['quantity'] ?? 0),
        imageUrl: doc['imageUrl'] ?? '', 
      );
    }).toList();
  } 
 
  Stream<List<Product>> get products{
    return brewCollection.snapshots().map(_productListFormSnapshot);
  }
}