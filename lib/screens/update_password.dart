import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bone/channels/cypher_channel.dart';
import 'package:flutter_bone/data/password_data.dart';
import 'package:flutter_bone/data/password_data_util.dart';
import 'package:flutter_bone/data/salt_pepper.dart';
import 'package:flutter_bone/data/salt_pepper_util.dart';
import 'package:flutter_bone/models/password_item.dart';
import 'package:flutter_bone/models/salt_pepper_item.dart';
import 'package:flutter_bone/models/wallet_item.dart';
import 'package:flutter_bone/models/wallet_item_encrypt.dart';
import 'package:flutter_bone/navigation/wallet_navigator.dart';
import 'package:flutter_bone/screens/wallet_item_list.dart';
import 'package:flutter_bone/utils/database_helper.dart';
import 'package:flutter_bone/utils/decrypt_encrypt.dart';
import 'package:flutter_bone/utils/utils.dart';
import 'package:flutter_bone/widgets/NewPassword.dart';
import 'package:sqflite/sqlite_api.dart';

class UpdatePassword extends StatefulWidget {
  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  bool _updateAuthenticateButtonEnabled = false;
  var _formKey = GlobalKey<FormState>();
  String appBarTitle = "Bone Dry Password Wallet";
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // local state variables
  String _welcomeMessage =
      "You are changing your password.  You must first enter your current password. Then after authentication you will choose a new password. " +
      "This password will be needed to access the items in this wallet. This tool is not meant to be used as a kype " +
      "for your passwords. It is only a tool of convenience.";

  String _acknowledgementMessage = "UpdatePassword Successful";
  String _updateAcknowledgementMessage = "Password Update Successful";
  String _password = "";
  String _decryptedPassword = "";
  bool _authenticated = false;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<SaltPepperItem> _saltPepperItemList;
  int spCount = 0;

  List<PasswordItem> _passwordItemList;



  @override
  void initState() {
    super.initState();
    SaltPepperUtil.getSaltPepper(databaseHelper, saltSetState, pepperSetState, saltPepperSetState);
    PasswordDataUtil.getPasswordData(databaseHelper, passwordSetState);
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
                Form(
                  key: _formKey,
                  child: Padding(
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: passwordController,
                            style: textStyle,
                            decoration: InputDecoration(
                                labelText: "Password A-Z,a-z,0-9,special",
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
                          RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              'authenticate',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              _splashDown();
                              //_submitLogin();
                            },
                          ),
                          Container(width: 5.0),
                        ],
                      )),
                ),

                NewPassword(_updatePassword, updateEnabled: _updateAuthenticateButtonEnabled,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<WalletItem> walletItemList;
  int count = 0;
  Future<void> updateListViewFromEncrypted() async {
    await databaseHelper.initializeDatabase();
    List<WalletItemEncrypted> walletItemListEncryptedlist =
    await databaseHelper.getWalletItemEncryptedList();
    List<WalletItem> walletItemList = List<WalletItem>();
    for (WalletItemEncrypted walletItemEncrypted in walletItemListEncryptedlist) {
      walletItemEncrypted =
      await DecryptUtil.decryptFrom(walletItemEncrypted);
      walletItemList.add(WalletItem(walletItemEncrypted.lockerType,walletItemEncrypted.lockerName.lockerName,walletItemEncrypted.userName.userName,walletItemEncrypted.password.password));
    }
    setState(() {
      this.walletItemList = walletItemList;
      this.count = walletItemList.length;
    });
  }

  void stopAndResetDB() {
    //TODO think about a reset option if there is a failure.
      int a = 4;
  }

  Future<void> updateWalletItems() async {
    for(WalletItem walletItem in walletItemList) {
      if(! await _save(walletItem)) {
        stopAndResetDB();
        break;
      }
    }
  }

  Future<bool> _save(WalletItem walletItem) async {
    int result;
    WalletItemEncrypted walletItemEncrypted = await EncryptUtil.encryptFrom(walletItem);
    if (walletItem.id != null) {
      walletItemEncrypted.id = walletItem.id;
      result = await databaseHelper.updateWalletItemEncrypted(walletItemEncrypted);
    } else {
      result = await databaseHelper.insertWalletItemEncrypted(walletItemEncrypted);
    }

    if (result != 0) { //success
      return true;
    } else { //fail
      return false;
    }

  }

  void _updatePassword(String password) async {
    _password = password;
    await updateListViewFromEncrypted();
    await SaltPepperUtil.generateSaltPepper(databaseHelper,saltSetState,pepperSetState);
    await PasswordDataUtil.generatePasswordData(databaseHelper, _password, passwordDataSetState);
    await updateWalletItems();
    //
    WalletNavigator.navigateToList(context);
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

  void passwordSetState(List<PasswordItem> passwordItemList) {
    setState(() {
      this._passwordItemList = passwordItemList;
      this.spCount = passwordItemList.length;
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
      return WalletItemListScreen();
    }));

    if(result) {
      // do something maybe
    }
  }
  void _firstStage(String password) {
    setState(() {
      _password = password;
    });
  }
  Future<void> _stagePassword() async {
    await PasswordDataUtil.getPasswordData(databaseHelper, passwordSetState);

  }

  void _splashDown() {
    _authenticateLogin();
  }

  void decryptSetState(String decryptedMessage) {
    setState(() {
      _decryptedPassword = decryptedMessage;
    });
  }

  Future<void> _authenticateLogin() async {
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
          _updateAuthenticateButtonEnabled = true;
          //WalletNavigator.navigateToList(context);
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
      _authenticated = true;
      return true;
    } else {
      _authenticated = false;
      return false;
    }
  }
}
