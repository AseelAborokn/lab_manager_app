import 'package:cloud_firestore/cloud_firestore.dart';

class UsageHistory {
  // Fields
  String uid;
  int stationId;
  String managerId;
  String userId;
  Timestamp? startedAt;
  Timestamp? finishedAt;

  // Constructor
  UsageHistory({
    required this.uid,
    required this.stationId,
    required this.managerId,
    required this.userId,
    this.startedAt,
    this.finishedAt,
  });

  // Create a UsageHistory object from JSON object.
  UsageHistory.fromJson(Map<String, dynamic> fields) : this(
    uid: fields['uid'],
    stationId: fields['station_id'],
    managerId: fields['manager_id'],
    userId: fields['user_id'],
    startedAt: fields['started_at'] as Timestamp,
    finishedAt: fields['finished_at'] as Timestamp,
  );

  // Create JSON object from UsageHistory object.
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "uid": uid,
      "station_id": stationId,
      "manager_id": managerId,
      "user_id": userId,
      "started_at": startedAt,
      "finished_at": finishedAt,
    });
  }
}