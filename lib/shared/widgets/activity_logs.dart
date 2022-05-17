import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lab_manager/models/lab_station.dart';
import 'package:lab_manager/models/usage_history.dart';
import 'package:lab_manager/services/firestore/usage_history_db.dart';
import 'package:lab_manager/services/firestore/users_db.dart';
import 'package:tuple/tuple.dart';
import 'package:intl/intl.dart';

import '../../models/lab_user.dart';

class ActivityLogs extends StatefulWidget {
  const ActivityLogs({
    Key? key,
    required this.labUser,
    required this.title,
    required this.showMyUsagesOnly,
    this.myStations
  }) : super(key: key);

  final LabUser labUser;
  final String title;
  final bool showMyUsagesOnly;
  final List<LabStation>? myStations;
  @override
  State<ActivityLogs> createState() => _ActivityLogsState();
}

class _ActivityLogsState extends State<ActivityLogs> {
  final UsageHistoryCollection _usageHistoryCollection = UsageHistoryCollection();
  final UsersCollection _usersCollection = UsersCollection();

  bool filterEnabled = false;
  String filteredStationId = "All";
  String filteredUserId = "All";
  Timestamp? filteredStartedAt;
  Timestamp? filteredFinishedAt;

  bool loading = false;
  bool errorFound = false;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UsageHistory>>(
      stream: _usageHistoryCollection.getAllUsageHistory(),
      builder: (context, AsyncSnapshot<List<UsageHistory>> usagesSnapShot) {
        List<UsageHistory> usages = [];
        if (usagesSnapShot.hasData && usagesSnapShot.data != null) {
          usages = usagesSnapShot.data!;
        }

        // Filter my usages only if needed - else take all usages to my stations
        if (widget.showMyUsagesOnly) {
          usages = usages.where((usage) => usage.userId == widget.labUser.uid).toList();
        } else if (widget.myStations != null) {
          List<String> myStationIds = widget.myStations!.map((station) => station.uid).toSet().toList();
          usages = usages.where((usage) => myStationIds.contains(usage.stationId)).toList();
        }

        return StreamBuilder<List<LabUser>>(
          stream: _usersCollection.getAllLabUser(),
          builder: (context, AsyncSnapshot<List<LabUser>> usersSnapShot) {
            List<LabUser> users = [];
            if (usersSnapShot.hasData && usersSnapShot.data != null) {
              users = usersSnapShot.data!;
            }

            List<Tuple2<UsageHistory, LabUser>> joinedLists = usages.map((usage) => Tuple2(
                usage,
                users.firstWhere((user) => user.uid == usage.userId)
            )).toList();

            // In case the user want to filter rows
           joinedLists = _filterList(joinedLists);

            return Scaffold(
                backgroundColor: Colors.grey.shade800,
                appBar: AppBar(
                  // Title
                  title: Text(widget.title, style: const TextStyle(color: Colors.teal)),
                  centerTitle: true,
                  // Application Bar Color
                  backgroundColor: Colors.grey.shade900,
                ),
                // appBar: SearchBar(title: 'Request Permissions', defaultSearchContent: 'Enter station name...'),
                body: Scrollbar(
                  child: ListView(
                    children: [
                      // Filter Panel
                      _getFilterPanel(joinedLists, users),
                      // Table Of Usages Card
                      _getHistoryLogs(joinedLists),
                      // Error Message
                      Center(
                        child: (errorFound)
                            ? Text(errorMessage, style: const TextStyle(fontSize: 15, color: Colors.deepOrange),)
                            : const Text(""),
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

  List<Tuple2<UsageHistory, LabUser>> _filterList( List<Tuple2<UsageHistory, LabUser>> list) {
    if (filterEnabled) {
      List<Tuple2<UsageHistory, LabUser>> result = list;

      // Filter on all inputs when not null
      if (filteredStationId != "All") {
        result = result.where((tuple) => tuple.item1.stationId == filteredStationId).toList();
      }
      if (filteredUserId != "All") {
        result = result.where((tuple) => tuple.item2.username == filteredUserId).toList();
      }
      if (filteredStartedAt != null) {
        result = result.where((tuple) => tuple.item1.startedAt.seconds >= filteredStartedAt!.seconds).toList();
      }
      if (filteredFinishedAt != null) {
        result = result.where((tuple) => tuple.item1.finishedAt.seconds <= filteredFinishedAt!.seconds).toList();
      }

      return result;
    } else {
      return list;
    }
  }

  // Filter Card Panel's Methods
  Card _getFilterPanel(List<Tuple2<UsageHistory, LabUser>> joinedLists, List<LabUser> users) {
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
          initiallyExpanded: true,
          title: const Text("Filter By", style: TextStyle(color: Colors.greenAccent, fontSize: 18)),
          iconColor: Colors.lightGreenAccent,
          children: [
            Wrap(
                runSpacing: 10,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _getDropDownMenu(
                          (joinedLists.isEmpty) ? "All" : filteredStationId,
                              (newValue) {
                            setState(() {
                              filteredStationId = newValue;
                            });
                          },
                          ["All", ...joinedLists.map((tuple) => tuple.item1.stationId).toSet().toList()]
                      ),
                      _getDropDownMenu(
                          (joinedLists.isEmpty) ? "All" : filteredUserId,
                              (newValue) {
                            setState(() {
                              filteredUserId = (newValue == "All") ? newValue : users.firstWhere((user) => user.username == newValue).username;
                            });
                          },
                          ["All", ...joinedLists.map((tuple) => tuple.item2.username).toSet().toList()]
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _getDatePicker(
                          "Started At...",
                              (val) => setState(() => filteredStartedAt = Timestamp.fromMillisecondsSinceEpoch(val)),
                          filteredStartedAt
                      ),
                      const SizedBox(width: 20),
                      _getDatePicker(
                          "Finished At...",
                              (val) => setState(() => filteredFinishedAt = Timestamp.fromMillisecondsSinceEpoch(val)),
                          filteredFinishedAt
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () => setState(() => filterEnabled = true),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.lightGreen.shade700
                          ),
                          child: const Icon(Icons.filter_alt_sharp)
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                          onPressed: () => setState(() {
                            filterEnabled = false;
                            filteredStartedAt = null;
                            filteredFinishedAt = null;
                            filteredStationId = "All";
                            filteredUserId = "All";
                          }),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red
                          ),
                          child: const Icon(Icons.cancel_outlined)
                      ),
                    ],
                  ),
                ]
            )
          ]
      ),
    );
  }
  Expanded _getDropDownMenu(String value, Function onChanged, List<String> items) {
    return Expanded(
      flex: 1,
      child: Center(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(
              Icons.arrow_downward, color: Colors.lightGreenAccent),
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
  ElevatedButton _getDatePicker(String title, Function(int) onSuccess, Timestamp? time) {
    return ElevatedButton(
      child: Text((time != null) ? DateFormat('yyyy-MM-dd').format(time.toDate()).toString() : title, style: const TextStyle(color: Colors.lightGreenAccent)),
      style: ElevatedButton.styleFrom(
        primary: Colors.blueGrey
      ),
      onPressed: () async {
        setState(() => loading = true);
        DateTime currentDateTime = DateTime.now();
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: currentDateTime,
            firstDate: DateTime(currentDateTime.year - 10),
            lastDate: DateTime(currentDateTime.year + 10)
        );

        if (pickedDate != null) {
          onSuccess(pickedDate.millisecondsSinceEpoch);
          setState(() {
            errorFound = false;
            errorMessage = "";
          });
        } else {
          setState(() {
            errorFound = true;
            errorMessage = "Failed To Select Date!, Please Retry Again";
          });
        }
        setState(() => loading = false);
      },
    );
  }

  // Data Table's Methods
  Card _getHistoryLogs(List<Tuple2<UsageHistory, LabUser>> data) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      elevation: 2.0,
      shadowColor: Colors.greenAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.greenAccent),
      ),
      child: ExpansionTile(
        title: const Text("History Logs", style: TextStyle(color: Colors.greenAccent, fontSize: 18)),
        iconColor: Colors.lightGreenAccent,
        collapsedIconColor: Colors.greenAccent,
        children: [ 
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: _getTableContent(data)
          )
        ]
      ),
    );
  }

