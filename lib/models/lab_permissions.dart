enum AccessPermissionStatus {
  unrequested,
  requested,
  granted,
  denied
}

class AccessPermissions {
  // Fields
  String uid;
  String stationId;
  String ownerId;
  String userId;
  String cid;
  AccessPermissionStatus permissionStatus;

  // Constructor
  AccessPermissions({
    required this.uid,
    required this.stationId,
    required this.ownerId,
    required this.userId,
    required this.cid,
    this.permissionStatus = AccessPermissionStatus.unrequested
  });

  // Create a Admission object from JSON object.
  AccessPermissions.fromJson(String uid, Map<String, dynamic> fields) : this(
    uid: uid,
    stationId: fields['station_id'],
    ownerId: fields['owner_id'],
    userId: fields['user_id'],
    cid: fields['cid'],
    permissionStatus: AccessPermissionStatus.values.firstWhere((element) => element.toString() == 'AccessPermissionStatus.' + fields['permission_status'].toString()),
  );

  // Create JSON object from Admission object.
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "uid": uid,
      "station_id": stationId,
      "owner_id": ownerId,
      "user_id": userId,
      "cid": cid,
      "permission_status": permissionStatus.name,
    });
  }
}