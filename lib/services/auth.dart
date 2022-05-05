import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lab_manager/models/lab_user.dart';
import 'package:lab_manager/services/firestore/users_db.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UsersCollection _usersCollection = UsersCollection();

  // Auth change user stream
  // TODO("Should get the lab_user from the DBs")
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges();
  }

  // Sign-In email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (user == null) return null;
      return await _usersCollection.getByUid(user.uid).then((value) => value);
    } catch(error) {
      print("signInWithEmailAndPassword(String, String) FAILED!");
      print(error.toString());
    }
  }

  // Register email & password
  Future registerWithEmailAndPassword(
      String email,
      String password,
      String username,
      String cid,
      String phoneNumber,
      ) async {
    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (user == null) return null;

      // TODO("Check if possible to Register")
      final Future<LabUser?> labUserResult = _usersCollection.register(LabUser(uid: user.uid, username: username, email: email, cid: cid, phoneNumber: phoneNumber))
          .then((value) => _usersCollection.getByUid(user.uid)).then((value) => value);
      return await labUserResult;
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