import 'package:flutter/material.dart';
import 'package:lab_manager/screens/authenticate/authenticate.dart';
import 'package:lab_manager/services/auth.dart';

class NavigationDrawerWidget extends StatelessWidget {
  NavigationDrawerWidget({Key? key}) : super(key: key);
  static const double menuItemHeight = 48.0;
  final AuthService _authService = AuthService();
  final String name = "Aseel.Aborokn";
  final String email = "aseel.aborokn@gmail.com";
  final String urlImage = "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade900,
      child: ListView(
        children: <Widget>[
          buildHeader(name: name, email: email, urlImage: urlImage, onClicked: () {}),
          buildMenuItem(text: "Close", icon: Icons.arrow_back, onClicked: () => selectedItem(context, -1)),
          const Divider(color: Colors.white, endIndent: 15, indent: 15),
          buildMenuItem(text: "Home",
              icon: Icons.home,
              onClicked: () => selectedItem(context, 0)),
          buildMenuItem(text: "My Stations",
              icon: Icons.apps,
              onClicked: () => selectedItem(context, 1)),
          buildMenuItem(text: "My Logs",
              icon: Icons.history_edu,
              onClicked: () => selectedItem(context, 2)),
          const Divider(color: Colors.white, endIndent: 15, indent: 15),
          buildMenuItem(text: "Profile",
              icon: Icons.person,
              onClicked: () => selectedItem(context, 3)),
          const SizedBox(height: 150),
          TextButton.icon(
              onPressed: () async => await _authService.signOut(),
              icon: const Icon(Icons.logout, color: Colors.greenAccent,),
              label: const Text("Sign Out", style: TextStyle(color: Colors.greenAccent))
          )
        ],
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked
  }) {
    const hoveredColor = Colors.tealAccent;
    const white = Colors.white;
    return  ListTile(
      leading: Icon(icon, color: white),
      title: Text(text, style: const TextStyle(color: white)),
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        // Navigator.of(context).push(
        //     MaterialPageRoute(builder: (context) => const Home()));
        break;
      case 1:
        // Navigator.of(context).push(
        //     MaterialPageRoute(builder: (context) => const UserStations()));
        break;
      case 2:
        // Navigator.of(context).push(
        //     MaterialPageRoute(builder: (context) => const UserLogs()));
        break;
      case 3:
        // Navigator.of(context).push(
        //     MaterialPageRoute(builder: (context) => const UserProfile()));
        break;
      default:
    }
  }

  Widget buildHeader({
    required String name,
    required String email,
    required String urlImage,
    VoidCallback? onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Row(
            children: [
              const SizedBox(width: 20),
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: const TextStyle(fontSize: 20, color: Colors.greenAccent),
                  ),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 14, color: Colors.greenAccent),
                  )
                ],
              )
            ],
          ),
        )
      );
}

