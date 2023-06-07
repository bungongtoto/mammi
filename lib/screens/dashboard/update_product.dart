import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:mammi/colors/colors.dart';
import 'package:mammi/models/product.dart';

class UpdateProductPage extends StatefulWidget {
  final Product product;

  const UpdateProductPage({Key? key, required this.product}) : super(key: key);

  @override
  _UpdateProductPageState createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  final _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize the text fields with the product data
    _productNameController.text = widget.product.name!;
    _descriptionController.text = widget.product.description!;
    _priceController.text = widget.product.price.toString();
    _quantityController.text = widget.product.quantity.toString();
  }

  /// Function to update the product in the database
  void _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      String productName = _productNameController.text;
      String description = _descriptionController.text;
      double price = double.parse(_priceController.text);
      String imageUrl = await _uploadImage();
      int quantity = int.parse(_quantityController.text);

      Product updatedProduct = Product(
        id: widget.product.id,
        userId: widget.product.userId,
        name: productName,
        description: description,
        price: price,
        imageUrl: imageUrl,
        quantity: quantity,
      );

      CollectionReference products =
          FirebaseFirestore.instance.collection('products');

      await products
          .doc(widget.product.id)
          .update(updatedProduct.toJson())
          .then((value) {
        // Successfully updated the product
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully')),
        );
      }).catchError((error) {
        // Error occurred while updating the product
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating product: $error')),
        );
      });
    }
  }

  /// Function to upload the selected image to Firebase Storage
  Future<String> _uploadImage() async {
    if (_image == null) {
      return widget.product.imageUrl!; // Return the existing image URL if no new image is selected
    }

    String fileName =
        'products/${DateTime.now().millisecondsSinceEpoch.toString()}';

    firebase_storage.Reference reference =
        firebase_storage.FirebaseStorage.instance.ref().child(fileName);
    firebase_storage.UploadTask uploadTask = reference.putFile(_image!);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  /// Function to select an image from the gallery
  Future _selectImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
        backgroundColor: AppColors.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TextFormField for product name
                TextFormField(
                  controller: _productNameController,
                  decoration: const InputDecoration(
                    hintText: 'Product Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the product name';
                    }
                    return null;
                  },
                ),
                /// TextFormField for description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                  ),
                  maxLines: 7,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                /// TextFormField for price
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    hintText: 'Price',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                /// ListTile for selecting an image
                ListTile(
                  title: const Text('Image'),
                  subtitle: _image == null
                      ? const Text('No image selected')
                      : Image.file(_image!),
                  onTap: _selectImage,
                ),
                /// TextFormField for quantity
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    hintText: 'Quantity',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the quantity';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                /// Button for updating the product
                ElevatedButton(
                  onPressed: _updateProduct,
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.mainColor,
                  ),
                  child: const Text('Update Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
