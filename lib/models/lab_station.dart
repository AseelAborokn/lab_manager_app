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
  // Fields
  String uid;
  int stationId;
  String managerId;
  String name;
  int runTimeInSecs;
  LabStationStatus status;
  LabStationVisibility visibility;

  // Constructor
  LabStation({
    required this.uid,
    required this.stationId,
    required this.managerId,
    this.name = "",
    this.runTimeInSecs = 600,
    this.status = LabStationStatus.unavailable,
    this.visibility = LabStationVisibility.public
  });

  // Create a LabStation object from JSON object.
  LabStation.fromJson(Map<String, dynamic> fields) : this(
      uid: fields['uid'],
      stationId: fields['station_id'],
      managerId: fields['manager_id'],
      name: fields['name'],
      runTimeInSecs: fields['run_time_in_secs'] as int,
      status: LabStationStatus.values.firstWhere((element) => element.toString() == 'LabStationStatus.' + fields['status'].toString()),
      visibility: LabStationVisibility.values.firstWhere((element) => element.toString() == 'LabStationVisibility.' + fields['visibility'].toString()),
  );

  // Create JSON object from LabStation object.
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "uid": uid,
      "station_id": stationId,
      "manager_id": managerId,
      "name": name,
      "run_time_in_secs": runTimeInSecs,
      "status": status.toString(),
      "visibility": visibility.toString(),
    });
  }
}