import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lab_manager/models/lab_user.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Create a LabUser object based on Firebase-User object
  LabUser? _labUserFromFirebaseUser(User? user) {
    return user != null ? LabUser(uid: user.uid, authId: ""): null;
  }

  // Auth change user stream
  Stream<LabUser?> get user {
    return _firebaseAuth.authStateChanges()
    .map(_labUserFromFirebaseUser);
  }

  // Sign-In Anonymously
  Future signInAnonymously() async {
    try {
      UserCredential result = await _firebaseAuth.signInAnonymously();
      User? user = result.user;
      return _labUserFromFirebaseUser(user);
    } catch(error) {
      print("signInAnonymously() FAILED!");
      print(error.toString());
      return null;
    }
  }

  // Sign-In email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _labUserFromFirebaseUser(user);
    } catch(error) {
      print("signInWithEmailAndPassword(String, String) FAILED!");
      print(error.toString());
    }
  }

  // Register email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _labUserFromFirebaseUser(user);
    } catch(error) {
      print("registerWithEmailAndPassword(String, String) FAILED!");
      print(error.toString());
    }
  }

  // Sign-Out
  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch(error) {
      print("signOut() FAILED!");
      print(error.toString());
    }
  }
}