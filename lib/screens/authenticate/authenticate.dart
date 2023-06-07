import 'package:flutter/material.dart';
import 'package:mammi/screens/authenticate/register.dart';
import 'package:mammi/screens/authenticate/sign_in.dart';

/// The [Authenticate] class is a StatefulWidget responsible for managing the authentication flow of the app.
class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

/// The private [_AuthenticateState] class is the state of the [Authenticate] widget.
class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true; // Variable to track whether to show Sign In or Register screen

  /// Function to toggle between Sign In and Register screens
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn; // Invert the value of showSignIn
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      // If showSignIn is true, display the Sign In screen
      return SignIn(toggleView: toggleView);
    } else {
      // If showSignIn is false, display the Register screen
      return Register(toggleView: toggleView);
    }
  }
}
