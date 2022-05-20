import 'package:flutter/material.dart';
import 'package:lab_manager/models/lab_permissions.dart';
import 'package:lab_manager/models/lab_station.dart';
import 'package:lab_manager/services/firestore/permissions_db.dart';
import 'package:lab_manager/services/firestore/stations_db.dart';
import 'package:tuple/tuple.dart';

import '../../models/lab_user.dart';

List<Tuple2<LabStation, AccessPermissions?>> _joinLists(
    List<LabStation> stations,
    List<AccessPermissions> permissions,
    String userId
    ) {
  List<Tuple2<LabStation, AccessPermissions?>> permutationStations = [];
  for (var station in stations) {
    bool found = false;
    for (var permission in permissions) {
      if (station.uid == permission.stationId &&
          station.ownerId == permission.ownerId &&
          userId == permission.userId) {
        permutationStations.add(Tuple2(station, permission));
        found = true;
        break;
      }
    }

    if (!found) {
      permutationStations.add(Tuple2(station, null));
    }
  }
  return permutationStations;
}

AccessPermissionStatus _getAccessPermissionStatus(
    LabStation labStation,
    AccessPermissions? accessPermissions,
    LabUser user
    ) {
  if (labStation.accessibility == LabStationAccessibility.public ||
      labStation.ownerId == user.uid) {
    return AccessPermissionStatus.granted;
  }

  if (accessPermissions == null) {
    return AccessPermissionStatus.unrequested;
  }

  return accessPermissions.permissionStatus;
}

class Permissions extends StatefulWidget {
  Permissions({Key? key, required this.labUser}) : super(key: key);

  final LabUser labUser;
  final StationsCollection _stationsCollection = StationsCollection();
  final PermissionsCollection _permissionsCollection = PermissionsCollection();

  @override
  State<Permissions> createState() => _PermissionsState();
}

class _PermissionsState extends State<Permissions> {

