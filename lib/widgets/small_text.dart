import 'package:flutter/material.dart';
import 'package:mammi/colors/colors.dart';
import 'package:mammi/utills/dimensions.dart';

/// SmallText is a general form for small text in the app
class SmallText extends StatelessWidget {
  Color? color;
  final String text;
  final double size;
  double height;
  SmallText({required this.text,
   this.color ,
   super.key,
   this.size =0,
   this.height = 1.2,
   });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color!= AppColors.textColor?color:AppColors.textColor,
        fontFamily: 'Roboto',
        fontSize: size==0?Dimensions.font12:size,
        height: height,
      ),
    );
  }
}