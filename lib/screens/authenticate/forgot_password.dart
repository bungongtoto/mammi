import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mammi/colors/colors.dart';
import 'package:mammi/shared/constants.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose(){
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      // ignore: use_build_context_synchronously
      showDialog(
        context: context, 
        builder: (context){
          return const AlertDialog(
            content: Text('password reset link sent! check your email'),
          );
        }
      );
    }on FirebaseAuthException catch(e){
      showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        elevation: 0,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('Please enter your email and we will send a password reset link.', textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),
          ),
          const SizedBox(height: 20.0,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: _emailController ,
               decoration: textInputDecoration.copyWith(hintText: 'Email'),
            ),
          ),
          const SizedBox(height: 20.0,),
          MaterialButton (
            onPressed:()async => await passwordReset(),
            color: AppColors.mainColor,
            textColor: Colors.white,
            child: const Text('Reset Password', style: TextStyle(fontWeight: FontWeight.bold),),
          ),
        ],
      ),
    );
  }
}