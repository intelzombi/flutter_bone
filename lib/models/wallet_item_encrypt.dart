import 'dart:typed_data';

import 'package:flutter_bone/models/wallet_item.dart';

class WalletItemEncrypted {
  int _id;

  set id(int value) {
    _id = value;
  }

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

  WalletItemEncrypted.withId(this._id,this._lockerType, this._lockerName, this._userName, this._password);

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
    this._lockerName = LockerName("",  map['lockerName']);
    this._userName = UserName("", map['userName']);
    this._password = Password("", map['password']);
    this._lockerType = map['lockerType'];
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

  LockerName(this._lockerName, this._lockerNameEncrypted);

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

  UserName(this._userName, this._userNameEncrypted);

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

  Password(this._password, this._passwordEncrypted);

  set passwordEncrypted(Uint8List value) {
    _passwordEncrypted = value;
  }
}
