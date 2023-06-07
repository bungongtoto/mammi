class Product {
  String? id; // Unique identifier of the product
  String? userId; // ID of the user who owns the product
  String? name; // Name of the product
  String? description; // Description of the product
  double? price; // Price of the product
  String? imageUrl; // URL of the product image
  int? quantity; // Quantity of the product

  Product({
    this.id,
    this.userId,
    this.name,
    this.description,
    this.price,
    this.imageUrl,
    this.quantity,
  });

  /// Factory method to create a Product object from a Map and an ID.
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

  /// Factory method to create a Product object from JSON data.
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

  /// Convert the Product object to a JSON representation.
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
