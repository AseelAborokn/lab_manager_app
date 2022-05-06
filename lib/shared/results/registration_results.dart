import 'package:lab_manager/models/lab_user.dart';

class RegistrationResult {
  String? errorMessage;
  LabUser? labUser;

  RegistrationResult({ this.labUser, this.errorMessage });
}