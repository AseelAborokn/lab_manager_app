/// LabStation Status
///
/// - [available] : In case the station is available for usage.
/// - [unavailable] : In case the station is unavailable for usage.
enum LabStationStatus {
  available,
  unavailable
}

/// LabStation Accessibility
///
/// - [public] : In case the station can be accessed by anyone.
/// - [restricted] : In case authorization is needed to access the station.
enum LabStationAccessibility {
  public,
  restricted
}

/// Model which represents document in LabStations collection.
class LabStation {
  // Fields
  /// [uid] - DocumentId.
  String uid;
  /// [name] - The name of the station.
  String name;
  /// [ownerId] - OwnerId, the documentId of [LabUser] who own the station.
  String ownerId;
  /// [runTimeInSecs] - Time period which the station runs from activation (in Seconds).
  int runTimeInSecs;
  /// [status] - status of the station.
  LabStationStatus status;
  /// [accessibility] - is the station public/restricted.
  LabStationAccessibility accessibility;

  // Constructor
  LabStation({
    required this.uid,
    required this.name,
    required this.ownerId,
    this.runTimeInSecs = 600,
    this.status = LabStationStatus.unavailable,
    this.accessibility = LabStationAccessibility.public
  });

  /// Converts a JSON object to [LabStation] instance.
  LabStation.fromJson(String uid, Map<String, dynamic> fields) : this(
      uid: uid,
      name: fields['name'],
      ownerId: fields['owner_id'],
      runTimeInSecs: (fields['run_time_in_secs'] ?? 0) as int,
      status: LabStationStatus.values.firstWhere((element) => element.toString() == 'LabStationStatus.' + fields['status'].toString()),
      accessibility: LabStationAccessibility.values.firstWhere((element) => element.toString() == 'LabStationAccessibility.' + fields['accessibility'].toString()),
  );

  /// Converts [LabStation] instance to JSON object.
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "name": name,
      "owner_id": ownerId,
      "run_time_in_secs": runTimeInSecs,
      "status": status.name,
      "accessibility": accessibility.name,
    });
  }
}