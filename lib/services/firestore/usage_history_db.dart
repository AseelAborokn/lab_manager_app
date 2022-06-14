import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab_manager/models/lab_usage_history.dart';

/// UsageHistoryCollection Service - handles all firestore API requests to UsageHistory collection.
class UsageHistoryCollection {
  /// [collectionName] - the collection name as shown at the firestore.
  static const collectionName = "UsageHistory";
  // [_db] - private instance which is connected to the collection.
  final CollectionReference _db = FirebaseFirestore.instance.collection(collectionName);

  /// Returns [Query] as [UsageHistory] corresponding to the given [query]
  Query<UsageHistory> _withLabUserConvertor(Query query) =>
      query.withConverter<UsageHistory>(
          fromFirestore: (snapshot, _) => UsageHistory.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (UsageHistory usageHistory, _) => usageHistory.toJson()
      );

  /// Returns List of [UsageHistory] of all the documents in the collection.
  Stream<List<UsageHistory>> getAllUsageHistory() =>
      _db.withConverter<UsageHistory>(
          fromFirestore: (snapshot, _) =>
              UsageHistory.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (UsageHistory usageHistory, _) => usageHistory.toJson()
      ).snapshots().map((event) => event.docs.map((e) => e.data()).toList());

  /// Deletes all the records where the station_id equals to the given [stationId].
  Future<void> deleteAllUsagesForStation(String stationId) async {
    await _withLabUserConvertor(_db.where('station_id', isEqualTo: stationId)).get().then(
            (snapshot) => snapshot.docs.forEach((doc) { doc.reference.delete(); })
    );
  }
}