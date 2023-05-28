import 'package:get/get.dart';
import 'package:mammi/screens/home/my_home_page.dart';
import 'authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mammi/models/user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserApp?>(context);
    
    // return either home or authenticate widget
    if (user == null){
      return const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: Authenticate(),
      );
    }else {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home:  MyHomePage(),
      );
    }

  }  
}