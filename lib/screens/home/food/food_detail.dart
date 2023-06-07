import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../colors/colors.dart';
import '../../../models/cart.dart';
import '../../../models/product.dart';
import '../../../models/user.dart';
import '../../../utills/dimensions.dart';
import '../../../widgets/app_icon.dart';
import '../../../widgets/big_text.dart';
import '../../../widgets/expanding_text_widget.dart';
import '../../../widgets/icon_text_widget.dart';

class FoodDetail extends StatefulWidget {
  final Product product;
  const FoodDetail({super.key, required this.product});

  @override
  State<FoodDetail> createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail> {
  int quantity = 1;

  double get totalPrice => widget.product.price! * quantity;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserApp>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // background image
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: Dimensions.popularFoodImgSize,
              decoration:  BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    widget.product.imageUrl!,
                  ),
                ),
              ),
            ),
          ), 
          // icon row
          Positioned(
            top: Dimensions.height45,
            left: Dimensions.width20,
            right:Dimensions.width20 ,
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child:const  AppIcon(icon: Icons.arrow_back),
                ),
                GestureDetector(
                  onTap: () {
                     // Add the product to the cart
                    Cart cartItem = Cart(
                      cartId: '', // Generate a unique cartId using a UUID package or Firestore auto-generated ID
                      userId: user.uid, // Replace with the actual user ID
                      productId: widget.product.id!,
                      quantity: quantity,
                      contactNumber: "null",
                    );

                    // Perform the necessary logic to add the cart item to the cart collection
                    FirebaseFirestore.instance
                        .collection('cart')
                        .add(cartItem.toJson())
                        .then((_) {
                      // Show a confirmation message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Product added to cart')),
                      );
                    }).catchError((error) {
                      // Show an error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error adding product to cart: $error')),
                      );
                    });
                  },
                  child: const AppIcon(icon: Icons.add_card_outlined)
                ),
              ],
            ),
          ),
          //food detail description
          Positioned(
            left: 0,
            right: 0,
            bottom: 0, 
            top: Dimensions.popularFoodImgSize-Dimensions.height20,
            child: Container(
              padding: EdgeInsets.only(top: Dimensions.height10,left: Dimensions.width20, right: Dimensions.width20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Dimensions.radius20),
                  topLeft: Radius.circular(Dimensions.radius20),
                ),
                color: Colors.white,
              ),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconAndTextWidget(icon: Icons.production_quantity_limits_outlined, text: "${widget.product.quantity} available", iconColor: AppColors.iconColor1),
                      IconAndTextWidget(icon: Icons.price_check, text: "${widget.product.price} FCFA", iconColor: AppColors.mainColor),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20,),
                  BigText(text: widget.product.name!, color:Colors.black),
                  SizedBox(height: Dimensions.height20,),
                  Expanded(
                     child: SingleChildScrollView(
                      child: ExpandableText(text: widget.product.description!),
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
          

        ],
      ),
      bottomNavigationBar: Container(
        height:Dimensions.height20*5,
        padding: EdgeInsets.only(top: Dimensions.height20, bottom: Dimensions.height20, right: Dimensions.width10,left: Dimensions.width10),
        decoration: BoxDecoration(
          color: AppColors.buttonBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radius20*2) ,
            topRight: Radius.circular(Dimensions.radius20*2),
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                  ),
                  Text(quantity.toString()),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                  ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: Dimensions.height20, bottom: Dimensions.height20, left: Dimensions.width10/2, right: Dimensions.width10/2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                color: AppColors.mainColor,
              ),
              child: BigText(text: "Total: ${totalPrice.toString()} |FCFA", color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}