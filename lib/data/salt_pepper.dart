import 'dart:typed_data';

class SaltPepper {
  static Uint8List _salt;

  static Uint8List get salt => _salt;

  static set salt(Uint8List value) {
    _salt = value;
  }

  static Uint8List _pepper;

  static Uint8List get pepper => _pepper;

  static set pepper(Uint8List value) {
    _pepper = value;
  }

}