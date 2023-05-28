import 'package:flutter/material.dart';
import 'package:mammi/colors/colors.dart';
import 'package:mammi/services/auth.dart';
import 'package:mammi/shared/constants.dart';
import 'package:mammi/shared/loading.dart';
import 'package:mammi/utills/dimensions.dart';
import 'package:mammi/widgets/big_text.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  const Register({super.key,required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  // text fields

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ?const Loading() : Scaffold(
      backgroundColor: Colors.white,
      
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50),
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
                            "assets/images/Mlogo.jpg",
                          ),
                        ),
                      ),
                    ),
                // the title
                BigText(text: "MAMMI", color: AppColors.mainColor),
                const SizedBox(height: 20.0,),
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
                const SizedBox(height: 20.0,),
                ElevatedButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()){
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _auth.registerWithEmailAndPassword(email,password);
                      if (result == null){
                        setState(() {
                          loading = false;
                          error = 'Please supply a valid email';
                        });
                      }
                    }
                  }, 
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color?>(AppColors.mainColor),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12.0,),
                Text(
                  error,
                  style: const TextStyle(color: Colors.red,fontSize: 14.0 ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text('Have an Account? Sign '),
                  onPressed: (){
                    widget.toggleView();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}