enum LabStationStatus {
  available,
  busy,
  unavailable
}

enum LabStationVisibility {
  public,
  private
}

class LabStation {
  // Document Id
  String uid;

  // Fields
  String name;
  String ownerId;
  int runTimeInSecs;
  LabStationStatus status;
  LabStationVisibility visibility;

  // Constructor
  LabStation({
    required this.uid,
    required this.name,
    required this.ownerId,
    this.runTimeInSecs = 600,
    this.status = LabStationStatus.unavailable,
    this.visibility = LabStationVisibility.public
  });

  // Create a LabStation object from JSON object.
  LabStation.fromJson(String uid, Map<String, dynamic> fields) : this(
      uid: uid,
      name: fields['name'],
      ownerId: fields['owner_id'],
      runTimeInSecs: (fields['run_time_in_secs'] ?? 0) as int,
      status: LabStationStatus.values.firstWhere((element) => element.toString() == 'LabStationStatus.' + fields['status'].toString()),
      visibility: LabStationVisibility.values.firstWhere((element) => element.toString() == 'LabStationVisibility.' + fields['visibility'].toString()),
  );

  // Create JSON object from LabStation object.
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "uid": uid,
      "name": name,
      "owner_id": ownerId,
      "run_time_in_secs": runTimeInSecs,
      "status": status.name,
      "visibility": visibility.name,
    });
  }
}