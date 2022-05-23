import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab_manager/models/lab_station.dart';
import 'package:lab_manager/models/lab_user.dart';

class UsageHistory {
  // Fields
  /// [uid] - DocumentId.
  String uid;
  /// [stationId] - StationId, the documentId of [LabStation] of the station.
  String stationId;
  /// [userId] - userId, the documentId of [LabUser] who used the station.
  String userId;
  /// [startedAt] - timestamp which the user started his usage.
  Timestamp startedAt;
  /// [finishedAt] - timestamp which the user finished his usage.
  Timestamp finishedAt;

  // Constructor
  UsageHistory({
    required this.uid,
    required this.stationId,
    required this.userId,
    required this.startedAt,
    required this.finishedAt,
  });

  /// Converts a JSON object to [UsageHistory] instance.
  UsageHistory.fromJson(String uid, Map<String, dynamic> fields) : this(
    uid: uid,
    stationId: fields['station_id'],
    userId: fields['user_id'],
    startedAt: fields['started_at'] as Timestamp,
    finishedAt: fields['finished_at'] as Timestamp,
  );

  /// Converts [UsageHistory] instance to JSON object.
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "station_id": stationId,
      "user_id": userId,
      "started_at": startedAt,
      "finished_at": finishedAt,
    });
  }
}