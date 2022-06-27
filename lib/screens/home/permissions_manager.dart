///@nodoc
import 'package:flutter/material.dart';
import 'package:lab_manager/models/lab_permissions.dart';
import 'package:lab_manager/models/lab_station.dart';
import 'package:lab_manager/services/firestore/permissions_db.dart';
import 'package:lab_manager/services/firestore/stations_db.dart';
import 'package:lab_manager/services/firestore/users_db.dart';
import 'package:lab_manager/shared/loading_spinner.dart';
import 'package:tuple/tuple.dart';

import '../../models/lab_user.dart';
import '../../shared/widgets/background_image.dart';

class PermissionsManager extends StatefulWidget {
  PermissionsManager({Key? key, required this.labUser}) : super(key: key);

  final LabUser labUser;
  final StationsCollection _stationsCollection = StationsCollection();
  final PermissionsCollection _permissionsCollection = PermissionsCollection();
  final UsersCollection _usersCollection = UsersCollection();

  @override
  State<PermissionsManager> createState() => _PermissionsManagerState();
}

class _PermissionsManagerState extends State<PermissionsManager> {
  List<LabUser> users = [];
  List<LabStation> stations = [];
  List<AccessPermissions> permissions = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<LabStation>>(
        stream: widget._stationsCollection.getStationsByOwnerId(widget.labUser.uid),
        builder: (context, AsyncSnapshot<List<LabStation>> ownedStationsSnapshot) {
          if (ownedStationsSnapshot.hasData && ownedStationsSnapshot.data != null) {
            stations = ownedStationsSnapshot.data!;
          }

          return StreamBuilder<List<LabUser>>(
              stream: widget._usersCollection.getAllLabUser(),
              builder: (context, AsyncSnapshot<List<LabUser>> usersSnapshot) {
                if (usersSnapshot.hasData && usersSnapshot.data != null) {
                  users = usersSnapshot.data!;
                }

                return StreamBuilder<List<AccessPermissions>>(
                    stream: widget._permissionsCollection.getAccessPermissionsByOwnerId(widget.labUser.uid),
                    builder: (context, AsyncSnapshot<List<AccessPermissions>> permissionsSnapshot) {
                      if (permissionsSnapshot.hasData && permissionsSnapshot.data != null) {
                        permissions = permissionsSnapshot.data!;
                      }

                      List<Tuple3<AccessPermissions, String, String>> authorizedUsers =
                      _filterByPermissionStatus(AccessPermissionStatus.granted);

                      List<Tuple3<AccessPermissions, String, String>> deniedUsers =
                      _filterByPermissionStatus(AccessPermissionStatus.denied);

                      return Scaffold(
                        backgroundColor: Colors.grey.shade800,
                        appBar: AppBar(
                          title: const Text('Manage You Station Permissions', style: TextStyle(color: Colors.teal)),
                          centerTitle: true,
                          backgroundColor: Colors.grey.shade900,
                        ),
                          body: Container(
                          decoration: backGroundImage(),
                          child: (stations.isEmpty)
                            ? Center(
                              child: TextButton.icon(
                                onPressed: null,
                                icon: const Icon(Icons.free_breakfast_rounded, color: Colors.brown, size: 50),
                                label: const Text("No Stations To Be Managed, Add Stations First", style: TextStyle(color: Colors.lightGreen, fontSize: 20)),
                              )
                            )
                            : Scrollbar (
                              child: ListView(
                                children: [
                                  Row (
                                    children: [
                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Container(
                                            margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                                            child: Column(
                                              children: <Widget>[
                                                // ManagerPanel
                                                PanelCard(
                                                  labUser: widget.labUser,
                                                  users: users,
                                                  stations: stations,
                                                ),
                                                // Blocked Users
                                                TableCard(title: 'Authorized Users',
                                                    isAuthorizedUsersTable: true,
                                                    data: authorizedUsers),
                                                // Authorized Users
                                                TableCard(title: 'Unauthorized Users',
                                                    isAuthorizedUsersTable: false,
                                                    data: deniedUsers),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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

  List<Tuple3<AccessPermissions, String, String>> _filterByPermissionStatus(AccessPermissionStatus status) {
    if (permissions.isEmpty || users.isEmpty || stations.isEmpty) {
      return [];
    }
    return permissions
        .where((permission) => permission.permissionStatus == status)
        .map((permission) => Tuple3(
        permission,
        users.firstWhere((user) => user.uid == permission.userId).username,
        stations.firstWhere((station) => station.uid == permission.stationId).name
    )).toList();
  }
}

class PanelCard extends StatefulWidget {
  const PanelCard({
    Key? key,
    required this.labUser,
    required this.users,
    required this.stations,
  }) : super(key: key);

  final LabUser labUser;
  final List<LabUser> users;
  final List<LabStation> stations;

  @override
  State<PanelCard> createState() => _PanelCardState();
}

class _PanelCardState extends State<PanelCard> {
  final _formKey = GlobalKey<FormState>();
  final PermissionsCollection _permissionsCollection = PermissionsCollection();

  bool isUserSelected = false;
  bool isStationSelected = false;
  LabUser? selectedUser;
  LabStation? selectedStation;

  String errorMessage = "";
  bool errorFound = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    List<LabStation> stations = widget.stations;
    List<LabUser> possibleUsers = widget.users
        .where((user) => (user.uid != widget.labUser.uid && user.cid != null && user.cid!.isNotEmpty)).toList();

    return (loading) ? const LoadingSpinner() : Form(
      key: _formKey,
      child: Card(
        color: Colors.grey.shade900,
        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        elevation: 2.0,
        shadowColor: Colors.greenAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.greenAccent),
        ),
        child: ExpansionTile(
            initiallyExpanded: true,
            title: const Text("Control Panel", style: TextStyle(color: Colors.greenAccent, fontSize: 18)),
            iconColor: Colors.lightGreenAccent,
            children: (stations.isEmpty || possibleUsers.isEmpty) ? [] : [
              Wrap(
                  runSpacing: 10,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _getDropDownMenu(
                            selectedStation?.name ?? stations.first.name,
                                (newValue) {
                              setState(() {
                                selectedStation = stations.firstWhere((station) => station.name == newValue);
                                isStationSelected = true;
                              });
                            },
                            stations.map((e) => e.name).toList()
                        ),
                        _getDropDownMenu(
                          selectedUser?.username ?? possibleUsers.first.username,
                          (newValue) {
                            setState(() {
                              selectedUser = possibleUsers.firstWhere((user) => user.username == newValue);
                              isUserSelected = true;
                            });
                          },
                          possibleUsers.map((user) => user.username).toList()
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _getIconButton(Icons.approval, Colors.lightGreen.shade900, "Grand Access", () {
                          setState(() => loading = true);
                          try {
                            _updateAccessPermission(selectedUser, selectedStation, AccessPermissionStatus.granted);
                          } catch(e) {
                            setState(() {
                              errorFound = true;
                              errorMessage = e.toString();
                            });
                          }
                          setState(() => loading = false);
                        }),
                        const SizedBox(width: 10),
                        _getIconButton(Icons.block, Colors.red, "Deny Access", () {
                          setState(() => loading = true);
                          try {
                            _updateAccessPermission(selectedUser, selectedStation, AccessPermissionStatus.denied);
                          } catch(e) {
                            setState(() {
                              errorFound = true;
                              errorMessage = e.toString();
                            });
                          }
                          setState(() => loading = false);
                        })
                      ],
                    ),
                    Center(
                      child: (errorFound)
                          ? Text(errorMessage, style: const TextStyle(fontSize: 15, color: Colors.deepOrange),)
                          : const Text(""),
                    ),
                  ]
              )
            ]
        ),
      ),
    );
  }

  Expanded _getDropDownMenu(String value, Function onChanged, List<String> items) {
    return Expanded(
      flex: 1,
      child: Center(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.arrow_downward, color: Colors.lightGreenAccent),
          elevation: 0,
          style: const TextStyle(color: Colors.white),
          dropdownColor: Colors.grey.shade800,
          underline: Container(
            height: 2,
            color: Colors.lightGreenAccent,
          ),
          onChanged: (String? newValue) => onChanged(newValue),
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _updateAccessPermission(LabUser? selectedUser, LabStation? selectedStation, AccessPermissionStatus status) async {
      if (selectedUser == null || selectedStation == null) {
        setState(() {
          errorFound = true;
          errorMessage = "Invalid Input (Null Exception) Please Try Again!";
        });
        return;
      }

      if (selectedUser.cid == null) {
        setState(() {
          errorFound = true;
          errorMessage = "Missing Card Id For The User!";
        });
        return;
      }

      // Search if there is already a permission for this user
      AccessPermissions? permission = await _permissionsCollection.getSpecificAccessPermissions(selectedUser.uid, selectedStation.ownerId, selectedStation.uid);

      if (permission != null) {
        // there is a doc -> update
        await _permissionsCollection.update(AccessPermissions(
          uid: permission.uid,
          stationId: permission.stationId,
          ownerId: permission.ownerId,
          userId: permission.userId,
          cid: permission.cid,
          permissionStatus: status
        ));
      } else {
        // there is not a doc -> create
        await _permissionsCollection.create(
          selectedStation.uid,
          selectedStation.ownerId,
          selectedUser.uid,
          selectedUser.cid!,
          status
        );
      }
  }

  ElevatedButton _getIconButton(
      IconData iconData,
      Color iconColor,
      String label,
      Function onPress
      ) {
    return ElevatedButton(
        style: TextButton.styleFrom(
          primary: Colors.lightGreenAccent,
          backgroundColor: Colors.blueGrey.shade200,
          elevation: 10.0
        ),
        onPressed: () => onPress(),
      child: Icon(iconData, color: iconColor, semanticLabel: label),
    );
  }
}

class TableCard extends StatefulWidget {
  const TableCard({
    Key? key,
    required this.title,
    required this.isAuthorizedUsersTable,
    required this.data
  }) : super(key: key);

  final String title;
  final bool isAuthorizedUsersTable;
  final List<Tuple3<AccessPermissions, String, String>> data;

  @override
  State<TableCard> createState() => _TableCardState();
}

class _TableCardState extends State<TableCard> {
  final PermissionsCollection _permissionsCollection = PermissionsCollection();

  bool loading = false;
  bool errorFound = false;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    String buttonTitle = (widget.isAuthorizedUsersTable)
        ? "Deny Access"
        : "Provide Access";
    final List<String> columns = ['Station', 'User', buttonTitle];

    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      elevation: 2.0,
      shadowColor: Colors.greenAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.greenAccent),
      ),
      child: ExpansionTile(
          title: Text(widget.title,
              style: const TextStyle(color: Colors.greenAccent, fontSize: 18)),
          iconColor: Colors.lightGreenAccent,
          collapsedIconColor: Colors.greenAccent,
          children: [
            (widget.data.isEmpty)
                ? Center(child: TextButton.icon(onPressed: null,
                  icon: const Icon(
                      Icons.free_breakfast_rounded, color: Colors.brown,
                      size: 50),
                  label: const Text("No Data, Break Time!", style: TextStyle(
                      color: Colors.lightGreen, fontSize: 20)),
                ))
                : Container(
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),

                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                    showBottomBorder: true,
                    headingRowHeight: 50,
                    headingTextStyle: const TextStyle(color: Colors.lightGreenAccent),
                    headingRowColor: MaterialStateProperty.resolveWith((s) => Colors.blueGrey.shade900),
                    columns: List<DataColumn>.generate(
                        columns.length, (colIndex) =>
                        DataColumn(label: Center(child: Text(
                          columns[colIndex], textAlign: TextAlign.center,)))
                    ),
                    rows: List<DataRow>.generate(
                        widget.data.length, (index) =>
                        DataRow(
                          color: MaterialStateProperty.resolveWith((s) =>
                          (index % 2 == 0)
                              ? Colors.grey.shade200
                              : Colors.grey.shade400),
                          cells: <DataCell>[
                            DataCell(
                                Center(child: Text(widget.data[index].item3,
                                    textAlign: TextAlign.center))
                            ),
                            DataCell(
                                Center(child: Text(widget.data[index].item2,
                                  textAlign: TextAlign.center,))
                            ),
                            DataCell(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    _getButton(index)
                                  ],
                                )
                            )
                          ]
                        )
                      )
                    ),
                  ),
                ),
            Center(
              child: (errorFound)
                  ? Text(errorMessage, style: const TextStyle(fontSize: 15, color: Colors.deepOrange),)
                  : const Text(""),
            )
          ]
      ),
    );
  }



  IconButton _getButton(int index) {
    AccessPermissionStatus status;
    Color color;
    IconData iconData;
    if (widget.isAuthorizedUsersTable) {
      status = AccessPermissionStatus.denied;
      color = Colors.red;
      iconData = Icons.block;
    } else {
      status = AccessPermissionStatus.granted;
      color = Colors.lightGreen.shade900;
      iconData = Icons.approval;
    }

    return IconButton(
      icon: Icon(iconData),
      color: color,
      onPressed: () async {
        setState(() => loading = true);
        AccessPermissions permission = widget.data[index].item1;
        try {
          await _permissionsCollection.update(AccessPermissions(
              uid: permission.uid,
              stationId: permission.stationId,
              ownerId: permission.ownerId,
              userId: permission.userId,
              cid: permission.cid,
              permissionStatus: status
          ));
        } catch (e) {
          setState(() {
            errorMessage = e.toString();
            errorFound = true;
          });
        }
        setState(() => loading = false);
      },
    );
  }
}
