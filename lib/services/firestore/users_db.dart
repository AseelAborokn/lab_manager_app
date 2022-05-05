import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab_manager/models/lab_user.dart';

class UsersCollection {
  // Database name
  static const collectionName = "LabUsers";
  // collection references
  final CollectionReference _db = FirebaseFirestore.instance.collection(collectionName);

  // Create a new LabUser
  Future<void> register(LabUser user) {
    return _db.doc(user.uid).withConverter<LabUser>(
        fromFirestore: (snapshot, _) => LabUser.fromJson(snapshot.id, snapshot.data()!),
        toFirestore: (LabUser labUser, _) => labUser.toJson()
    ).set(user);
  }
  // Delete a LabUser
  // Update a LabUser
}