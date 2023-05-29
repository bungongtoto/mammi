import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mammi/models/user.dart';


class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj base on FirebaseUser(User)
  UserApp? _userFromFirebaseUser(User? user){
    return user != null ? UserApp(uid: user.uid) : null;
  }
  
  // auth change user stream
  Stream<UserApp?> get user {
    return _auth.authStateChanges().map((event) => _userFromFirebaseUser(event));
  }

  

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //register with email & password
  Future registerWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async{
    try{
      return await FirebaseAuth.instance.signOut();
    }catch(e){
      return null;
    }
  }

  // sign in with google
  Future signInWithGoogle() async{
    // Triger the auth flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      scopes: <String>["email"]).signIn();

     // obtain the auth details from the request
     final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

     //Create a new credential 
     final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
     );

     try {
      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;
      return _userFromFirebaseUser(user);
     } catch (e) {
      print(e.toString());
      return null;
    }
  }

}