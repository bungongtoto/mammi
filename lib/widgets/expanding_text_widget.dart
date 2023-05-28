import 'package:flutter/material.dart';
import 'package:mammi/colors/colors.dart';
import 'package:mammi/utills/dimensions.dart';
import 'package:mammi/widgets/small_text.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  const ExpandableText({super.key, required this.text});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  late String firtsHalf;
  late String secondHalf;

  bool hiddenText = true;

  @override
  void initState(){
    super.initState();
    if(widget.text.length> textHeight){
      firtsHalf = widget.text.substring(0,textHeight.toInt());
      secondHalf = widget.text.substring(textHeight.toInt()+1, widget.text.length);

    }else{
      firtsHalf = widget.text;
      secondHalf = "";
    }
  }

  double textHeight = Dimensions.screenHeight/5.63;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty?SmallText(text: firtsHalf, size: Dimensions.font16, color: AppColors.paraColor,):Column(
        children: [
          SmallText(text:hiddenText?("$firtsHalf..."):(firtsHalf + secondHalf), size: Dimensions.font16,color: AppColors.paraColor,),
          InkWell(
            onTap: (){
              setState(() {
                hiddenText = !hiddenText;
              });
            },
            child:  Row(
              children: [
                SmallText(text:hiddenText? "show more":"show less", color:AppColors.mainColor, size: Dimensions.font16,),
                Icon(hiddenText?Icons.arrow_drop_down:Icons.arrow_drop_up, color: AppColors.mainColor,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}