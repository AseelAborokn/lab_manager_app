import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab_manager/screens/authenticate/register.dart';
import 'package:lab_manager/services/auth.dart';
import 'package:lab_manager/shared/loading_spinner.dart';

import '../../shared/constants.dart';

class SignIn extends StatefulWidget {
  // const SignIn({
  //   Key? key,
  //   this.toggleView
  // }) : super(key: key);
  //
  // // Fields
  // final Function? toggleView;
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  // Text field states
  String email = "";
  String password = "";
  String error = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return (loading) ? const LoadingSpinner() : Scaffold(
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
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0,),
              TextFormField(
                decoration: getInputDecoration('Email'),
                validator: (val) => (val!.isEmpty) ? "Email cannot be empty!" : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              const SizedBox(height: 20.0,),
              TextFormField(
                decoration: getInputDecoration('Password'),
                validator: (val) => (val!.isEmpty) ? "Password cannot be empty!" : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              const SizedBox(height: 20.0,),
              ElevatedButton(
                child: const Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.green[400]),
                onPressed: () async {
                  // Sign Up the user to firebase with email and password
                  if (_formKey.currentState!.validate()) {
                    setState(() => loading = true);
                    dynamic result = await _authService.signInWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() {
                        error = "Sorry, Invalid Credentials!";
                        loading = false;
                      });
                    }
                  }
                },
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
