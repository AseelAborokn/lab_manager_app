///@nodoc
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab_manager/models/lab_station.dart';
import 'package:lab_manager/models/lab_user.dart';
import 'package:lab_manager/screens/home/permissions.dart';
import 'package:lab_manager/screens/home/permissions_manager.dart';
import 'package:lab_manager/services/firestore/stations_db.dart';
import 'package:lab_manager/services/firestore/users_db.dart';
import 'package:lab_manager/shared/loading_spinner.dart';
import 'package:lab_manager/shared/widgets/activity_logs.dart';
import 'package:provider/provider.dart';

import '../../shared/widgets/background_image.dart';
import '../../shared/widgets/navigation_drawer.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final StationsCollection _stationsCollection = StationsCollection();

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
              title: const Text('LabManager', style: TextStyle(color: Colors.lightBlueAccent)),
              centerTitle: true,
              // Application Bar Color
              backgroundColor: Colors.grey.shade900,
              // Menu Drawer styling
              leading: Builder(
                builder: (context) =>
                    IconButton(
                      icon: const Icon(Icons.menu),
                      color: Colors.lightBlueAccent,
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
              ),
              // Profile Icon
              actions: const <Widget>[],
            ),
            body: Container(
              decoration:  backGroundImage(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Divider(),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey.shade600,
                        elevation: 20.0,
                        shadowColor: Colors.lightBlueAccent,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Permissions(labUser: labUser)));
                      },
                      child: const Text("Request Permissions To Access Stations", style: TextStyle(fontSize: 15))
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey.shade600,
                          elevation: 20.0,
                          shadowColor: Colors.lightBlueAccent
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => PermissionsManager(labUser: labUser)));
                        },
                        child: const Text("Manage Permissions To Access Stations", style: TextStyle(fontSize: 15))
                    ),
                  ),
                  Divider(),
                  Container(
                    // margin: const EdgeInsets.fromLTRB(10, 350, 10, 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey.shade600,
                          elevation: 20.0,
                          shadowColor: Colors.lightBlueAccent,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => StreamBuilder<List<LabStation>>(
                                stream: _stationsCollection.getStationsByOwnerId(labUser.uid),
                                builder: (context, AsyncSnapshot<List<LabStation>> stationsSnapShot) {
                                  if (stationsSnapShot.hasData ) {
                                    return ActivityLogs(labUser: labUser, title: "My Stations Activity logs", showMyUsagesOnly: false, myStations: stationsSnapShot.data);
                                  }
                                  return ActivityLogs(labUser: labUser, title: "My Stations Activity logs", showMyUsagesOnly: false);
                                }
                              )));
                        },
                        child: const Text("Check My Stations Usages History", style: TextStyle(fontSize: 15),)
                    ),
                  ),
                  Divider(),
                ],
              ),
            )
          );
        } else {
          return const LoadingSpinner();
        }
      }
    );
  }
}
