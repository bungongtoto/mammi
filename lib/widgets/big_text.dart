import 'package:flutter/material.dart';
import 'package:mammi/utills/dimensions.dart';

/// this is general widget for big Text that text varouis characteristics used arround the code that apears in several places
class BigText extends StatelessWidget {
  final Color? color;
  final String text;
  final double size;
   final TextOverflow overFlow;
   const BigText({required this.text,
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