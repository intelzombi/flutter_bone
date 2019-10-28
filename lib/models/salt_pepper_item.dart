import 'dart:typed_data';

class SaltPepperItem {
  //only 1 row for Salt and Pepper allowed.
  final int _id = 1;

  int get id => _id;
  Uint8List _salt;
  Uint8List _pepper;

  SaltPepperItem(this._salt, this._pepper,);
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['salt'] = _salt;
    map['pepper'] = _pepper;

    return map;
  }

  SaltPepperItem.fromMapObject(Map<String,dynamic> map) {
    int tid = map['id'];
    if(tid != this._id) {
      throw Exception(["Salt Pepper Table has invalid row id"]);
    }
    this._salt = map['salt'];
    this._pepper = map['pepper'];
  }

  Uint8List get salt => _salt;

  Uint8List get pepper => _pepper;

  set salt(Uint8List value) {
    this._salt=value;

  }
  set pepper(Uint8List value) {
      this._pepper=value;
  }
}