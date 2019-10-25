import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bone/models/wallet_item.dart';
import 'package:flutter_bone/screens/create_password.dart';
import 'package:flutter_bone/screens/password_item_detail.dart';
import 'package:flutter_bone/screens/password_item_list.dart';

class WalletNavigator {
  static void navigateToList(BuildContext context) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PasswordItemList();
    }));

    if(result) {
      // do something maybe
    }
  }

  static void navigateToDetail(Function updateView, BuildContext context, WalletItem passwordItem, String lockerName) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PasswordItemDetail(passwordItem, lockerName);
    }));

    if(result) {
      updateView();
    }
  }

  static void navigateToCreatePassword(BuildContext context) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CreatePassword();
    }));

    if(result) {
      // do something maybe
    }
  }
}