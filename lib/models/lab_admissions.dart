class Admissions {
  // Fields
  String uid;
  int stationId;
  String managerId;
  String userId;
  bool authorized;

  // Constructor
  Admissions({
    required this.uid,
    required this.stationId,
    required this.managerId,
    required this.userId,
    this.authorized = false
  });

  // Create a Admission object from JSON object.
  Admissions.fromJson(Map<String, dynamic> fields) : this(
    uid: fields['uid'],
    stationId: fields['station_id'],
    managerId: fields['manager_id'],
    userId: fields['user_id'],
    authorized: fields['authorized'] as bool,
  );

  // Create JSON object from Admission object.
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "uid": uid,
      "station_id": stationId,
      "manager_id": managerId,
      "user_id": userId,
      "authorized": authorized,
    });
  }
}