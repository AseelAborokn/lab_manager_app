import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab_manager/models/lab_user.dart';

class UsersCollection {
  // Database name
  static const collectionName = "LabUsers";
  // collection references
  final CollectionReference _db = FirebaseFirestore.instance.collection(collectionName);

  Query<LabUser> _withLabUserConvertor(Query query) =>
      query.withConverter<LabUser>(
          fromFirestore: (snapshot, _) => LabUser.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (LabUser labUser, _) => labUser.toJson()
      );

  DocumentReference<LabUser> _getDoc(String? uid) =>
    _db.doc(uid).withConverter<LabUser>(
        fromFirestore: (snapshot, _) => LabUser.fromJson(snapshot.id, snapshot.data()!),
        toFirestore: (LabUser labUser, _) => labUser.toJson()
    );

  Future<void> _upsertUser(LabUser user) async =>
      await _getDoc(user.uid).set(user);

  // Create a new LabUser
  Future<void> register(LabUser user) => _upsertUser(user);

  // Delete a LabUser
  Future<void> delete(String uid) =>  _getDoc(uid).delete();

  // Update a LabUser
  Future<void> update(LabUser user) =>  _upsertUser(user);

  // Get a LabUser
  Future<LabUser?> getByUid(String uid) async =>
      await _getDoc(uid).get().then((value) => value.data());

  Future<int> checkUniqueEmail(String email, String? uid) async =>
    await _withLabUserConvertor(_db.where('email', isEqualTo: email).where(FieldPath.documentId, isNotEqualTo: uid)).get()
        .then((value) => value.docs)
        .then((value) => value.length);

  Future<int> checkUniqueUsername(String username, String? uid) async =>
      await _withLabUserConvertor(_db.where('username', isEqualTo: username).where(FieldPath.documentId, isNotEqualTo: uid)).get()
          .then((value) => value.docs)
          .then((value) => value.length);

  Future<int> checkUniqueCid(String? cid, String? uid) async {
    if (cid != null) {
      return await _withLabUserConvertor(_db.where('cid', isEqualTo: cid).where(FieldPath.documentId, isNotEqualTo: uid)).get()
          .then((value) => value.docs)
          .then((value) => value.length);
    } else {
      return await Future.value(0);
    }
  }

  // get LabUsers Stream
  Stream<QuerySnapshot> get labUsers =>
      _db.snapshots();

  // get the current connected user as LabUser (with each time it is updated!)
  Stream<LabUser?> getCurrentLabUser(String? uid) =>
      _getDoc(uid).snapshots().map((event) => event.data());

  Stream<List<LabUser>> getAllLabUser() =>
      _db.withConverter<LabUser>(
          fromFirestore: (snapshot, _) =>
              LabUser.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (LabUser labStation, _) => labStation.toJson()
      ).snapshots().map((event) => event.docs.map((e) => e.data()).toList());
}