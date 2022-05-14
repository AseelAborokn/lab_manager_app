import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab_manager/models/lab_permissions.dart';

class PermissionsCollection {
  // Database name
  static const collectionName = "Permissions";
  // collection references
  final CollectionReference _db = FirebaseFirestore.instance.collection(collectionName);

  DocumentReference<AccessPermissions> _getDoc(String uid) =>
      _db.doc(uid).withConverter<AccessPermissions>(
          fromFirestore: (snapshot, _) =>
              AccessPermissions.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (AccessPermissions accessPermissions, _) => accessPermissions.toJson()
      );

  Query<AccessPermissions> _withAccessPermissionsConvertor(Query query) =>
      query.withConverter<AccessPermissions>(
          fromFirestore: (snapshot, _) => AccessPermissions.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (AccessPermissions accessPermissions, _) => accessPermissions.toJson()
      );

  Future<void> _upsertStation(AccessPermissions accessPermissions) async =>
      await _getDoc(accessPermissions.uid).set(accessPermissions);

  Stream<List<AccessPermissions>> getAccessPermissionsByRequesterId(String userId) =>
      _withAccessPermissionsConvertor(_db.where('user_id', isEqualTo: userId))
          .snapshots().map((value) => value.docs.map((e) => e.data()).toList());

  Stream<List<AccessPermissions>> getAccessPermissionsByOwnerId(String userId) =>
      _withAccessPermissionsConvertor(_db.where('owner_id', isEqualTo: userId))
          .snapshots().map((value) => value.docs.map((e) => e.data()).toList());

  Stream<List<AccessPermissions>> getAllAccessPermissions() =>
      _db.withConverter<AccessPermissions>(
          fromFirestore: (snapshot, _) =>
              AccessPermissions.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (AccessPermissions accessPermissions, _) => accessPermissions.toJson()
      ).snapshots().map((event) => event.docs.map((e) => e.data()).toList());


  // Update AccessPermissions
  Future<void> update(AccessPermissions accessPermissions) => _upsertStation(accessPermissions);
  // Create AccessPermissions
  Future<void> create(
      String stationId,
      String ownerId,
      String userId,
      String cid,
      AccessPermissionStatus status) =>
    _db.add({
      "station_id": stationId,
      "owner_id": ownerId,
      "user_id": userId,
      "cid": cid,
      "permission_status": status.name
    });
  // Delete a AccessPermissions
  Future<void> delete(String uid) => _getDoc(uid).delete();
  // Get a LabStation
  Future<AccessPermissions?> getAccessPermissionsById(String uid) => _getDoc(uid).get().then((value) => value.data());
  // Get Specific permissions
  Future<AccessPermissions?> getSpecificAccessPermissions(String userId, String ownerId, String stationId) =>
      _withAccessPermissionsConvertor(_db
          .where('user_id', isEqualTo: userId)
          .where('station_id', isEqualTo: stationId)
          .where('owner_id', isEqualTo: ownerId)
      ).get().then((permission) => (permission.docs.isNotEmpty) ? permission.docs.first.data() : null);
}