import 'package:flutter/material.dart';
import 'package:mammi/widgets/big_text.dart';
import 'package:mammi/widgets/small_text.dart';

import '../colors/colors.dart';
import '../utills/dimensions.dart';
import 'icon_text_widget.dart';

/// this is general widget used arround the code that apears in several places
class AppColumn extends StatelessWidget {
  final String text;
   const AppColumn({
    super.key,
    required this.text,
    });

  @override
  Widget build(BuildContext context) {
    return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BigText(text: text, color:Colors.black, size:Dimensions.font26 ,),
                    SizedBox(height: Dimensions.height10),
                    Row(
                      children: [
                        Wrap(
                          children: List.generate(5, (index) => Icon(Icons.star, color: AppColors.mainColor,size: Dimensions.iconSize24,)),
                        ),
                        SizedBox(width: Dimensions.width10,),
                         SmallText(text: '4.7'),
                        SizedBox(width: Dimensions.width10,),
                        SmallText(text: '1306'),
                        SizedBox(width: Dimensions.width10,),
                        SmallText(text: 'Comments'),
    
                      ],
                    ),
                    SizedBox(height: Dimensions.height10,),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconAndTextWidget(icon: Icons.circle_sharp, text: 'Normal', iconColor: AppColors.iconColor1),
                        IconAndTextWidget(icon: Icons.location_on, text: '4.1km', iconColor: AppColors.mainColor),
                        IconAndTextWidget(icon: Icons.access_time_filled_rounded, text: '12mins', iconColor: AppColors.iconColor2),
                        
                      ],
                    ),
                  ],
                );
  }              
}