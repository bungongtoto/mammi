import 'package:flutter/material.dart';
import 'package:mammi/screens/authenticate/forgot_password.dart';
import 'package:mammi/services/auth.dart';
import 'package:mammi/shared/constants.dart';
import 'package:mammi/shared/loading.dart';
import 'package:mammi/colors/colors.dart';
import 'package:mammi/utills/dimensions.dart';
import 'package:mammi/widgets/big_text.dart';


class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({super.key,required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading  = false;

  // text fields

  String email = '';
  String password = '';
  String error = '';
  
  @override
  Widget build(BuildContext context) {
    return loading ?const Loading() : Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                SizedBox(height: Dimensions.height30,),
                Container(
                      width: Dimensions.listViewIm,
                      height: Dimensions.listViewIm,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                        color: Colors.white38,
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            "assets/images/logo.jpg",
                          ),
                        ),
                      ),
                    ),
                // the title
                const BigText(text: "MAMMI", color: AppColors.mainColor),    
                SizedBox(height: Dimensions.height10,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator:(val) => val!.isEmpty ? 'Enter an email' : null ,
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
                const SizedBox(height: 20.0,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  obscureText: true,
                  validator:(val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null ,
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),
                const SizedBox(height: 10.0,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context){
                          return const ForgotPasswordPage();
                          
                        }
                        ),
                        );
                      },
                      child: const Text('Forgot Password?',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0,),
                ElevatedButton(
                  
                  onPressed: () async {
                   if (_formkey.currentState!.validate()){
                    setState(() {
                      loading = true;
                    });
                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                      if (result == null){
                        setState(() {
                          error = 'could sign with those credentials';
                          loading = false;
                        });
                      }
                    }
                  }, 
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color?>(AppColors.mainColor),
                    
                  ),
                  
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12,),
                Text(
                  error,
                  style: const TextStyle(color: Colors.red,fontSize: 14.0 ),
                ),
                const Text('Sign in with Google'),
                TextButton(
                  child:Container(
                      width: Dimensions.listViewIm,
                      height: Dimensions.listViewIm,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                        color: Colors.white38,
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            "assets/images/google-g-2015-logo-png-transparent.png",
                          ),
                        ),
                      ),
                    ),
                  onPressed: () async{
                     setState(() {
                      loading = true;
                    });
                      dynamic result = await _auth.signInWithGoogle();
                      print('result :: ${result.toString()}');
                      if (result == null){
                        setState(() {
                          error = 'could sign with those credentials';
                          loading = false;
                        });
                      }
                    }
                    //AuthService().signInWithGoogle();
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Dont have an Account?'),
                    TextButton(
                      child: const Text('Click Here to register') ,
                      //label: const Text('Dont have an Account? Click Here and register'),
                      onPressed: (){
                        widget.toggleView();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}