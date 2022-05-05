import 'package:cloud_firestore/cloud_firestore.dart';

class LabUser {
  // Document Id
  final String uid;
  // Fields
  String username;
  String email;
  String cid;
  String phoneNumber;

  // Constructor
  LabUser({
    required this.uid,
    required this.username,
    required this.email,
    this.cid = "",
    this.phoneNumber = ""
  });

  // Create a LabUser object from JSON object.
  LabUser.fromJson(String uid, Map<String, dynamic> fields) : this(
    uid: uid,
    username: fields['username'],
    email: fields['email'],
    cid: (fields['cid'] != null) ? fields['cid'] : "",
    phoneNumber: (fields['phone_number'] != null) ? fields['phone_number'] : "",
  );

  // Create JSON object from LabUser object.
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "username": username,
      "email": email,
      "cid": cid,
      "phone_number": phoneNumber,
    });
  }
}