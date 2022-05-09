import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab_manager/models/lab_user.dart';
import 'package:lab_manager/services/firestore/users_db.dart';
import 'package:lab_manager/shared/loading_spinner.dart';
import 'package:provider/provider.dart';

import '../../shared/widgets/navigation_drawer.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    print("user id = ${user?.uid}");
    return StreamBuilder<LabUser?>(
      stream: UsersCollection().getCurrentLabUser(user?.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          LabUser labUser = snapshot.data!;
          return Scaffold(
            backgroundColor: Colors.grey.shade800,
            drawer: NavigationDrawerWidget(labUser: labUser),
            appBar: AppBar(
              // Title
              title: const Text('LabManager', style: TextStyle(color: Colors.teal)),
              centerTitle: true,
              // Application Bar Color
              backgroundColor: Colors.grey.shade900,
              // Menu Drawer styling
              leading: Builder(
                builder: (context) =>
                    IconButton(
                      icon: const Icon(Icons.menu),
                      color: Colors.teal,
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
              ),
              // Profile Icon
              actions: const <Widget>[],
            ),
            body: Text("Welcome ${labUser.username}"),
          );
        } else {
          return const LoadingSpinner();
        }
      }
    );
  }
}
