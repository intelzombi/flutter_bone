import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bone/channels/cypher_channel.dart';
import 'package:flutter_bone/data/password_data.dart';
import 'package:flutter_bone/data/password_data_util.dart';
import 'package:flutter_bone/data/salt_pepper.dart';
import 'package:flutter_bone/data/salt_pepper_util.dart';
import 'package:flutter_bone/models/salt_pepper_item.dart';
import 'package:flutter_bone/screens/wallet_item_list.dart';
import 'package:flutter_bone/utils/database_helper.dart';
import 'package:flutter_bone/widgets/NewPassword.dart';
import 'package:sqflite/sqlite_api.dart';

class CreatePassword extends StatefulWidget {
  @override
  _CreatePasswordState createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  var _formKey = GlobalKey<FormState>();
  String appBarTitle = "Bone Dry Password Wallet";
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // local state variables
  String _welcomeMessage =
      "Welcome to Bone Dry Password Wallet. First up you must create a Password. It is important to note that the password you " +
      "are choosing is not saved anywhere with this application. If you forget this password there is no way to recover the " +
      "password or any items stored " +
      "in this wallet. This password will be needed to access the items in this wallet. This tool is not meant to be used as a kype " +
      "for your passwords. It is only a tool of convenience.";

  String _acknowledgementMessage = "CreatePassword Successful";
  String _updateAcknowledgementMessage = "Password Update Successful";
  String _password = "";
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<SaltPepperItem> _saltPepperItemList;
  int spCount = 0;

  @override
  void initState() {
    super.initState();
    SaltPepperUtil.getSaltPepper(databaseHelper, saltSetState, pepperSetState, saltPepperSetState);
  }

  String _decryptedMessage = "decryptedMessage";

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            },
          ),
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Text(
                    _welcomeMessage,
                    textScaleFactor: .85,
                    style: textStyle,
                    softWrap: true,
                  ),
                ),
                NewPassword(_updatePassword),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updatePassword(String password) async {
    _password = password;
    await SaltPepperUtil.generateSaltPepper(databaseHelper,saltSetState,pepperSetState);
    await PasswordDataUtil.generatePasswordData(databaseHelper, _password, passwordDataSetState);
    navigateToList();
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void passwordDataSetState(String clearPassword, Uint8List password) {
    setState(() {
      PasswordData.password = password;
      PasswordData.clearPassword = clearPassword;
    });
  }

  void saltSetState(Uint8List salt) {
      setState(() {
        SaltPepper.salt = salt;
      });
  }

  void pepperSetState(Uint8List pepper) {
    setState(() {
      SaltPepper.pepper = pepper;
    });
  }

  void saltPepperSetState(List<SaltPepperItem> saltPepperItemList) {
    setState(() {
      this._saltPepperItemList = saltPepperItemList;
      this.spCount = saltPepperItemList.length;
      SaltPepper.salt = saltPepperItemList[0].salt;
      SaltPepper.pepper = saltPepperItemList[0].pepper;
    });
  }

  void navigateToList() async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WalletItemList();
    }));

    if(result) {
      // do something maybe
    }
  }

}
