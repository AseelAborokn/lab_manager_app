///@nodoc
import 'package:email_validator/email_validator.dart';

bool validPhoneNumber(String phoneNumber) {
  if (phoneNumber.length != 10) {
    return false;
  }
  return true;
}

bool validEmail(String email) {
  return EmailValidator.validate(email);
}

bool validCid(String? cid) {
  return (cid == null || cid.length < 14);
}