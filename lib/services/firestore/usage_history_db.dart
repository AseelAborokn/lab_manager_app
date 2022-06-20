import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab_manager/models/lab_station.dart';
import 'package:lab_manager/models/lab_usage_history.dart';
import 'package:lab_manager/services/file_system.dart';

/// UsageHistoryCollection Service - handles all firestore API requests to UsageHistory collection.
class UsageHistoryCollection {
  /// [collectionName] - the collection name as shown at the firestore.
  static const collectionName = "UsageHistory";
  /// [_db] - private instance which is connected to the collection.
  final CollectionReference _db = FirebaseFirestore.instance.collection(collectionName);

  /// Returns [Query] as [UsageHistory] corresponding to the given [query]
  Query<UsageHistory> _withLabUserConvertor(Query query) =>
      query.withConverter<UsageHistory>(
          fromFirestore: (snapshot, _) => UsageHistory.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (UsageHistory usageHistory, _) => usageHistory.toJson()
      );

  List<String> _headers() => [
    "Document_Id", "Station_Id", "User_Id", "Start_Time", "End_Time"
  ];

  /// Returns List of [UsageHistory] of all the documents in the collection.
  Stream<List<UsageHistory>> getAllUsageHistory() =>
      _db.withConverter<UsageHistory>(
          fromFirestore: (snapshot, _) =>
              UsageHistory.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (UsageHistory usageHistory, _) => usageHistory.toJson()
      ).snapshots().map((event) => event.docs.map((e) => e.data()).toList());

  /// Deletes all the records where the station_id equals to the given [stationId].
  Future<void> deleteAllUsagesForStation(String stationId) async {
    await _withLabUserConvertor(_db.where('station_id', isEqualTo: stationId)).get().then(
            (snapshot) => snapshot.docs.forEach((doc) { doc.reference.delete(); })
    );
  }

  /// Exports all the history of usages of the station with [stationId] adn document id
  /// to a csv file with the desired [filename] which can be found at DOWNLOADS directory.
  Future<void> exportCSVFileForStationDeletionBackup(LabStation station, String filename) async {
    // Creating empty csv file.
    File csvFile = await FileSystemService.createEmptyCSVFile(filename);
    // Generating the content of the csv file.
    var content = [[
      "Station_Id",
      "Station_Name",
      "Station_Owner_Id",
      "Station_Run_Time_In_Seconds"
      "Station_Status",
      "Station_Accessibility"
    ],
    [
      station.uid,
      station.name,
      station.ownerId,
      station.runTimeInSecs.toString(),
      station.status.name,
      station.accessibility.name
    ]];
    var usageHistory = await _withLabUserConvertor(
        _db.where('station_id', isEqualTo: station.uid))
        .get().then((snapshot) => snapshot.docs);
    var data = usageHistory.map((e) => e.data().rowData());
    // Writing the data of the csv file.
    content.add(_headers());
    content.addAll(data);
    await FileSystemService.writeToCSVFile(csvFile, content);
  }
}