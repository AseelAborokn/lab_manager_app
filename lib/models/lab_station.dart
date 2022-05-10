enum LabStationStatus {
  available,
  busy,
  unavailable
}

enum LabStationAccessibility {
  public,
  restricted
}

class LabStation {
  // Document Id
  String uid;

  // Fields
  String name;
  String ownerId;
  int runTimeInSecs;
  LabStationStatus status;
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

  // Create a LabStation object from JSON object.
  LabStation.fromJson(String uid, Map<String, dynamic> fields) : this(
      uid: uid,
      name: fields['name'],
      ownerId: fields['owner_id'],
      runTimeInSecs: (fields['run_time_in_secs'] ?? 0) as int,
      status: LabStationStatus.values.firstWhere((element) => element.toString() == 'LabStationStatus.' + fields['status'].toString()),
      accessibility: LabStationAccessibility.values.firstWhere((element) => element.toString() == 'LabStationAccessibility.' + fields['accessibility'].toString()),
  );

  // Create JSON object from LabStation object.
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "uid": uid,
      "name": name,
      "owner_id": ownerId,
      "run_time_in_secs": runTimeInSecs,
      "status": status.name,
      "accessibility": accessibility.name,
    });
  }
}