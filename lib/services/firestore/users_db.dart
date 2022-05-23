import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab_manager/models/lab_user.dart';

/// UsersCollection Service - handles all firestore API requests to LabUsers collection.
class UsersCollection {
  /// [collectionName] - the collection name as shown at the firestore.
  static const collectionName = "LabUsers";
  // [_db] - private instance which is connected to the collection.
  final CollectionReference _db = FirebaseFirestore.instance.collection(collectionName);

  /// Returns [Query] as [LabUser] corresponding to the given [query]
  Query<LabUser> _withLabUserConvertor(Query query) =>
      query.withConverter<LabUser>(
          fromFirestore: (snapshot, _) => LabUser.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (LabUser labUser, _) => labUser.toJson()
      );

  /// Returns [DocumentReference] as [LabUser] corresponding to the given [uid]
  DocumentReference<LabUser> _getDoc(String? uid) =>
    _db.doc(uid).withConverter<LabUser>(
        fromFirestore: (snapshot, _) => LabUser.fromJson(snapshot.id, snapshot.data()!),
        toFirestore: (LabUser labUser, _) => labUser.toJson()
    );

  /// updates the corresponding document of the given [user] if present, otherwise creates a new document.
  Future<void> _upsertUser(LabUser user) async =>
      await _getDoc(user.uid).set(user);

  /// Creates new document from the given [user] or update existing one.
  Future<void> register(LabUser user) => _upsertUser(user);

  /// Deletes the document which has the given [uid].
  Future<void> delete(String uid) =>  _getDoc(uid).delete();

  /// Updates the corresponding document of the given [user].
  Future<void> update(LabUser user) =>  _upsertUser(user);

  /// Returns [LabUser] document by the given [uid].
  Future<LabUser?> getByUid(String uid) async =>
      await _getDoc(uid).get().then((value) => value.data());

  /// Return the number od documents which has the same email as the given [email], without the document in which it's id is [uid].
  Future<int> checkUniqueEmail(String email, String? uid) async =>
    await _withLabUserConvertor(_db.where('email', isEqualTo: email).where(FieldPath.documentId, isNotEqualTo: uid)).get()
        .then((value) => value.docs)
        .then((value) => value.length);

  /// Return the number od documents which has the same username as the given [username], without the document in which it's id is [uid].
  Future<int> checkUniqueUsername(String username, String? uid) async =>
      await _withLabUserConvertor(_db.where('username', isEqualTo: username).where(FieldPath.documentId, isNotEqualTo: uid)).get()
          .then((value) => value.docs)
          .then((value) => value.length);

  /// Return the number od documents which has the same cid as the given [cid], without the document in which it's id is [uid].
  Future<int> checkUniqueCid(String? cid, String? uid) async {
    if (cid != null) {
      return await _withLabUserConvertor(_db.where('cid', isEqualTo: cid).where(FieldPath.documentId, isNotEqualTo: uid)).get()
          .then((value) => value.docs)
          .then((value) => value.length);
    } else {
      return await Future.value(0);
    }
  }

  /// Get all LabUsers as [Stream].
  Stream<QuerySnapshot> get labUsers =>
      _db.snapshots();

  /// Returns the current connected user as [LabUser].
  Stream<LabUser?> getCurrentLabUser(String? uid) =>
      _getDoc(uid).snapshots().map((event) => event.data());

  /// Returns List of [LabUser] of all the documents in the collection.
  Stream<List<LabUser>> getAllLabUser() =>
      _db.withConverter<LabUser>(
          fromFirestore: (snapshot, _) =>
              LabUser.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (LabUser labStation, _) => labStation.toJson()
      ).snapshots().map((event) => event.docs.map((e) => e.data()).toList());
}