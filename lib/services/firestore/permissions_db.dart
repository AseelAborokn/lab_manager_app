import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab_manager/models/lab_permissions.dart';

/// PermissionsCollection Service - handles all firestore API requests to Permissions collection.
class PermissionsCollection {
  /// [collectionName] - the collection name as shown at the firestore.
  static const collectionName = "Permissions";
  // [_db] - private instance which is connected to the collection.
  final CollectionReference _db = FirebaseFirestore.instance.collection(collectionName);

  /// Returns [DocumentReference] as [AccessPermissions] corresponding to the given [uid]
  DocumentReference<AccessPermissions> _getDoc(String uid) =>
      _db.doc(uid).withConverter<AccessPermissions>(
          fromFirestore: (snapshot, _) =>
              AccessPermissions.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (AccessPermissions accessPermissions, _) => accessPermissions.toJson()
      );

  /// Returns [Query] as [AccessPermissions] corresponding to the given [query]
  Query<AccessPermissions> _withAccessPermissionsConvertor(Query query) =>
      query.withConverter<AccessPermissions>(
          fromFirestore: (snapshot, _) => AccessPermissions.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (AccessPermissions accessPermissions, _) => accessPermissions.toJson()
      );

  /// updates the corresponding document of the given [accessPermissions] if present, otherwise creates a new document.
  Future<void> _upsertStation(AccessPermissions accessPermissions) async =>
      await _getDoc(accessPermissions.uid).set(accessPermissions);

  /// Returns List of [AccessPermissions] documents in which the userId equals to the given [userId].
  Stream<List<AccessPermissions>> getAccessPermissionsByRequesterId(String userId) =>
      _withAccessPermissionsConvertor(_db.where('user_id', isEqualTo: userId))
          .snapshots().map((value) => value.docs.map((e) => e.data()).toList());

  /// Returns List of [AccessPermissions] documents in which the ownerId equals to the given [ownerId].
  Stream<List<AccessPermissions>> getAccessPermissionsByOwnerId(String ownerId) =>
      _withAccessPermissionsConvertor(_db.where('owner_id', isEqualTo: ownerId))
          .snapshots().map((value) => value.docs.map((e) => e.data()).toList());

  /// Returns List of [AccessPermissions] of all the documents in the collection.
  Stream<List<AccessPermissions>> getAllAccessPermissions() =>
      _db.withConverter<AccessPermissions>(
          fromFirestore: (snapshot, _) =>
              AccessPermissions.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (AccessPermissions accessPermissions, _) => accessPermissions.toJson()
      ).snapshots().map((event) => event.docs.map((e) => e.data()).toList());

  /// Updates the corresponding document of the given [accessPermissions].
  Future<void> update(AccessPermissions accessPermissions) => _upsertStation(accessPermissions);

  /// Creates new document from the given values.
  ///
  /// [stationId] - The id of the station.
  /// [ownerId] - the id of the owner.
  /// [userId] - the id of the user who requested to access this station.
  /// [cid] - the user's card id.
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

  /// Deletes the document which has the given [uid].
  Future<void> delete(String uid) => _getDoc(uid).delete();

  /// Returns [AccessPermissions] document by the given [uid].
  Future<AccessPermissions?> getAccessPermissionsById(String uid) => _getDoc(uid).get().then((value) => value.data());

  /// returns [AccessPermissions] document by the given [userId], [ownerId] and [stationId].
  Future<AccessPermissions?> getSpecificAccessPermissions(String userId, String ownerId, String stationId) =>
      _withAccessPermissionsConvertor(_db
          .where('user_id', isEqualTo: userId)
          .where('station_id', isEqualTo: stationId)
          .where('owner_id', isEqualTo: ownerId)
      ).get().then((permission) => (permission.docs.isNotEmpty) ? permission.docs.first.data() : null);
}