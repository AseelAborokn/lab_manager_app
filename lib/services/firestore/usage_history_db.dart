import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab_manager/models/usage_history.dart';

class UsageHistoryCollection {
  // Database name
  static const collectionName = "UsageHistory";
  // collection references
  final CollectionReference _db = FirebaseFirestore.instance.collection(collectionName);

  DocumentReference<UsageHistory> _getDic(String uid) =>
      _db.doc(uid).withConverter<UsageHistory>(
          fromFirestore: (snapshot, _) =>
              UsageHistory.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (UsageHistory usageHistory, _) => usageHistory.toJson()
      );

  Query<UsageHistory> _withUsageHistoryConvertor(Query query) =>
      query.withConverter<UsageHistory>(
          fromFirestore: (snapshot, _) => UsageHistory.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (UsageHistory usageHistory, _) => usageHistory.toJson()
      );

  Stream<List<UsageHistory>> getAllUsageHistory() =>
      _db.withConverter<UsageHistory>(
          fromFirestore: (snapshot, _) =>
              UsageHistory.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (UsageHistory usageHistory, _) => usageHistory.toJson()
      ).snapshots().map((event) => event.docs.map((e) => e.data()).toList());

  // Create a UsageHistory
  // Delete a UsageHistory
  // Update a UsageHistory
}