import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab_manager/models/lab_user.dart';
import 'package:lab_manager/services/firestore/users_db.dart';
import 'package:lab_manager/shared/results/registration_results.dart';

/// Authentication Service - Responsible to handle all firebaseAuth API requests.
class AuthService {
  /// [_firebaseAuth] - FirebaseAuth instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  /// [_usersCollection] - LabUsers collection.
  final UsersCollection _usersCollection = UsersCollection();

  /// Gets list of the authentication statuses of the current user.
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges();
  }

  /// SignIn user with the given [email] & [password]
  ///
  /// Returns [RegistrationResult].
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
  /// SignUp a new user with the given values.
  ///
  /// [email] - user's email.
  /// [password] - user's password.
  /// [username] - user's username.
  /// [cid] - user's card id.
  /// [phoneNumber] - user's phone number.
  ///
  /// Returns [RegistrationResult].
  Future<RegistrationResult> signUp(
    String email,
    String password,
    String username,
    String? cid,
    String phoneNumber,
  ) async {
    try {
      // Check if Email/Cid/Username are unique
      final String? error = await _checkUniqueInput(email, username, cid, null);
      if (error != null) return RegistrationResult(errorMessage: error);

      // Authenticate the email and password
      final UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      final User? user = result.user;
      if (user == null) {
        return RegistrationResult(errorMessage: "Authentication Failed");
      }

      // Register the LabUser to the LabUsers collection and retrieve the model
      final Future<LabUser?> labUserResult = _usersCollection.register(LabUser(
          uid: user.uid,
          username: username,
          email: email,
          cid: cid,
          phoneNumber: phoneNumber))
          .then((value) => _usersCollection.getByUid(user.uid)).then((
          value) => value);

      final labUser = await labUserResult;
      return RegistrationResult(labUser: labUser);
    } catch (e) {
      return RegistrationResult(errorMessage: e.toString());
    }
  }

  /// Update the users data!
  ///
  /// Returns [RegistrationResult].
  Future<RegistrationResult> update(
      String uid,
      String email,
      String username,
      String? cid,
      String phoneNumber,
      ) async {
    try {
      // Check if Email/Cid/Username are unique
      final String? error = await _checkUniqueInput(email, username, cid, uid);
      if (error != null) return RegistrationResult(errorMessage: error);

      // Register the LabUser to the LabUsers collection and retrieve the model
      final Future<LabUser?> labUserResult = _usersCollection.update(LabUser(
          uid: uid,
          username: username,
          email: email,
          cid: cid,
          phoneNumber: phoneNumber))
          .then((value) => _usersCollection.getByUid(uid)).then((
          value) => value);

      final labUser = await labUserResult;
      return RegistrationResult(labUser: labUser);
    } catch (e) {
      return RegistrationResult(errorMessage: e.toString());
    }
  }
  /// SignOut the current user from the application.
  Future<void> signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch(error) {
      print(error.toString());
    }
  }

  /// Checks if the given [email], [username], [cid] and [uid] are unique across all the documents in LabUsers collection.
  Future<String?> _checkUniqueInput(String email, String username, String? cid, String? uid) async {
    if ((await _usersCollection.checkUniqueEmail(email, uid)) != 0) {
      return "The Email is Already Taken!";
    }
    if ((await _usersCollection.checkUniqueCid(cid, uid)) != 0) {
      return "The Cid is Already Taken!";
    }
    if ((await _usersCollection.checkUniqueUsername(username, uid)) != 0) {
      return "The Username is Already Taken!";
    }

    return null;
  }
}