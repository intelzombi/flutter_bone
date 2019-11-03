import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bone/channels/cypher_channel.dart';
import 'package:flutter_bone/data/password_data.dart';
import 'package:flutter_bone/data/password_data_util.dart';
import 'package:flutter_bone/data/salt_pepper.dart';
import 'package:flutter_bone/data/salt_pepper_util.dart';
import 'package:flutter_bone/models/password_item.dart';
import 'package:flutter_bone/models/salt_pepper_item.dart';
import 'package:flutter_bone/navigation/wallet_navigator.dart';
import 'package:flutter_bone/utils/database_helper.dart';
import 'package:flutter_bone/utils/utils.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _formKey = GlobalKey<FormState>();
  String appBarTitle = "Bone Dry Password Wallet";
  TextEditingController clearMessageController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // local state variables
  String _initialWelcomeMessage = "Welcome";
  String _someOtherMessage = "Welcome to Bone Dry Password Wallet. "
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

  String _welcomeMessage = "Welcome to Bone Dry Password Wallet";
  String _someOtherOtherMessage =
      "Welcome back to Bone Dry Password Wallet. If you forget "
      "your password there is no way to retrieve the data.  Your password is never saved anywhere in this application. Physically back "
      "your passwords up (paper and pen).  This application should not be used as your only "
      "way to remember your passwords. Use this software at your own risk";
  String _acknowledgementMessage = "Login Successful";
  String _updateAcknowledgementMessage = "Password Update Successful";
  String _password = "";
  String _decryptedPassword = "";

  bool _welcomeAcknowledged = false;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<SaltPepperItem> _saltPepperItemList;
  int spCount = 0;
  List<PasswordItem> _passwordItemList;
  int pwCount = 0;

  @override
  void initState() {
    super.initState();
    SaltPepperUtil.getSaltPepper(
        databaseHelper, saltSetState, pepperSetState, saltPepperSetState);
  }

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
            padding: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                //First Element
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Text(
                    _welcomeAcknowledged
                        ? _initialWelcomeMessage
                        : _welcomeMessage,
                    style: textStyle,
                    softWrap: true,
                  ),
                ),

                //Second Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
                  child: Text(
                    "Enter Password",
                  ),
                ),

                //fourth Element
                Form(
                  key: _formKey,
                  child: Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: passwordController,
                            style: textStyle,
                            decoration: InputDecoration(
                                labelText: "PW...AZ,az,09,!@#\$%..",
                                labelStyle: textStyle,
                                errorStyle: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 15.0,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            validator: (String value) {
                              _firstStage(value);
                              return null;
                            },
                          ),
                          Container(width: 5.0, height: 10.0,),
                          RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              'Login',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              _splashDown();
                              //_submitLogin();
                            },
                          ),
                          Container(width: 5.0,height: 10,),
                          RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              'Create Password',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              WalletNavigator.navigateToCreatePassword(context);
                            },
                          ),
                          Container(width: 5.0, height: 10,),
                          RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              'Update Password',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              WalletNavigator.navigateToUpdatePassword(context);
                            },
                          ),
                        ],
                      )),
                ),
                //fifth Element

                //seventh Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _splashDown() {
    _submitLogin();
  }
  void _firstStage(String password) {
    setState(() {
      _password = password;
    });
  }
  Future<void> _stagePassword() async {
    await PasswordDataUtil.getPasswordData(databaseHelper, passwordSetState);

  }

  Future<void> _submitLogin() async {
    if (_formKey.currentState.validate()) {
      await _stagePassword();
      if(_passwordItemList.isEmpty) {
        Notifier(context).showAlertDialog(
            "Password is Incorrect",
            "Please Re-Enter Password \nHave you SET your password?");
      }else {
        Uint8List encryptPassword = _passwordItemList[0].password;
        await CypherChannel.decryptMsg(decryptSetState, encryptPassword, _password,
            SaltPepper.salt, SaltPepper.pepper);
        if (_comparePasswords()) {
          PasswordData.password = encryptPassword;
          PasswordData.clearPassword = _password;
          WalletNavigator.navigateToList(context);
        } else {
          Notifier(context).showAlertDialog(
              "Password is Incorrect",
              "Please Re-Enter Password \nHave you SET your password?");
        }
      }
    }
  }

  void updatePassword() {
    _password = passwordController.text;
  }

  bool _comparePasswords() {
    if(_password == _decryptedPassword) {
      return true;
    } else {
      return false;
    }
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

  void decryptSetState(String decryptedMessage) {
    setState(() {
      _decryptedPassword = decryptedMessage;
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

  void passwordSetState(List<PasswordItem> passwordItemList) {
    setState(() {
      this._passwordItemList = passwordItemList;
      this.pwCount = passwordItemList.length;
    });
  }
}
