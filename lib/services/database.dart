import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/product.dart';

class DatabaseService{
  final String uid;
  DatabaseService(this.uid);
   final CollectionReference productCollection = FirebaseFirestore.instance.collection('products');

   List<Product> _userProductListFormSnapshot(QuerySnapshot snapshots){
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
 

  Future updateUserData(Product product) async{
    return await productCollection.doc(product.id).set({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'quantity': product.quantity,
        'imageUrl': product.imageUrl,
    });
  }
  
  Stream<List<Product>> get products{
    return  productCollection.snapshots().map(_userProductListFormSnapshot);
  }
}