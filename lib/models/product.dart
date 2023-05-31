class Product {
  String? id;
  String? userId;
  String? name;
  String? description;
  double? price;
  String? imageUrl;
  int? quantity;

  Product({
    this.id,
    this.userId,
    this.name,
    this.description,
    this.price,
    this.imageUrl,
    this.quantity,
  });

  factory Product.fromMap(Map<String, dynamic> map, String id) {
  return Product(
    id: id,
    userId: map['userId'] as String,
    name: map['name'] as String,
    description: map['description'] as String,
    price: map['price'] as double,
    imageUrl: map['imageUrl'] as String,
    quantity: map['quantity'] as int,
  );
}

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }
}
