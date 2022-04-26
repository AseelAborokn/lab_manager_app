import 'package:cloud_firestore/cloud_firestore.dart';

class StationsCollection {
  // Database name
  static const collectionName = "LabStations";
  // collection references
  final CollectionReference _db = FirebaseFirestore.instance.collection(collectionName);

  // Create a new LabStation
  // Delete a LabStation
  // Update a LabStation
}