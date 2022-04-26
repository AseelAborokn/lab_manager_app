import 'package:cloud_firestore/cloud_firestore.dart';

class UsersCollection {
  // Database name
  static const collectionName = "LabUsers";
  // collection references
  final CollectionReference _db = FirebaseFirestore.instance.collection(collectionName);

  // Create a new LabUser
  // Delete a LabUser
  // Update a LabUser
}