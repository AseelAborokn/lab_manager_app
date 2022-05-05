import 'package:flutter/material.dart';
import 'package:lab_manager/shared/loading_spinner.dart';
import 'package:email_validator/email_validator.dart';

import '../../services/auth.dart';
import '../../shared/constants.dart';

bool validPhoneNumber(String phoneNumber) {
  if (phoneNumber.length != 10) {
    return false;
  }
  return true;
}

bool validEmail(String email) {
  return EmailValidator.validate(email);
}

bool validCid(String cid) {
  return cid.length == 8;
}

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  // Text field states
  String email = "";
  String password = "";
  String username = "";
  String phoneNumber = "";
  String cid = "";
  String error = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return (loading) ? const LoadingSpinner() : Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        // Title
        title: const Text('Sign Up To LabManager', style: TextStyle(color: Colors.teal)),
        centerTitle: true,
        // Application Bar Color
        backgroundColor: Colors.grey.shade900,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
        child: Form(
          key: _formKey,
          child: Card(
            color: Colors.black12,
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 1.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Text Inputs
                Wrap(
                  runSpacing: 10,
                  children: <Widget>[
                    // username
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "User Name",
                        labelStyle: const TextStyle(color: Colors.white),
                        hintText: "username",
                        hintStyle: const TextStyle(color: Colors.white),
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
                        setState(() => username = val);
                      },
                      validator: (val) => (val == null || val.isEmpty) ? "Invalid username" : null,
                    ),
                    // PhoneNumber
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        labelStyle: const TextStyle(color: Colors.white),
                        hintText: "Phone Number",
                        hintStyle: const TextStyle(color: Colors.white),
                        suffixIcon: const Icon(Icons.phone, color: Colors.greenAccent),
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
                        setState(() => phoneNumber = val);
                      },
                      validator: (val) => (val == null || !validPhoneNumber(phoneNumber)) ? "Invalid Phone Number" : null,
                    ),
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
                      validator: (val) => (val == null || !validEmail(email)) ? "Invalid Email Address" : null,
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
                      validator: (val) => (val == null || val.length < 6) ? "Invalid Password" : null,
                    ),
                    // CID
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Card Id",
                        labelStyle: const TextStyle(color: Colors.white),
                        hintText: "Card Id",
                        hintStyle: const TextStyle(color: Colors.white),
                        suffixIcon: const Icon(Icons.credit_card, color: Colors.greenAccent),
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
                        setState(() => cid = val);
                      },
                      validator: (val) => (val == null || !validCid(cid)) ? "Invalid Password" : null,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Register
                    TextButton.icon(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _authService.registerWithEmailAndPassword(email, password, username, cid, phoneNumber);
                            if (result != null) {
                              Navigator.of(context).pop();
                            }
                            setState(() => loading = false);

                          }
                        },
                        icon: const Icon(Icons.app_registration, color: Colors.greenAccent,),
                        label: const Text("Register", style: TextStyle(color: Colors.greenAccent))
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
