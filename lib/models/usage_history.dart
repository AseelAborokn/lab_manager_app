import 'package:cloud_firestore/cloud_firestore.dart';

class UsageHistory {
  // Fields
  String uid;
  String stationId;
  String userId;
  Timestamp startedAt;
  Timestamp finishedAt;

  // Constructor
  UsageHistory({
    required this.uid,
    required this.stationId,
    required this.userId,
    required this.startedAt,
    required this.finishedAt,
  });

  // Create a UsageHistory object from JSON object.
  UsageHistory.fromJson(String uid, Map<String, dynamic> fields) : this(
    uid: uid,
    stationId: fields['station_id'],
    userId: fields['user_id'],
    startedAt: fields['started_at'] as Timestamp,
    finishedAt: fields['finished_at'] as Timestamp,
  );

  // Create JSON object from UsageHistory object.
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "station_id": stationId,
      "user_id": userId,
      "started_at": startedAt,
      "finished_at": finishedAt,
    });
  }
}