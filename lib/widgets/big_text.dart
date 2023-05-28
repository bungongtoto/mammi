import 'package:flutter/material.dart';
import 'package:mammi/utills/dimensions.dart';

class BigText extends StatelessWidget {
  final Color? color;
  final String text;
   double size;
   TextOverflow overFlow;
   BigText({required this.text,
   required this.color,
   super.key,
   this.overFlow = TextOverflow.ellipsis,
   this.size =0,
   });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: overFlow,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
        fontSize: size==0?Dimensions.font20:size,
      ),
    );
  }
}