import 'package:cloud_firestore/cloud_firestore.dart';

class AdmissionsCollection {
  // Database name
  static const collectionName = "Admissions";
  // collection references
  final CollectionReference _db = FirebaseFirestore.instance.collection(collectionName);

  // Create a new Admission
  // Update a Admission
}