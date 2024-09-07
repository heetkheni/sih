import 'package:firebase_auth/firebase_auth.dart';
import 'package:sih_practice/services/database_services.dart';

class AuthServices {
  
  final _auth = FirebaseAuth.instance;

  //login
  Future loginUserwithEmailandPAssword(String email, String password) async {
    try {
      UserCredential user = await (_auth.signInWithEmailAndPassword(
          email: email, password: password));
      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //register
  Future signUpUserwithEmailandPAssword(
      String fullName, String email, String password , String token , String city) async {
    try {
      UserCredential user = await (_auth.createUserWithEmailAndPassword(
          email: email, password: password));
      if (user != null) {
        //call our database service to update the user data
        await DatabaseServices(uid: user.user!.uid)
            .saveUserData(fullName, email , token);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
