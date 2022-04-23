import 'package:flutter/material.dart';
import 'package:lab_manager/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green[500],
        elevation: 0.0,
        title: const Text('Sign In To LabManager'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: ElevatedButton(
          child: const Text('Sign In Anonymously'),
          onPressed: () async {
            dynamic user = await _authService.signInAnonymously();

            if (user == null) {
              print("Faile Signing In");
            } else {
              print("Signed In Successfully");
              print(user);
            }
          },
        ),
      ),
    );
  }
}
