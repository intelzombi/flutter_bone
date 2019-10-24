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
  String _initialWelcomeMessage = "Welcome to Bone Dry Password Wallet. "
      "The first step is to create a password.  This will be the only password you have to remember."
      "Make is Strong.  No Spaces.  Recommendations include a minimum of 10 characters, at least one of each of the following:"
      "an uppercase character, a number, and a special character. "
      "Heeding the recommendation is up to you.  Your password is yours to choose.  "
      "Disclaimer;  This software is not meant as a sole repository for passwords.  Your password is never saved anywhere in this application. "
      "If you forget you password there is no "
      "ability to recover your wallet items.  They will be lost.  Always keep a copy of your passwords in a safe secure place.  "
      "This software is a convienience application only.  It is meant to be able to give you an easy way to store and retrieve all of "
      "your passwords and only having to remember one password.  The one you are about to choose.  It bears repeating; If you forget "
      "your password there is no way to retrieve the data.  Back your passwords up.  This application should not be used as your only "
      "way to remeber your passwords. Use the software at your own risk";

  String _welcomeMessage =
      "Welcome to Bone Dry Password Wallet. First Up you must create a Password";
  String _acknowledgementMessage = "CreatePassword Successful";
  String _updateAcknowledgementMessage = "Password Update Successful";
  String _password = "";

  bool _welcomeAcknowledged = false;
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
                    _welcomeAcknowledged
                        ? _initialWelcomeMessage
                        : _welcomeMessage,
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
      Future<int> count = _getSaltPepperCount(context);
      count.then((cnt) {
        if (cnt == 0) {
          Future<Uint8List> futureSalt = CypherChannel.generateSalt(saltSetState);
          futureSalt.then((salt) {
            Future<Uint8List> futurePepper = CypherChannel.generatePepper(pepperSetState);
            futurePepper.then((pepper) {
              _insertSaltPepper(context,
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
      Future<int> count = _getSaltPepperCount(context);
      count.then((cnt) {
        if (cnt == 0) {
          Future<Uint8List> futureSalt = CypherChannel.generateSalt(saltSetState);
          futureSalt.then((salt) {
            Future<Uint8List> futurePepper = CypherChannel.generatePepper(pepperSetState);
            futurePepper.then((pepper) {
              _insertSaltPepper(context,
                  new SaltPepperItem(SaltPepper.salt, SaltPepper.pepper));
            });
          });
        } else if (cnt == 1) {
          Future<Uint8List> futureSalt = CypherChannel.generateSalt(saltSetState);
          futureSalt.then((salt) {
            Future<Uint8List> futurePepper = CypherChannel.generatePepper(pepperSetState);
            futurePepper.then((pepper) {
              _updateSaltPepper(context,
                  new SaltPepperItem(SaltPepper.salt, SaltPepper.pepper));
            });
          });
        }
      });
    });
  }

  void _showAlertDialog(String lockerName, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(lockerName),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _insertSaltPepper(
      BuildContext context, SaltPepperItem saltPepperItem) async {
    int result = await databaseHelper.insertSaltPepperItem(saltPepperItem);
  }

  void _updateSaltPepper(
      BuildContext context, SaltPepperItem saltPepperItem) async {
    int result = await databaseHelper.updateSaltPepperItem(saltPepperItem);
  }

  Future<int> _getSaltPepperCount(BuildContext context) async {
    int result = await databaseHelper.getSaltPepperCount();
    return result;
  }

  void _deleteSaltPepper(
      BuildContext context, SaltPepperItem saltPepperItem) async {
    int result = await databaseHelper.deleteSaltPepperItem(saltPepperItem.id);
  }
}
