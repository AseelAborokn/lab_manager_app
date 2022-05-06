import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab_manager/models/lab_user.dart';
import 'package:lab_manager/services/firestore/users_db.dart';
import 'package:lab_manager/shared/results/registration_results.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UsersCollection _usersCollection = UsersCollection();

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges();
  }

  // Sign-In email & password
  Future<RegistrationResult> signIn(String email, String password) async {
    try {
      // Authenticate the user
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if (user == null) return RegistrationResult(errorMessage: "Wrong Credentials!");

      // Map The Authenticated User To LabUser
      LabUser? labUser = await _usersCollection.getByUid(user.uid).then((value) => value);
      return RegistrationResult(labUser: labUser, errorMessage: "User Not Found!");
    } catch(error) {
      return RegistrationResult(errorMessage: "Failed To Sign In Please Retry Again!");
    }
  }

  // Register email & password
  Future<RegistrationResult> signUp(
      String email,
      String password,
      String username,
      String? cid,
      String phoneNumber,
      ) async {

    try {
      // Check if Email/Cid/Username are unique
      final String? error = await _checkUniqueInput(email, username, cid);
      if (error != null) return RegistrationResult(errorMessage: error);

      // Authenticate the email and password
      final UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      final User? user = result.user;
      if (user == null) return RegistrationResult(errorMessage: "Authentication Failed");

      // Register the LabUser to the LabUsers collection and retrieve the model
      final Future<LabUser?> labUserResult = _usersCollection.register(LabUser(uid: user.uid, username: username, email: email, cid: cid, phoneNumber: phoneNumber))
          .then((value) => _usersCollection.getByUid(user.uid)).then((value) => value);

      final labUser = await labUserResult;
      return RegistrationResult(labUser: labUser);
    } catch (e) {
      return RegistrationResult(errorMessage: e.toString());
    }

  }

  // Sign-Out
  Future<void> signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch(error) {
      print(error.toString());
    }
  }

  Future<String?> _checkUniqueInput(String email, String username, String? cid) async {
    if ((await _usersCollection.checkUniqueEmail(email)) != 0) {
      return "The Email is Already Taken!";
    }
    if ((await _usersCollection.checkUniqueCid(cid)) != 0) {
      return "The Cid is Already Taken!";
    }
    if ((await _usersCollection.checkUniqueUsername(username)) != 0) {
      return "The Username is Already Taken!";
    }

    return null;
  }
}