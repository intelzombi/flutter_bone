import 'dart:typed_data';

class PasswordData {
  static Uint8List _password;
  static String _clearPassword;

  static String get clearPassword => _clearPassword;
  static set clearPassword(String value) {
    _clearPassword = value;
  }

  static Uint8List get password => _password;
  static set password(Uint8List value) {
    _password = value;
  }
}