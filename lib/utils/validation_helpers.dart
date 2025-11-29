import 'package:email_validator/email_validator.dart';

String? validateEmail(String? value) {
  if (value != null && value.isEmpty) return 'Please enter your email';
  if (!EmailValidator.validate(value!)) {
    return 'Please enter a valid email address';
  }
  return null;
}

String? validatePassword(bool isLogin, String? value) {
  RegExp regExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$');
  if (value != null && value.isEmpty) return 'Please enter your password';
  if (!isLogin && !regExp.hasMatch(value!)) return 'Please enter a valid password';
  return null;
}

String? validateEditPassword(bool isLogin, String? value) {
  if(value == null || value.isEmpty){
    return null;
  }
  RegExp regExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$');
  if (!isLogin && !regExp.hasMatch(value)) return 'Please enter a valid password';
  return null;
}

String? validateConfirmPassword(String? value, String password) {
  if (password != value!) return 'Passwords do not match';
  return null;
}

String? validatePhoneNumber(String? value) {
  RegExp regExp = RegExp(r'^\+?[0-9]{10}$');

  if (value != null && value.isEmpty) return 'Please enter your phone number';
  if (!regExp.hasMatch(value!)) return 'Please enter a valid phone number';
  return null;
}

String? validateAge(String? value) {
  RegExp regExp = RegExp(r'^[0-9]{1,3}$');

  if (value != null && value.isEmpty) return 'Please enter your age';
  if (!regExp.hasMatch(value!)) return 'Please enter a valid age';
  return null;
}

String? validateStringNotEmpty(String? value, String label) {
  RegExp regExp = RegExp(r'^[A-Za-z ]+$');
  if (value != null && value.isEmpty) return 'Please enter your $label';
  if (!regExp.hasMatch(value!)) return 'Please enter a valid $label';
  return null;
}
