import 'package:flutter/material.dart';
import 'package:lab_manager/screens/authenticate/authenticate.dart';
import 'package:lab_manager/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Authenticate();
  }
}
