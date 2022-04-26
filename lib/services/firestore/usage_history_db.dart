import 'package:cloud_firestore/cloud_firestore.dart';

class UsageHistoryCollection {
  // Database name
  static const collectionName = "UsageHistory";
  // collection references
  final CollectionReference _db = FirebaseFirestore.instance.collection(collectionName);

  // Create a UsageHistory
  // Delete a UsageHistory
  // Update a UsageHistory
}