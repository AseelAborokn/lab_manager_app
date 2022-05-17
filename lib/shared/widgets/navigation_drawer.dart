import 'package:flutter/material.dart';
import 'package:lab_manager/models/lab_user.dart';
import 'package:lab_manager/screens/home/my_activity_logs.dart';
import 'package:lab_manager/screens/home/pending_permission_requests.dart';
import 'package:lab_manager/screens/home/profile_settings.dart';
import 'package:lab_manager/screens/home/user_stations.dart';
import 'package:lab_manager/services/auth.dart';

class NavigationDrawerWidget extends StatelessWidget {
  NavigationDrawerWidget({Key? key, required this.labUser}) : super(key: key);

  static const double menuItemHeight = 48.0;
  final AuthService _authService = AuthService();
  final LabUser labUser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade900,
      child: ListView(
        children: <Widget>[
          buildHeader(name: labUser.username, email: labUser.email, onClicked: () {}),
          buildMenuItem(text: "Close", icon: Icons.arrow_back, onClicked: () => selectedItem(context, -1)),
          const Divider(color: Colors.white, endIndent: 15, indent: 15),
          buildMenuItem(text: "Home",
              icon: Icons.home,
              onClicked: () => selectedItem(context, 0)),
          buildMenuItem(text: "My Stations",
              icon: Icons.apps,
              onClicked: () => selectedItem(context, 1)),
          buildMenuItem(text: "My Activity Logs",
              icon: Icons.history_edu,
              onClicked: () => selectedItem(context, 2)),
          const Divider(color: Colors.white, endIndent: 15, indent: 15),
          buildMenuItem(text: "Pending Requests",
              icon: Icons.pending_actions_sharp,
              onClicked: () => selectedItem(context, 3)),
          buildMenuItem(text: "Profile Settings",
              icon: Icons.settings,
              onClicked: () => selectedItem(context, 4)),
          Column(
            children: [
              TextButton.icon(
                onPressed: () async => await _authService.signOut(),
                icon: const Icon(Icons.logout, color: Colors.greenAccent,),
                label: const Text("Sign Out", style: TextStyle(color: Colors.greenAccent))
              ),
            ]
          )
        ],
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    String subtitle = "",
    VoidCallback? onClicked
  }) {
    const white = Colors.white;
    return  ListTile(
      leading: Icon(icon, color: white),
      title: Text(text, style: const TextStyle(color: white)),
      subtitle: Text(subtitle, style: const TextStyle(color: white)),
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
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MyStations(labUser: labUser)));
        break;
      case 2:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MyActivityLogs(labUser: labUser)));
        break;
      case 3:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PendingPermissionRequestsManager(labUser: labUser)));
        break;
      case 4:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProfileSettings(labUser: labUser)));
        break;
      default:
    }
  }

  Widget buildHeader({
    required String name,
    required String email,
    VoidCallback? onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Row(
            children: [
              const SizedBox(width: 20),
              // CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
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

