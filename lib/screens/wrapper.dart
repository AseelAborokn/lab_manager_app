import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab_manager/models/lab_user.dart';
import 'package:lab_manager/screens/authenticate/authenticate.dart';
import 'package:lab_manager/screens/home/home.dart';
import 'package:provider/provider.dart';

/// This Widget will lister for events and do some basic routing, like:
/// 1. if user is authenticated -> Home()
/// 2. if user is not authenticated -> Authenticate()
class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      print(user);
      return const Authenticate();
    } else {
      print(user.uid);
      return const Home();
    }
  }
}
