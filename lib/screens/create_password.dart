import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bone/channels/cypher_channel.dart';
import 'package:flutter_bone/data/salt_pepper.dart';
import 'package:flutter_bone/models/salt_pepper_item.dart';
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
    _getSaltPepper();
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

  void _updatePassword(String password) {
    _password = password;
    _generateSaltPepper();
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
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

  void _getSaltPepper() async {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<int> count = _getSaltPepperCount();
      count.then((cnt) {
        if (cnt == 0) {
          Future<Uint8List> futureSalt = CypherChannel.generateSalt(saltSetState);
          futureSalt.then((salt) {
            Future<Uint8List> futurePepper = CypherChannel.generatePepper(pepperSetState);
            futurePepper.then((pepper) {
              _insertSaltPepper(
                  new SaltPepperItem(SaltPepper.salt, SaltPepper.pepper));
            });
          });
        } else if (cnt == 1) {
          Future<List<SaltPepperItem>> saltPepperItemListFuture =
              databaseHelper.getSaltPepperItemList();
          saltPepperItemListFuture.then((saltPepperItemList) {
            setState(() {
              this._saltPepperItemList = saltPepperItemList;
              this.spCount = saltPepperItemList.length;
              SaltPepper.salt = saltPepperItemList[0].salt;
              SaltPepper.pepper = saltPepperItemList[0].pepper;
            });
          });
        }
      });
    });
  }

  //Update database with new SaltPepper.
  void _generateSaltPepper() async {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<int> count = _getSaltPepperCount();
      count.then((cnt) {
        if (cnt == 0) {
          Future<Uint8List> futureSalt = CypherChannel.generateSalt(saltSetState);
          futureSalt.then((salt) {
            Future<Uint8List> futurePepper = CypherChannel.generatePepper(pepperSetState);
            futurePepper.then((pepper) {
              _insertSaltPepper(
                  new SaltPepperItem(SaltPepper.salt, SaltPepper.pepper));
            });
          });
        } else if (cnt == 1) {
          Future<Uint8List> futureSalt = CypherChannel.generateSalt(saltSetState);
          futureSalt.then((salt) {
            Future<Uint8List> futurePepper = CypherChannel.generatePepper(pepperSetState);
            futurePepper.then((pepper) {
              _updateSaltPepper(
                  new SaltPepperItem(SaltPepper.salt, SaltPepper.pepper));
            });
          });
        }
      });
    });
  }

  void _insertSaltPepper(SaltPepperItem saltPepperItem) async {
    int result = await databaseHelper.insertSaltPepperItem(saltPepperItem);
  }

  void _updateSaltPepper(SaltPepperItem saltPepperItem) async {
    int result = await databaseHelper.updateSaltPepperItem(saltPepperItem);
  }

  Future<int> _getSaltPepperCount() async {
    int result = await databaseHelper.getSaltPepperCount();
    return result;
  }

  void _deleteSaltPepper(
      BuildContext context, SaltPepperItem saltPepperItem) async {
    int result = await databaseHelper.deleteSaltPepperItem(saltPepperItem.id);
  }
}
