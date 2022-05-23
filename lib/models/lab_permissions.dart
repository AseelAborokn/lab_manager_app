import 'package:lab_manager/models/lab_user.dart';
import 'package:lab_manager/screens/home/permissions.dart';

/// Access Permission Status
///
/// - [unrequested] : In case there is no pending request from this user to the owner.
/// - [requested] : In case there is a pending request from this user to the owner which not handled yet.
/// - [granted] : In case the user can access this station.
/// - [denied] : In case the user cannot access this station.
enum AccessPermissionStatus {
  unrequested,
  requested,
  granted,
  denied
}

/// Model which represents document in Permissions collection.
class AccessPermissions {
  // Fields
  /// [uid] - DocumentId.
  String uid;
  /// [stationId] - StationId = DocumentId (readable name).
  String stationId;
  /// [ownerId] - OwnerId, the documentId of [LabUser] who own the station.
  String ownerId;
  /// [userId] - userId, the documentId of [LabUser] who requested to access this station.
  String userId;
  /// [cid] - cardId, the id of the card of the user who requested to access this station.
  String cid;
  /// [permissionStatus] - Accessibility Permission Status.
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

  /// Converts a JSON object to [AccessPermissions] instance.
  AccessPermissions.fromJson(String uid, Map<String, dynamic> fields) : this(
    uid: uid,
    stationId: fields['station_id'],
    ownerId: fields['owner_id'],
    userId: fields['user_id'],
    cid: fields['cid'],
    permissionStatus: AccessPermissionStatus.values.firstWhere((element) => element.toString() == 'AccessPermissionStatus.' + fields['permission_status'].toString()),
  );

  /// Converts [AccessPermissions] instance to JSON object.
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "station_id": stationId,
      "owner_id": ownerId,
      "user_id": userId,
      "cid": cid,
      "permission_status": permissionStatus.name,
    });
  }
}