  Widget _getTableContent(List<Tuple2<UsageHistory, LabUser>> data) {
    if (data.isEmpty) {
      return Center(
          child: TextButton.icon(onPressed: null,
              icon: const Icon(Icons.free_breakfast_rounded, color: Colors.brown, size: 50),
              label: const Text("No Data, Break Time!", style: TextStyle(color: Colors.lightGreen, fontSize: 20))
          )
      );
    }

    List<String> columns = ["Station", "User", "Started At", "Finished At"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showBottomBorder: false,
        headingRowHeight: 50,
        headingTextStyle: const TextStyle(color: Colors.lightGreenAccent),
        headingRowColor: MaterialStateProperty.resolveWith((s) => Colors.blueGrey.shade900),
        columns: List<DataColumn>.generate(
          columns.length, (colIndex) =>
          DataColumn(label: Center(child: Text(columns[colIndex], textAlign: TextAlign.center,)))
        ),
        rows: List<DataRow>.generate(
          data.length, (index) =>
          DataRow(
            color: MaterialStateProperty.resolveWith((s) => (index % 2 == 0) ? Colors.grey.shade200 : Colors.grey.shade400),
            cells: <DataCell>[
              // Station
              DataCell(Center(child: Text(data[index].item1.stationId, textAlign: TextAlign.center))),
              // User
              DataCell(Center(child: Text(data[index].item2.username, textAlign: TextAlign.center))),
              // Started At
              DataCell(Center(child: Text(DateFormat('yyyy-MM-dd - kk:mm').format(data[index].item1.startedAt.toDate()), textAlign: TextAlign.center))),
              // Finished At
              DataCell(Center(child: Text(DateFormat('yyyy-MM-dd - kk:mm').format(data[index].item1.finishedAt.toDate()), textAlign: TextAlign.center))),
            ]
          )
        )
      ),
    );
  }
}
