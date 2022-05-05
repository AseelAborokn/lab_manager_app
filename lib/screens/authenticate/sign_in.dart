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
    return (loading) ? const LoadingSpinner() :  Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        // Title
        title: const Text('Sign In', style: TextStyle(color: Colors.teal)),
        centerTitle: true,
        // Application Bar Color
        backgroundColor: Colors.grey.shade900,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
          child: Form(
            child: Card(
              color: Colors.black12,
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 1.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Text Inputs
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // Email
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: const TextStyle(color: Colors.white),
                          hintText: "Email Address",
                          hintStyle: const TextStyle(color: Colors.white),
                          suffixIcon: const Icon(Icons.email, color: Colors.greenAccent),
                          suffixIconColor: Colors.tealAccent,
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                  color: Colors.greenAccent,
                                  width: 1
                              )
                          ),
                        ),
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      // Password
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: const TextStyle(color: Colors.white),
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Colors.white),
                          suffixIcon: const Icon(Icons.password, color: Colors.greenAccent),
                          suffixIconColor: Colors.tealAccent,
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                  color: Colors.greenAccent,
                                  width: 1
                              )
                          ),
                        ),
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Sign In
                      TextButton.icon(
                          onPressed: () async => await _authService.signInWithEmailAndPassword(email, password),
                          icon: const Icon(Icons.login, color: Colors.greenAccent,),
                          label: const Text("Sign In", style: TextStyle(color: Colors.greenAccent))
                      ),
                      const SizedBox(width: 60),
                      // Register
                      TextButton.icon(
                          onPressed: () => Navigator.of(context).pushNamed("/authenticate/register"),
                          icon: const Icon(Icons.person, color: Colors.greenAccent,),
                          label: const Text("Don't have an account?", style: TextStyle(color: Colors.greenAccent))
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
