import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lab_manager/models/lab_user.dart';
import 'package:lab_manager/services/firestore/users_db.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UsersCollection _usersCollection = UsersCollection();

  // Create a LabUser object based on Firebase-User object
  LabUser? _labUserFromFirebaseUser(User? user) {
    if (user != null) {
      return LabUser(uid: user.uid, email: '', username: '');
    } else {
      return null;
    }
  }

  // Auth change user stream
  // TODO("Should get the lab_user from the DBs")
  Stream<LabUser?> get user {
    return _firebaseAuth.authStateChanges()
    .map(_labUserFromFirebaseUser);
  }

  // Sign-In Anonymously
  // Future signInAnonymously() async {
  //   try {
  //     UserCredential result = await _firebaseAuth.signInAnonymously();
  //     User? user = result.user;
  //     return _labUserFromFirebaseUser(user);
  //   } catch(error) {
  //     print("signInAnonymously() FAILED!");
  //     print(error.toString());
  //     return null;
  //   }
  // }

  // Sign-In email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (user == null) return null;
      return await _usersCollection.getByUid(user.uid).then((value) => value);
      return _labUserFromFirebaseUser(user);
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