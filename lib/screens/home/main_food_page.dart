import 'package:flutter/material.dart';
import 'package:mammi/models/product.dart';
import 'package:mammi/screens/home/food_page_body.dart';
import 'package:mammi/utills/dimensions.dart';
import 'package:mammi/widgets/small_text.dart';
import 'package:mammi/services/auth.dart';
import 'package:provider/provider.dart';

import '../../colors/colors.dart';
import '../../models/user.dart';
import '../../services/database.dart';
import '../../widgets/big_text.dart';

/// The main page for displaying food-related content.
class MainFoodPage extends StatefulWidget {
  const MainFoodPage({super.key});

  @override
  State<MainFoodPage> createState() => _MainFoodPageState();
}

class _MainFoodPageState extends State<MainFoodPage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    //print('the curent height is : '+ MediaQuery.of(context).size.height.toString());
    final user = Provider.of<UserApp>(context);
    return StreamProvider<List<Product>?>.value(
      value: DatabaseService(user.uid).products,
      initialData: null,
      child: Scaffold(
        body: Column(
          children: [
            /// Showing the header
            Container(
              margin: EdgeInsets.only(
                top: Dimensions.height45,
                bottom: Dimensions.height15,
              ),
              padding: EdgeInsets.only(
                left: Dimensions.width20,
                right: Dimensions.width20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const BigText(
                        text: 'Cameroon',
                        color: AppColors.mainColor,
                      ),
                      Row(
                        children: [
                          SmallText(
                            text: 'Yaounde',
                            color: Colors.black,
                          ),
                          const Icon(Icons.arrow_drop_down_rounded),
                        ],
                      ),
                    ],
                  ),
                  Center(
                    child: Container(
                      width: Dimensions.width45,
                      height: Dimensions.height45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius15),
                        color: AppColors.mainColor,
                      ),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: Dimensions.iconSize24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /// Showing the body
            const Expanded(
              child: SingleChildScrollView(
                child: FoodPageBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
