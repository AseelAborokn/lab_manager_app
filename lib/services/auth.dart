import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;



  // Sign-In Anonymously
  Future signInAnonymously() async {
    try {
      UserCredential result = await _firebaseAuth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch(error) {
      print("signInAnonymously FAILED!");
      print(error.toString());
      return null;
    }
  }

  // Sign-In email & password

  // Register email & password

  // Sign-Out
}