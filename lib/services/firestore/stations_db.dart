import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab_manager/models/lab_station.dart';

/// StationsCollection Service - handles all firestore API requests to LabStations collection.
class StationsCollection {
  /// [collectionName] - the collection name as shown at the firestore.
  static const collectionName = "LabStations";
  // [_db] - private instance which is connected to the collection.
  final CollectionReference _db = FirebaseFirestore.instance.collection(collectionName);

  /// Returns [DocumentReference] as [LabStation] corresponding to the given [uid].
  DocumentReference<LabStation> _getDoc(String uid) =>
      _db.doc(uid).withConverter<LabStation>(
          fromFirestore: (snapshot, _) =>
              LabStation.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (LabStation labStation, _) => labStation.toJson()
      );

  /// Returns [Query] as [LabStation] corresponding to the given [query].
  Query<LabStation> _withLabUserConvertor(Query query) =>
      query.withConverter<LabStation>(
          fromFirestore: (snapshot, _) => LabStation.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (LabStation labStation, _) => labStation.toJson()
      );

  /// updates the corresponding document of the given [labStation] if present, otherwise creates a new document.
  Future<void> _upsertStation(LabStation labStation) async =>
      await _getDoc(labStation.uid).set(labStation);

  /// Returns List of [LabStation] documents in which the ownerId equals to the given [ownerId].
  Stream<List<LabStation>> getStationsByOwnerId(String ownerId) =>
      _withLabUserConvertor(_db.where('owner_id', isEqualTo: ownerId))
          .snapshots().map((value) => value.docs.map((e) => e.data()).toList());

  /// Returns List of [LabStation] of all the documents in the collection.
  Stream<List<LabStation>> getAllStations() =>
      _db.withConverter<LabStation>(
          fromFirestore: (snapshot, _) =>
              LabStation.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (LabStation labStation, _) => labStation.toJson()
      ).snapshots().map((event) => event.docs.map((e) => e.data()).toList());

  /// Creates new document from the given [labStation] or update existing one.
  Future<void> upsert(LabStation labStation) => _upsertStation(labStation);

  /// Deletes the document which has the given [uid].
  Future<void> delete(String uid) => _getDoc(uid).delete();

  /// Returns [LabStation] document by the given [uid].
  Future<LabStation?> getLabStationById(String uid) => _getDoc(uid).get().then((value) => value.data());
}