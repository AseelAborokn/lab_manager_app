import 'package:lab_manager/models/lab_user.dart';

/// Represent a registration attempt (to our application) result.
class RegistrationResult {
  /// [errorMessage] - if case there was error (otherwise null), this field will contain the information of what happened.
  String? errorMessage;
  /// [labUser] - if case there was not any error (otherwise null), this field will contain the create [LabUser].
  LabUser? labUser;

  RegistrationResult({ this.labUser, this.errorMessage });
}