import 'dart:typed_data';

class PasswordItem {
  //only 1 row for Password allowed.
  final int _id = 1;

  int get id => _id;
  Uint8List _password;

  PasswordItem(this._password);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['password'] = _password;
    return map;
  }

  PasswordItem.fromMapObject(Map<String, dynamic> map) {
    int tid = map['id'];
    if (tid != this._id) {
      throw Exception(["Password Item Table has invalid row id"]);
    }
    this._password = map['password'];
  }

  Uint8List get password => _password;

  set password(Uint8List value) {
    this._password = value;
  }

}
