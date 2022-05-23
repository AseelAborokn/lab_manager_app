/// Model which represents document in LabUsers collection.
class LabUser {
  // Fields
  /// [uid] - DocumentId.
  String uid;
  /// [username] - The username of the user.
  String username;
  /// [email] - The email of the user.
  String email;
  /// [cid] - The cardId of the user.
  String? cid;
  /// [phoneNumber] - The phone number of the user.
  String phoneNumber;

  // Constructor
  LabUser({
    required this.uid,
    required this.username,
    required this.email,
    this.cid,
    this.phoneNumber = ""
  });

  /// Converts a JSON object to [LabUser] instance.
  LabUser.fromJson(String uid, Map<String, dynamic> fields) : this(
    uid: uid,
    username: fields['username'],
    email: fields['email'],
    cid: (fields['cid'] != null) ? fields['cid'] : "",
    phoneNumber: (fields['phone_number'] != null) ? fields['phone_number'] : "",
  );

  /// Converts [LabUser] instance to JSON object.
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from({
      "username": username,
      "email": email,
      "cid": cid,
      "phone_number": phoneNumber,
    });
  }
}