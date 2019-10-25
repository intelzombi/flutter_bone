class WalletItem {
  int _id;
  String _lockerName;
  String _userName;
  String _password;
  int _lockerType;

  WalletItem(this._lockerType, this._lockerName,  this._userName, this._password,);
  WalletItem.withId(this._id, this._lockerName, this._password, this._lockerType, this._userName);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if(id!=null) {
      map['id'] = id;
    }
    map['lockerName'] = _lockerName;
    map['userName'] = _userName;
    map['lockerType'] = _lockerType;
    map['password'] = _password;

    return map;
  }

  WalletItem.fromMapObject(Map<String,dynamic> map) {
    this._id = map['id'];
    this._lockerName = map['lockerName'];
    this._userName = map['userName'];
    this._lockerType = map['lockerType'];
    this._password = map['password'];
  }

  int get id => _id;
  String get lockerName => _lockerName;

  String get userName => _userName;

  String get password => _password;

  int get lockerType => _lockerType;

  set lockerName(String value) {
    if(value.length <=255) {
      this._lockerName=value;
    }
  }
  set userName(String value) {
    if(value.length <=255) {
      this._userName=value;
    }
  }

  set lockerType(int value) {
    if(value >=1 && value <=2) {
      this._lockerType=value;
    }
  }

  set password(String value) {
    this._password = value;
  }

}