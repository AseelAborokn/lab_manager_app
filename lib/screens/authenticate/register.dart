import 'package:flutter/material.dart';
import '../../services/auth.dart';

class Register extends StatefulWidget {
  const Register({
    Key? key,
    this.toggleView
  }) : super(key: key);

  // Fields
  final Function? toggleView;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  // Text field states
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green[500],
        elevation: 0.0,
        title: const Text('Sign Up To LabManager'),
        actions: <Widget>[
          TextButton.icon(
            // Switching to Sign In screen
            onPressed: () {
              if(widget.toggleView != null) {
                widget.toggleView!();
              }
            },
            icon: const Icon(Icons.person),
            label: const Text('Sign In')
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
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0,),
              TextFormField(
                validator: (val) => (val!.isEmpty) ? "Email cannot be empty!" : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              const SizedBox(height: 20.0,),
              TextFormField(
                validator: (val) => (val!.isEmpty) ? "Password cannot be empty!" : null,
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
                  if (_formKey.currentState!.validate()) {
                    dynamic result = await _authService.registerWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() => error = "Please Supply Valid Data!");
                    }
                  }
                },
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 12.0,),
              Text(
                error,
                style: TextStyle(color: Colors.red[700], fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
