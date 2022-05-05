import 'package:flutter/material.dart';
import 'package:lab_manager/screens/authenticate/register.dart';
import 'package:lab_manager/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);
  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  // bool showSignIn = true;
  // void toggleView() {
  //   setState(() => showSignIn = !showSignIn);
  // }
  @override
  Widget build(BuildContext context) {
    return SignIn();
    // if (showSignIn) {
    //   return SignIn(toggleView: toggleView );
    // } else {
    //   return  Register(toggleView: toggleView);
    // }
  }
}
