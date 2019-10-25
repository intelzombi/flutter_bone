import 'dart:typed_data';

class WalletItemEncrypted {
  int _id;
  LockerName _lockerName;
  UserName _userName;
  Password _password;
  int _lockerType;

  WalletItemEncrypted(
    this._lockerType,
    this._lockerName,
    this._userName,
    this._password,
  );

  WalletItemEncrypted.withId(this._id, this._lockerName, this._password,
      this._lockerType, this._userName);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = id;
    }
    map['lockerName'] = _lockerName.lockerNameEncrypted;
    map['userName'] = _userName.userNameEncrypted;
    map['lockerType'] = _lockerType;
    map['password'] = _password.passwordEncrypted;

    return map;
  }

  WalletItemEncrypted.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._lockerName.lockerNameEncrypted = map['lockerName'];
    this._userName.userNameEncrypted = map['userName'];
    this._lockerType = map['lockerType'];
    this._password.passwordEncrypted = map['password'];
  }

  int get id => _id;

  LockerName get lockerName => _lockerName;

  UserName get userName => _userName;

  Password get password => _password;

  int get lockerType => _lockerType;

  set lockerName(LockerName value) {
    this._lockerName = value;
  }

  set userName(UserName value) {
    this._userName = value;
  }

  set lockerType(int value) {
    if (value >= 1 && value <= 2) {
      this._lockerType = value;
    }
  }

  set password(Password value) {
    this._password = value;
  }
}

class LockerName {
  String _lockerName;
  Uint8List _lockerNameEncrypted;

  LockerName();

  String get lockerName => _lockerName;

  Uint8List get lockerNameEncrypted => _lockerNameEncrypted;

  set lockerName(String value) {
    _lockerName = value;
  }

  set lockerNameEncrypted(Uint8List value) {
    _lockerNameEncrypted = value;
  }
}

class UserName {
  String _userName;

  set userName(String value) {
    _userName = value;
  }

  String get userName => _userName;
  Uint8List _userNameEncrypted;

  Uint8List get userNameEncrypted => _userNameEncrypted;

  UserName();

  set userNameEncrypted(Uint8List value) {
    _userNameEncrypted = value;
  }
}

class Password {
  String _password;

  String get password => _password;
  Uint8List _passwordEncrypted;

  set password(String value) {
    _password = value;
  }

  Uint8List get passwordEncrypted => _passwordEncrypted;

  Password();

  set passwordEncrypted(Uint8List value) {
    _passwordEncrypted = value;
  }
}
