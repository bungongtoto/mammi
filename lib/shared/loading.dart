import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mammi/colors/colors.dart';

/// this class proovides a loading screen used arround the application
class Loading extends StatelessWidget {

  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child:const Center(child: SpinKitFadingCircle(color: AppColors.mainColor, size: 50.0,)),
    );
  }
}