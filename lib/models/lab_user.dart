class LabUser {
  // Fields
  final String uid;
  String authId;
  String email;
  String? cid;
  String name;
  String? phoneNumber;

  // Constructor
  LabUser({
    required this.uid,
    required this.authId,
    this.email = "",
    this.cid,
    this.name = "",
    this.phoneNumber
  });

  // Create a LabUser object from JSON object.
  LabUser.fromJson(Map<String, dynamic> fields) : this(
    uid: fields['uid'],
    authId: fields['auth_id'],
    email: fields['email'],
    cid: fields['cid'],
    name: fields['name'],
    phoneNumber: fields['phone_number']
  );

  // Create JSON object from LabUser object.
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "uid": uid,
      "auth_id": authId,
      "email": email,
      "cid": cid,
      "name": name,
      "phone_number": phoneNumber,
    });
  }
}