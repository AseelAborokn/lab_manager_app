import 'package:flutter/material.dart';
import 'package:lab_manager/services/auth.dart';
import 'package:lab_manager/shared/loading_spinner.dart';
import 'package:lab_manager/shared/results/registration_results.dart';

import '../../shared/widgets/background_image.dart';


class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();

  // Text field states
  String email = "";
  String password = "";

  String errorMessage = "";
  bool errorFound = false;
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
      resizeToAvoidBottomInset: false ,
      body: Container(
        decoration: BackGroundImage(),
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
                Wrap(
                    runSpacing: 10,
                    children: <Widget>[ // Email
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
                          enabledBorder: OutlineInputBorder(
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
                          enabledBorder: OutlineInputBorder(
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
                      )
                    ]
                ),
                // Buttons
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Sign In
                      TextButton.icon(
                        onPressed: () async {
                          setState(() => loading = true);
                          RegistrationResult result = await _authService.signIn(email, password);
                          if (result.labUser != null) {
                            if(!mounted) return;
                            Navigator.of(context).pop();
                          }
                          else {
                            setState(() {
                              errorFound = true;
                              errorMessage = result.errorMessage ?? "Failed To Login, Please Retry Latter";
                            });
                          }
                          setState(() => loading = false);
                        },
                        icon: const Icon(Icons.login, color: Colors.greenAccent,),
                        label: const Text("Sign In", style: TextStyle(color: Colors.greenAccent)),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.lightBlue.shade900)
                        ),
                      ),
                      // Small Space In Between
                      const SizedBox(width: 20,),
                      // Register
                      TextButton.icon(
                        onPressed: () => Navigator.of(context).pushNamed("/authenticate/register"),
                        icon: const Icon(Icons.person, color: Colors.greenAccent,),
                        label: const Text("Don't have an account?", style: TextStyle(color: Colors.greenAccent)),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.lightBlue.shade900)
                        )
                      )
                    ],
                  ),
                ),
                // Error Messages
                Center(
                  child: (errorFound)
                      ? Text(errorMessage, style: const TextStyle(fontSize: 15, color: Colors.deepOrange),)
                      : const Text(""),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
