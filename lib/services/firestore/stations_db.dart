import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab_manager/models/lab_station.dart';

class StationsCollection {
  // Database name
  static const collectionName = "LabStations";

  // collection references
  final CollectionReference _db = FirebaseFirestore.instance.collection(collectionName);

  DocumentReference<LabStation> _getDoc(String uid) =>
      _db.doc(uid).withConverter<LabStation>(
          fromFirestore: (snapshot, _) =>
              LabStation.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (LabStation labStation, _) => labStation.toJson()
      );

  Query<LabStation> _withLabUserConvertor(Query query) =>
      query.withConverter<LabStation>(
          fromFirestore: (snapshot, _) => LabStation.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (LabStation labStation, _) => labStation.toJson()
      );

  Future<void> _upsertStation(LabStation labStation) async =>
      await _getDoc(labStation.uid).set(labStation);

  Stream<List<LabStation>> getStationsByOwnerId(String userId) =>
      _withLabUserConvertor(_db.where('owner_id', isEqualTo: userId))
          .snapshots().map((value) => value.docs.map((e) => e.data()).toList());

  Stream<List<LabStation>> getAllStations() =>
      _db.withConverter<LabStation>(
          fromFirestore: (snapshot, _) =>
              LabStation.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (LabStation labStation, _) => labStation.toJson()
      ).snapshots().map((event) => event.docs.map((e) => e.data()).toList());

  // Create or Update a new LabStation
  Future<void> upsert(LabStation labStation) => _upsertStation(labStation);
  // Delete a LabStation
  Future<void> delete(String uid) => _getDoc(uid).delete();
  // Get a LabStation
  Future<LabStation?> getLabStationById(String uid) => _getDoc(uid).get().then((value) => value.data());
}