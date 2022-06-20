///@nodoc
import 'package:flutter/material.dart';
import 'package:lab_manager/models/lab_station.dart';
import 'package:lab_manager/services/firestore/stations_db.dart';
import 'package:lab_manager/services/firestore/usage_history_db.dart';
import 'package:lab_manager/shared/widgets/read_only_register_text_form_field.dart';
import 'package:lab_manager/shared/widgets/register_text_form_field.dart';
import 'package:lab_manager/shared/widgets/submit_form_buttons.dart';

import '../../models/lab_user.dart';
import '../../shared/loading_spinner.dart';
import '../../shared/widgets/background_image.dart';

class MyStations extends StatefulWidget {
  MyStations({Key? key, required this.labUser}) : super(key: key);

  final LabUser labUser;
  final StationsCollection _stationsCollection = StationsCollection();
  final UsageHistoryCollection _usageHistoryCollection = UsageHistoryCollection();

  @override
  State<MyStations> createState() => _MyStationsState();
}

class _MyStationsState extends State<MyStations> {

  @override
  Widget build(BuildContext context) {
    final String ownerUid = widget.labUser.uid;

    return StreamBuilder<List<LabStation>>(
        stream: widget._stationsCollection.getStationsByOwnerId(ownerUid),
        builder: (context, AsyncSnapshot<List<LabStation>> snapshot) {
          List<LabStation> myStations = <LabStation>[];
          if (snapshot.hasData && snapshot.data != null) {
            myStations = snapshot.data!;
          }

          return Scaffold(
              backgroundColor: Colors.grey.shade800,
              appBar: AppBar(
                // Title
                title: const Text(
                    'My Stations', style: TextStyle(color: Colors.teal)),
                centerTitle: true,
                // Application Bar Color
                backgroundColor: Colors.grey.shade900,
                actions: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => StationUpsertPage(title: "Create New Station",create: true,ownerId: ownerUid)));
                    },
                    icon: const Icon(Icons.add, color: Colors.tealAccent, size: 30),
                    label: const Text(""),
                  )
                ],
              ),
              body: Container(
                decoration: backGroundImage(),
                child: Scrollbar(
                  child: ListView(
                    children: _stationsLabCardsFrom(myStations, ownerUid),
                  ),
                ),
              )
          );
        }
    );
  }

  List<Card> _stationsLabCardsFrom(List<LabStation> stations, String ownerId) {
    List<Card> result = [];
    for (var station in stations) {
      result.add(_stationCardFrom(station, ownerId));
    }
    return result;
  }

  Card _stationCardFrom(LabStation station, String ownerId) {
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
                subtitle: Text(station.status.name, style: const TextStyle(
                    color: Colors.lightGreenAccent, fontSize: 15)),
                iconColor: Colors.lightGreenAccent,
                collapsedIconColor: Colors.greenAccent,
                children: [
                  Column(
                    children: [
                      _createInfoLine("Id :", station.uid),
                      _createInfoLine("Owner Id :", station.ownerId),
                      _createInfoLine("Accessibility :", station.accessibility.name),
                      _createInfoLine("Run Time Duration In Secs:", station.runTimeInSecs.toString()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red.shade900
                            ),
                            onPressed: () async {
                              String filename = '${station.uid}-DeletionBackUp-Date';
                              await widget._usageHistoryCollection.exportCSVFileForStationDeletionBackup(station.uid, filename);
                              await widget._usageHistoryCollection.deleteAllUsagesForStation(station.uid);
                              await widget._stationsCollection.delete(station.uid);
                            },
                            child: const Text("Backup Usage History & Delete Station")
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green.shade600
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => StationUpsertPage(title: "Update ${station.name}", ownerId: ownerId, create: false,station: station)));
                              },
                              child: const Text("Update")
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _createInfoLine(String key, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Expanded(
        flex: 2,
        child: Text(key,   style: const TextStyle(color: Colors.white, fontSize: 12))),
      Expanded(
        flex: 3,
        child: Center(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 12))),
      ),
    ],
  );
}

class StationUpsertPage extends StatefulWidget {
  const StationUpsertPage({
    Key? key,
    required this.ownerId,
    required this.title,
    required this.create,
    this.station
  }) : super(key: key);

  final String ownerId;
  final String title;
  final LabStation? station;
  final bool create;
  @override
  State<StationUpsertPage> createState() => _StationUpsertPageState();
}

class _StationUpsertPageState extends State<StationUpsertPage> {
  final _formKey = GlobalKey<FormState>();
  final StationsCollection _stationsCollection = StationsCollection();

  // Text field states
  String? stationName;
  String? stationId;
  LabStationStatus status = LabStationStatus.unavailable;
  LabStationAccessibility accessibility = LabStationAccessibility.public;
  bool statusUpdated = false;
  bool accessibilityUpdated = false;
  int runTimeInSecs = 600;
  bool shouldUseDefaultValues = true;
  String errorMessage = "";
  bool errorFound = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    if (widget.station != null && shouldUseDefaultValues) {
      stationName = widget.station!.name;
      stationId = widget.station!.uid;
      status = widget.station!.status;
      accessibility = widget.station!.accessibility;
      runTimeInSecs = widget.station!.runTimeInSecs;
      shouldUseDefaultValues = false;
    }

