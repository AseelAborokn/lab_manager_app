import 'package:flutter/material.dart';
import 'package:lab_manager/services/auth.dart';

import '../../shared/widgets/navigation_drawer.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        // Title
        title: const Text('LabManager', style: TextStyle(color: Colors.teal)),
        centerTitle: true,
        // Application Bar Color
        backgroundColor: Colors.grey.shade900,
        // Menu Drawer styling
        leading: Builder(
          builder: (context) => IconButton(
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
      body: Container(
          child: null
      ),
    );
  }
}