  @override
  Widget build(BuildContext context) {
    final String userId = widget.labUser.uid;

    return StreamBuilder<List<LabStation>>(
        stream: widget._stationsCollection.getAllStations(),
        builder: (context, AsyncSnapshot<List<LabStation>> stationsSnapshot) {
          List<LabStation> stations = <LabStation>[];
          if (stationsSnapshot.hasData && stationsSnapshot.data != null) {
            stations = stationsSnapshot.data!;
          }

          return StreamBuilder<List<AccessPermissions>>(
            stream: widget._permissionsCollection.getAccessPermissionsByRequesterId(userId),
            builder: (context, AsyncSnapshot<List<AccessPermissions>> permissionsSnapshot) {
              List<AccessPermissions> permissions = <AccessPermissions>[];
              if (permissionsSnapshot.hasData &&
                  permissionsSnapshot.data != null) {
                permissions = permissionsSnapshot.data!;
              }

              return Scaffold(
                  backgroundColor: Colors.grey.shade800,
                  appBar: AppBar(
                    // Title
                    title: const Text('Request Permissions', style: TextStyle(color: Colors.teal)),
                    centerTitle: true,
                    // Application Bar Color
                    backgroundColor: Colors.grey.shade900,
                    actions: const [
                      //TODO("Add Search Bar")
                    ],
                  ),
                  // appBar: SearchBar(title: 'Request Permissions', defaultSearchContent: 'Enter station name...'),
                  body: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("lib/shared/assets/images/lab2.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Scrollbar(
                      child: ListView(
                        children: _accessPermissionCardsFrom(_joinLists(stations, permissions, userId), widget.labUser),
                      ),
                    ),
                  )
              );
            }
          );
        }
    );
  }
  List<Card> _accessPermissionCardsFrom(List<Tuple2<LabStation, AccessPermissions?>> stations, LabUser user) {
    List<Card> result = [];
    for (var station in stations) {
      result.add(_accessPermissionCardFrom(station, user));
    }
    return result;
  }

  Card _accessPermissionCardFrom(Tuple2<LabStation, AccessPermissions?> tuple2, LabUser labUser) {
    LabStation station = tuple2.item1;
    AccessPermissions? permission = tuple2.item2;
    AccessPermissionStatus status = _getAccessPermissionStatus(station, permission, labUser);
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      elevation: 2.0,
      shadowColor: Colors.greenAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.greenAccent),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              ExpansionTile(
                title: Text(station.name, style: const TextStyle(
                    color: Colors.greenAccent, fontSize: 18)),
                subtitle: Text(status.name, style: const TextStyle(
                    color: Colors.lightGreenAccent, fontSize: 15)),
                iconColor: Colors.lightGreenAccent,
                collapsedIconColor: Colors.greenAccent,
                children: [
                  RequestButtonTile(labUser: labUser, labStation: station)
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class RequestButtonTile extends StatefulWidget {
  RequestButtonTile({
    Key? key,
    required this.labUser,
    required this.labStation,
  }) : super(key: key);

  final PermissionsCollection _permissionsCollection = PermissionsCollection();
  final LabUser labUser;
  final LabStation labStation;

  @override
  State<RequestButtonTile> createState() => _RequestButtonTileState();
}

class _RequestButtonTileState extends State<RequestButtonTile> {
  @override
  Widget build(BuildContext context) {
    String stationId = widget.labStation.uid;
    String ownerId = widget.labStation.ownerId;
    String userId = widget.labUser.uid;
    String? cid = widget.labUser.cid;
    LabStationAccessibility accessibility = widget.labStation.accessibility;

    if (accessibility == LabStationAccessibility.public || userId == ownerId) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
              onSurface: Colors.greenAccent.shade700
          ),
          onPressed: null,
          onLongPress: null,
          child: const Text("Access Granted")
      );
    }
    else if (cid == null || cid == "") {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
              onSurface: Colors.red.shade700
          ),
          onPressed: null,
          onLongPress: null,
          child: const Text("Cannot Request Access! Please Update Your Card Id")
      );
    }
    else {
      return FutureBuilder(
        future: widget._permissionsCollection.getSpecificAccessPermissions(
            userId,
            ownerId,
            stationId
        ),
        builder: (BuildContext context, AsyncSnapshot<AccessPermissions?> permissionsSnapshot) {
          if (!permissionsSnapshot.hasData || permissionsSnapshot.data == null) {
            // The user never requested the data -> create a request
            return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.green.shade900
                ),
                onPressed: () {
                  widget._permissionsCollection.create(stationId, ownerId, userId, cid, AccessPermissionStatus.requested);
                },
                onLongPress: null,
                child: const Text("Request Access")
            );
          }

          AccessPermissions request = permissionsSnapshot.data!;
          // The request has been denied -> update the request.
          if (request.permissionStatus == AccessPermissionStatus.denied) {
            return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.greenAccent.shade700
                ),
                onPressed:() {
                  widget._permissionsCollection.update(AccessPermissions(
                      uid: request.uid,
                      stationId: stationId,
                      ownerId: ownerId,
                      userId: userId,
                      cid: cid,
                      permissionStatus: AccessPermissionStatus.requested
                  ));
                },
                child: const Text("Request Access")
            );
          }

          // The user hase already requested access, but where are waiting
          // for the owner response
          if (request.permissionStatus == AccessPermissionStatus.requested) {
            return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    onSurface: Colors.greenAccent.shade700
                ),
                onPressed: null,
                onLongPress: null,
                child: const Text("Waiting For Response")
            );
          }

          if (request.permissionStatus == AccessPermissionStatus.granted) {
            return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    onSurface: Colors.greenAccent.shade700
                ),
                onPressed: null,
                onLongPress: null,
                child: const Text("Access Granted")
            );
          }

          return const Text("Fetching Data!");
        },
      );
    }

  }
}

