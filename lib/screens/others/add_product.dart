import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mammi/colors/colors.dart';
import 'package:mammi/models/product.dart';
import 'package:mammi/models/user.dart';
import 'package:mammi/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  final _quantityController = TextEditingController();
  String? uid = "";

  void _addProduct() async {
  if (_formKey.currentState!.validate()) {
    String productName = _productNameController.text;
    String description = _descriptionController.text;
    double price = double.parse(_priceController.text);
    String imageUrl = await _uploadImage();
    int quantity = int.parse(_quantityController.text);

    // Get the current user's ID (replace with your own logic)
    String userId = uid!;

    Product newProduct = Product(
      userId: userId,
      name: productName,
      description: description,
      price: price,
      imageUrl: imageUrl,
      quantity: quantity,
    );

    CollectionReference products = FirebaseFirestore.instance.collection('products');

    await products.add(newProduct.toJson()).then((document) {
      // Successfully added the product
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully')),
      );

      // Clear the form fields
      _productNameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _quantityController.clear();
      setState(() {
        _image = null;
      });
    }).catchError((error) {
      // Error occurred while adding the product
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding product: $error')),
      );
    });
  }
}

  

  Future<String> _uploadImage() async {
    if (_image == null) {
      return '';
    }else{

    String fileName = 'products/${DateTime.now().millisecondsSinceEpoch.toString()}';
    
    firebase_storage.Reference reference =firebase_storage.FirebaseStorage.instance.ref().child(fileName);
    firebase_storage.UploadTask uploadTask = reference.putFile(_image!);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
    }
  }

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
    final user = Provider.of<UserApp>(context);
    uid = user.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: AppColors.mainColor,
      ),
      body: Padding(
        padding: const  EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _productNameController,
                  decoration: textInputDecoration.copyWith(hintText: "Product Name"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the product name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: textInputDecoration.copyWith(hintText: "Description"),
                  maxLines: 7, // Set the maximum number of lines for text area
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: textInputDecoration.copyWith(hintText: "Price"),
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
                ListTile(
                  title:const Text('Image'),
                  subtitle: _image == null
                      ? const Text('No image selected')
                      : Image.file(_image!),
                  onTap: _selectImage,
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: textInputDecoration.copyWith(hintText: "Quantity"),
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
                ElevatedButton(
                  onPressed: _addProduct,
                  
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color?>(AppColors.mainColor),
                    
                  ),
                  child: const Text('Add Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

