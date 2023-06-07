import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mammi/models/product.dart';
import 'package:mammi/colors/colors.dart';

import '../../../utills/dimensions.dart';
import '../../../widgets/big_text.dart';
import '../../../widgets/icon_text_widget.dart';
import '../../../widgets/small_text.dart';
import '../../../widgets/small_text_with_overflow.dart';
import 'food_detail.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  late List<Product> products;
  late List<Product> filteredProducts;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredProducts = [];
    fetchProducts();
  }

  void fetchProducts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('products').get();

    setState(() {
      products = querySnapshot.docs
          .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      filteredProducts = products;
    });
  }

  void filterProducts(String query) {
    setState(() {
      filteredProducts = products
          .where((product) =>
              product.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
        backgroundColor:AppColors.mainColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => filterProducts(value),
              decoration: const InputDecoration(
                fillColor: Colors.white,
                  filled: true,
                  // enabledBorder: OutlineInputBorder(
                  //   borderSide: BorderSide(color: Colors.black, width: 2.0),
                  // ),
              
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.mainColor, width: 2.0
                    ),
                  ), 
                labelText: 'Search by Product Name',
                prefixIcon: Icon(Icons.search, color: AppColors.mainColor,),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                Product product = filteredProducts[index];
                return GestureDetector(
                  onDoubleTap: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>   FoodDetail(product: product,)),
                    );
                  },
                  child: Container(
                  margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height10),
                  child: Row(
                    children: [
                      //Image section
                      Container(
                        width: Dimensions.listViewIm,
                        height: Dimensions.listViewIm,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radius20),
                          color: AppColors.mainColor,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              product.imageUrl!,
                            ),
                          ),
                          
                        ),
                      ),
                      
                      //Text container
                      Expanded(
                        child: Container(
                          height: Dimensions.listViewText,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(Dimensions.radius20),
                              bottomRight: Radius.circular(Dimensions.radius20),
                            ),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: Dimensions.width5,right: Dimensions.width10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BigText(text: "${product.name}", color: Colors.black,),
                                SizedBox(height: Dimensions.height10,),
                                SmallTextOverflow(text: "${product.description}"),
                                SizedBox(height: Dimensions.height10,),
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:  [
                                    IconAndTextWidget(icon: Icons.production_quantity_limits_outlined, text: "${product.quantity} available", iconColor: AppColors.iconColor1),
                                    IconAndTextWidget(icon: Icons.price_check, text: "${product.price} FCFA", iconColor: AppColors.mainColor),
                                  ],
                                ),
                                
                              ],
                            ),
                          ), 
                        ),
                      ),
                    ],
                  ),
                              ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
