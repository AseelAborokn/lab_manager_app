import 'package:flutter/material.dart';
import 'package:lab_manager/models/lab_permissions.dart';
import 'package:lab_manager/models/lab_station.dart';
import 'package:lab_manager/models/lab_user.dart';
import 'package:lab_manager/services/firestore/stations_db.dart';
import 'package:lab_manager/services/firestore/users_db.dart';
import 'package:tuple/tuple.dart';

import '../../services/firestore/permissions_db.dart';

class PermissionRequestsManager extends StatefulWidget {
  PermissionRequestsManager({Key? key, required this.labUser}) : super(key: key);

  final LabUser labUser;
  final PermissionsCollection _permissionsCollection = PermissionsCollection();
  final UsersCollection _usersCollection = UsersCollection();
  final StationsCollection _stationsCollection = StationsCollection();
  @override
  State<PermissionRequestsManager> createState() => _PermissionRequestsManagerState();
}

class _PermissionRequestsManagerState extends State<PermissionRequestsManager> {
  @override
  Widget build(BuildContext context) {
    final String ownerId = widget.labUser.uid;
    final List<String> columns = ['Station', 'Requester', 'Accept/Decline'];
    return StreamBuilder<List<AccessPermissions>>(
        stream: widget._permissionsCollection.getAccessPermissionsByOwnerId(ownerId),
        builder: (context, AsyncSnapshot<List<AccessPermissions>> pendingReqSnapshots) {
          List<AccessPermissions> pendingRequests = [];
          if (!pendingReqSnapshots.hasData && pendingReqSnapshots.data != null) {
            pendingRequests = pendingReqSnapshots.data!.where((req) => req.permissionStatus == AccessPermissionStatus.requested).toList();
          }

          return StreamBuilder<List<LabUser>>(
              stream: widget._usersCollection.getAllLabUser(),
              builder: (context, AsyncSnapshot<List<LabUser>> usersSnapshot) {
                List<LabUser> users = [];
                if (usersSnapshot.hasData && usersSnapshot.data != null) {
                  users = usersSnapshot.data!;
                }

                return StreamBuilder<List<LabStation>>(
                    stream: widget._stationsCollection.getStationsByOwnerId(ownerId),
                    builder: (context, AsyncSnapshot<List<LabStation>> stationsSnapshot) {
                      List<LabStation> stations = [];
                      if (stationsSnapshot.hasData && stationsSnapshot.data != null) {
                        stations = stationsSnapshot.data!;
                      }

                      List<Tuple3<AccessPermissions, String, String>> joinedLists =
                      pendingRequests.map((req) => Tuple3(
                              req,
                              users.firstWhere((user) => (user.uid == req.userId)).username,
                              stations.firstWhere((station) => (station.uid == req.stationId)).name
                          )
                      ).toList();


                      return Scaffold(
                          backgroundColor: Colors.grey.shade800,
                          appBar: AppBar(
                            // Title
                            title: const Text('Pending Requests', style: TextStyle(color: Colors.teal)),
                            centerTitle: true,
                            // Application Bar Color
                            backgroundColor: Colors.grey.shade900,
                            actions: const [
                              //TODO("Add Search Bar")
                            ],
                          ),
                          body: (pendingRequests.isEmpty)
                              ? Center(
                                child: TextButton.icon(
                                  onPressed: null,
                                  icon: const Icon(Icons.free_breakfast_rounded, color: Colors.brown, size: 50),
                                  label: const Text("Nothing Todo? Break Time!", style: TextStyle(color: Colors.lightGreen, fontSize: 20)),
                              ))
                              : Scrollbar(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Container(
                                          margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                                          child: DataTable(
                                            showBottomBorder: true,
                                            headingRowHeight: 50,
                                            headingTextStyle: const TextStyle(color: Colors.lightGreenAccent),
                                            headingRowColor: MaterialStateProperty.resolveWith((s) => Colors.blueGrey.shade900),
                                            columns: List<DataColumn>.generate(
                                              columns.length, (colIndex) =>
                                              DataColumn(label: Center(child: Text(columns[colIndex], textAlign: TextAlign.center,)))
                                            ),
                                            rows: List<DataRow>.generate(
                                              joinedLists.length, (index) =>
                                              DataRow(
                                                color: MaterialStateProperty.resolveWith((s) => (index%2==0) ? Colors.grey.shade200 : Colors.grey.shade400),
                                                cells: <DataCell>[
                                                  DataCell(
                                                    Center(child: Text(joinedLists[index].item3, textAlign: TextAlign.center))
                                                  ),
                                                  DataCell(
                                                      Center(child: Text(joinedLists[index].item2, textAlign: TextAlign.center,))
                                                  ),
                                                  DataCell(
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(Icons.check_circle_outline),
                                                          color: Colors.lightGreen.shade900,
                                                          onPressed: () {
                                                            AccessPermissions permission = joinedLists[index].item1;
                                                            widget._permissionsCollection.update(AccessPermissions(
                                                              uid: permission.uid,
                                                              stationId: permission.stationId,
                                                              ownerId: permission.ownerId,
                                                              userId: permission.userId,
                                                              cid: permission.cid,
                                                              permissionStatus: AccessPermissionStatus.granted
                                                            ));
                                                          },
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(Icons.cancel_outlined),
                                                          color: Colors.red,
                                                          onPressed: () {
                                                            AccessPermissions permission = joinedLists[index].item1;
                                                            widget._permissionsCollection.update(AccessPermissions(
                                                              uid: permission.uid,
                                                              stationId: permission.stationId,
                                                              ownerId: permission.ownerId,
                                                              userId: permission.userId,
                                                              cid: permission.cid,
                                                              permissionStatus: AccessPermissionStatus.denied
                                                            ));
                                                          },
                                                        )
                                                      ],
                                                    )
                                                  )
                                                ]
                                              )
                                            )
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                      );
                    }
                );
              }
          );
        }
    );
  }
}