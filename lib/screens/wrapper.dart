import 'package:flutter/material.dart';
import 'package:lab_manager/models/lab_user.dart';
import 'package:lab_manager/screens/authenticate/authenticate.dart';
import 'package:lab_manager/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final labUser = Provider.of<LabUser?>(context);

    if (labUser == null) {
      print(labUser);
      return Authenticate();
    } else {
      print(labUser.uid);
      return Home();
    }
  }
}
