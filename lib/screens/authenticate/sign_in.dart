import 'package:flutter/material.dart';
import 'package:lab_manager/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({
    Key? key,
    this.toggleView
  }) : super(key: key);

  // Fields
  final Function? toggleView;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();

  // Text field states
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green[500],
        elevation: 0.0,
        title: const Text('Sign In To LabManager'),
        actions: <Widget>[
          TextButton.icon(
            // Switching to Register screen
            onPressed: () {
              if(widget.toggleView != null) {
                widget.toggleView!();
              }
            },
            icon: Icon(Icons.person),
            label: Text('Register')
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        // child: ElevatedButton(
        //   child: const Text('Sign In Anonymously'),
        //   onPressed: () async {
        //     dynamic user = await _authService.signInAnonymously();
        //
        //     if (user == null) {
        //       print("Failed Signing In");
        //     } else {
        //       print("Signed In Successfully");
        //       print("userUID = " + user.uid);
        //     }
        //   },
        // ),
        child: Form(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0,),
              TextFormField(
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              const SizedBox(height: 20.0,),
              TextFormField(
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              const SizedBox(height: 20.0,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[400],
                ),
                onPressed: () async {
                  // Sign Up the user to firebase
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
