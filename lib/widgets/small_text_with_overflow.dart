import 'package:flutter/material.dart';
import 'package:mammi/colors/colors.dart';
import 'package:mammi/utills/dimensions.dart';

/// this is for small text withoverflow, so long small text can fit in smaller areas
class SmallTextOverflow extends StatelessWidget {
  Color? color;
  final String text;
  final double size;
  double height;
  final TextOverflow overFlow;
  SmallTextOverflow({required this.text,
   this.color ,
   super.key,
   this.size =0,
   this.overFlow = TextOverflow.ellipsis,
   this.height = 1.2,
   });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: overFlow,
      style: TextStyle(
        color: color!= AppColors.textColor?color:AppColors.textColor,
        fontFamily: 'Roboto',
        fontSize: size==0?Dimensions.font12:size,
        height: height,
      ),
    );
  }
}