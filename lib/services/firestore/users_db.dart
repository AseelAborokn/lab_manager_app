import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab_manager/models/lab_user.dart';

class UsersCollection {
  // Database name
  static const collectionName = "LabUsers";
  // collection references
  final CollectionReference _db = FirebaseFirestore.instance.collection(collectionName);

  DocumentReference<LabUser> _getDoc(String uid) =>
    _db.doc(uid).withConverter<LabUser>(
        fromFirestore: (snapshot, _) => LabUser.fromJson(snapshot.id, snapshot.data()!),
        toFirestore: (LabUser labUser, _) => labUser.toJson()
    );

  // Create a new LabUser
  Future<void> register(LabUser user) async =>
      await _getDoc(user.uid).set(user);

  // Delete a LabUser

  // Update a LabUser

  // Get a LabUser
  Future<LabUser?> getByUid(String uid) async =>
      await _getDoc(uid).get().then((value) => value.data());

  // get LabUsers Stream
  Stream<QuerySnapshot> get labUsers =>
      _db.snapshots();

  // get the current connected user as LabUser (with each time it is updated!)
  Stream<LabUser?> getCurrentLabUser(String uid) =>
      _getDoc(uid).snapshots().map((event) => event.data());
}