    return (loading) ? const LoadingSpinner() : Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        // Title
        title: Text(widget.title, style: const TextStyle(color: Colors.teal)),
        centerTitle: true,
        // Application Bar Color
        backgroundColor: Colors.grey.shade900,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: backGroundImage(),
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
        child: Form(
          key: _formKey,
          child: Card(
            color: Colors.black12,
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 1.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Wrap(
                  runSpacing: 10,
                  children: <Widget>[
                    // Station Id
                    (widget.create) ?
                    (RegisterTextFromField(
                        initValue: widget.station?.uid,
                        labelText: "Station Id",
                        hintText: widget.station?.uid ?? "station id",
                        iconData: null,
                        onChanged: (val) => setState(() => stationId = val),
                        onValidation: (val) =>
                        (val == null || val.isEmpty)
                            ? "Invalid Station Id"
                            : null
                    )) : (ReadOnlyRegisterTextFromField(
                        initValue: widget.station?.uid,
                        labelText: "Station Id",
                        hintText: widget.station?.uid ?? "station id",
                        iconData: null,
                    )),
                    // Station Name
                    RegisterTextFromField(
                        initValue: widget.station?.name,
                        labelText: "Station Name",
                        hintText: widget.station?.name ?? "station name",
                        iconData: null,
                        onChanged: (val) => setState(() => stationName = val),
                        onValidation: (val) =>
                        (val == null || val.isEmpty)
                            ? "Invalid Station Name"
                            : null
                    ),
                    // Run Time In Secs
                    RegisterTextFromField(
                      initValue: widget.station?.runTimeInSecs.toString() ?? runTimeInSecs.toString(),
                      labelText: "Station Run Time Duration",
                      hintText: widget.station?.runTimeInSecs.toString() ?? "in secs",
                      iconData: null,
                      onChanged: (val) => setState(() => runTimeInSecs = (val != null && int.tryParse(val) != null) ? int.tryParse(val)! : 600),
                      onValidation: (val) => (val == null || int.tryParse(val) == null || int.tryParse(val)! <= 0) ? "Invalid Duration Time" : null
                    ),
                    // Station status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // LabStationStatus
                        _getDropDownMenu(
                            (!statusUpdated) ? widget.station?.status.name ?? status.name : status.name,
                          (newValue) {
                            setState(() => status = LabStationStatus.values.firstWhere((element) => element.toString() == 'LabStationStatus.' + (newValue ?? LabStationStatus.unavailable.name)));
                            setState(() => statusUpdated = true);
                          },
                          LabStationStatus.values.map((e) => e.name).toList()
                        ),
                        // LabStationAccessibility
                        _getDropDownMenu(
                            (!accessibilityUpdated) ? widget.station?.accessibility.name ?? accessibility.name : accessibility.name,
                          (newValue) {
                            setState(() => accessibility = LabStationAccessibility.values.firstWhere((element) => element.toString() == 'LabStationAccessibility.' + (newValue ?? LabStationAccessibility.public.name)));
                            setState(() => accessibilityUpdated = true);
                          },
                          LabStationAccessibility.values.map((e) => e.name).toList()
                        ),
                      ],
                    ),
                  ],
                ),
                // Buttons
                SubmitFormButtons(
                    formKey: _formKey,
                    submit: () async {
                      try {
                        setState(() => loading = true);
                        // Checking if the user is updating a station id
                        Future<void> deleting = Future<void>.value();
                        if (stationId != null && widget.station != null && stationId != widget.station!.uid) {
                          deleting = _stationsCollection.delete( widget.station!.uid);
                        }
                        else if (stationId != null && widget.station == null) {
                          bool found = await _stationsCollection.getLabStationById(stationId!).then((value) => value != null);
                          // Check if StationId is unique
                          if (found) throw "Station Id Is Already In Use!";
                        }

                        // Add the LabStation to the LabStations collection and retrieve the model
                        Future<void> creating = deleting.then((value) => _stationsCollection.upsert(
                          LabStation(
                            uid: stationId ?? widget.station!.uid,
                            name: stationName ?? widget.station!.name,
                            ownerId: widget.ownerId,
                            runTimeInSecs: runTimeInSecs,
                            status: status,
                            accessibility: accessibility
                          )
                        ));

                        final LabStation? labStation = await creating.then((value) =>
                          _stationsCollection.getLabStationById(stationId ?? widget.station!.uid)
                        );

                        if (labStation != null) {
                          if (!mounted) return;
                          Navigator.of(context).pop();
                        }
                        else {
                          throw "Failed To Create A LabStation";
                        }
                      } catch (e) {
                        setState(() {
                          errorFound = true;
                          errorMessage = e.toString();
                          loading = false;
                        });
                      }
                      setState(() => loading = false);
                    }
                ),
                // Error Message
                Center(
                  child: (errorFound)
                      ? Text(errorMessage,
                    style: const TextStyle(fontSize: 15, color: Colors
                        .deepOrange),)
                      : const Text(""),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Expanded _getDropDownMenu(String? value, Function onChanged, List<String> items) {
    return Expanded(
      flex: 1,
      child: Center(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.arrow_downward, color: Colors.greenAccent),
          elevation: 0,
          style: const TextStyle(color: Colors.white),
          dropdownColor: Colors.grey.shade800,
          underline: Container(
            height: 2,
            color: Colors.greenAccent,
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
}

