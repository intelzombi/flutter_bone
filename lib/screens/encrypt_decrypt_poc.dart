import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bone/models/salt_pepper_item.dart';
import 'package:flutter_bone/data/salt_pepper.dart';
import 'package:flutter_bone/utils/database_helper.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqlite_api.dart';

class EncryptDecryptPoc extends StatefulWidget {
  @override
  _EncryptDecryptPocState createState()=>_EncryptDecryptPocState();
}

class _EncryptDecryptPocState extends State<EncryptDecryptPoc> {

  String appBarTitle = "Hide Me if you can";
  TextEditingController clearMessageController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // local state variables
  String _clearMessage = "";
  String _encryptedMessage = "";
  String _password = "";

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<SaltPepperItem> _saltPepperItemList;
  int spCount = 0;

  static const platform = const MethodChannel('iceberg.gunsnhoney.flutter_bone/cypher');

  @override
  void initState() {
    super.initState();
    _getSaltPepper();
  }

  //Uint8List _salt;
  Future<Uint8List> _generateSalt() async {
    Uint8List salt;
    try {
      final Uint8List result = await platform.invokeMethod('generateSalt');
      salt = result;
    } on PlatformException catch (e) {
        int a = 4;
    }
    setState(() {
      SaltPepper.salt = salt;
    });
    return salt;
  }

  //Uint8List _pepper;
  Future<Uint8List> _generatePepper() async {
    Uint8List pepper;
    try {
      final Uint8List result = await platform.invokeMethod('generateIV');
      pepper = result;
    } on PlatformException catch (e) {
      int a = 4;
    }
    setState(() {
      SaltPepper.pepper = pepper;
    });
    return pepper;
  }

  Uint8List _encryptedMessageByteForm;
  Future<Uint8List> _encryptMsg(String clearMessage, String password, salt, pepper) async {
    Uint8List encryptedMessageByteForm;
    try {
      final Uint8List result = await platform.invokeMethod('encryptMsg', <String, dynamic> {
        'password': password,
        'clearMessage': clearMessage,
        'salt': salt,
        'pepper': pepper,
      });
      encryptedMessageByteForm = result;

    } on PlatformException catch (e) {

    }
    setState(() {
      _encryptedMessageByteForm = encryptedMessageByteForm;
      _encryptedMessage = encryptedMessageByteForm.toString();
    });
    return encryptedMessageByteForm;
  }

  String _decryptedMessage = "decryptedMessage";
  Future<String> _decryptMsg(Uint8List encryptedMessage, String password, Uint8List salt,  Uint8List pepper) async {
    String decryptedMessage;
    try {
      final String result = await platform.invokeMethod('decryptMsg', <String, dynamic> {
        'password': password,
        'encryptedMessage': encryptedMessage,
        'salt': salt,
        'pepper': pepper,
      });
      decryptedMessage = result;
    } on PlatformException catch (e) {
      //iv='we didn\'t see the cat';
    }

    setState(() {
      _decryptedMessage = decryptedMessage;
    });
    return decryptedMessage;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .title;
    return WillPopScope(
        onWillPop: () {
      moveToLastScreen();
    },
      child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(icon: Icon(Icons.arrow_back),
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
                  //First Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: clearMessageController,
                      style: textStyle,
                      onChanged: (value) {
                        debugPrint('Something changed in the LockerName Text Field');
                        updateClearMessage();
                      },
                      decoration: InputDecoration(
                          labelText: "Clear Message",
                          labelStyle: textStyle,
                          errorStyle: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 15.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)
                          )
                      ),
                    ),
                  ),

                  //Second Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Text(_encryptedMessage,
                          ),
                    ),

                  //fourth Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                        child: TextField(
                          controller: passwordController,
                          style: textStyle,
                          onChanged: (value) {
                            debugPrint(
                                'Something changed in the password Text Field');
                            updatePassword();
                          },
                          decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: textStyle,
                              errorStyle: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 15.0,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)
                              )
                          ),
                        ),
                        ),
                        Container(width: 5.0),
                        Expanded(
                          child: RaisedButton(
                            color: Theme
                                .of(context)
                                .primaryColorDark,
                            textColor: Theme
                                .of(context)
                                .primaryColorLight,
                            child: Text(
                              'set password',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("set password button clicked");
                                _generateSaltPepper();
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),

                  //fifth Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Text(_decryptedMessage,
                    ),
                  ),
                  //sixth Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            color: Theme
                                .of(context)
                                .primaryColorDark,
                            textColor: Theme
                                .of(context)
                                .primaryColorLight,
                            child: Text(
                              'salt',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("salt button clicked");
                                  _generateSalt();
                              });
                            },
                          ),
                        ),
                        Container(width: 5.0),
                        Expanded(
                          child: RaisedButton(
                            color: Theme
                                .of(context)
                                .primaryColorDark,
                            textColor: Theme
                                .of(context)
                                .primaryColorLight,
                            child: Text(
                              'pepper',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("pepper button clicked");
                                _generatePepper();
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  //seventh Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            color: Theme
                                .of(context)
                                .primaryColorDark,
                            textColor: Theme
                                .of(context)
                                .primaryColorLight,
                            child: Text(
                              'Encrypt',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("encrypt button clicked");
                                _encrypt();
                              });
                            },
                          ),
                        ),
                        Container(width: 5.0),
                        Expanded(
                          child: RaisedButton(
                            color: Theme
                                .of(context)
                                .primaryColorDark,
                            textColor: Theme
                                .of(context)
                                .primaryColorLight,
                            child: Text(
                              'Decrypt',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("Decrypt button clicked");
                                _decrypt();
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  void updateClearMessage() {
    _clearMessage = clearMessageController.text;
  }

  void updatePassword() {
    _password = passwordController.text;

  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void _encrypt() async {

    Uint8List resultEncryptedMsg = await _encryptMsg(_clearMessage, _password, SaltPepper.salt, SaltPepper.pepper);

    int result = 1;

//    if (result != 0) { //success
//      _showAlertDialog('Status', 'Wallet Item Saved Successfully');
//    } else { //fail
//      _showAlertDialog('Status', 'Problem Saving Wallet Item');
//    }
  }

  void _decrypt() async {
    String resultDecrypt = await _decryptMsg(_encryptedMessageByteForm, _password, SaltPepper.salt, SaltPepper.pepper);

    int result =1 ;
//    if(result!=0) {
//      _showAlertDialog('Status', 'Wallet Item Deleted Successfully');
//    } else {
//      _showAlertDialog('Status', 'Error Occured while Deleting Wallet Item');
//    }
  }

  void _getSaltPepper() async {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<int> count = _getSaltPepperCount(context);
      count.then((cnt) {
        if(cnt == 0) {
          Future<Uint8List> futureSalt =_generateSalt();
          futureSalt.then((salt) {
            Future<Uint8List> futurePepper =_generatePepper();
            futurePepper.then((pepper) {
              _insertSaltPepper(context, new SaltPepperItem(SaltPepper.salt,SaltPepper.pepper));
          });});
        } else if(cnt == 1) {
          Future<List<SaltPepperItem>> saltPepperItemListFuture = databaseHelper.getSaltPepperItemList();
          saltPepperItemListFuture.then((saltPepperItemList) {
            setState(() {
              this._saltPepperItemList=saltPepperItemList;
              this.spCount=saltPepperItemList.length;
              SaltPepper.salt=saltPepperItemList[0].salt;
              SaltPepper.pepper=saltPepperItemList[0].pepper;
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
        if(cnt == 0) {
          Future<Uint8List> futureSalt =_generateSalt();
          futureSalt.then((salt) {
            Future<Uint8List> futurePepper =_generatePepper();
            futurePepper.then((pepper) {
              _insertSaltPepper(context, new SaltPepperItem(SaltPepper.salt,SaltPepper.pepper));
            });});
        } else if(cnt == 1) {
          Future<Uint8List> futureSalt =_generateSalt();
          futureSalt.then((salt) {
            Future<Uint8List> futurePepper =_generatePepper();
            futurePepper.then((pepper) {
              _updateSaltPepper(context, new SaltPepperItem(SaltPepper.salt,SaltPepper.pepper));
            });});
        }
      });
    });
  }
  void _showAlertDialog(String lockerName, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(lockerName),
      content: Text(message),
    );
    showDialog(context: context,builder: (_) => alertDialog);
  }

  void _insertSaltPepper(BuildContext context, SaltPepperItem saltPepperItem) async {
    int result = await databaseHelper.insertSaltPepperItem(saltPepperItem);
  }

  void _updateSaltPepper(BuildContext context, SaltPepperItem saltPepperItem) async {
    int result = await databaseHelper.updateSaltPepperItem(saltPepperItem);
  }

  Future<int> _getSaltPepperCount(BuildContext context) async {
    int result = await databaseHelper.getSaltPepperCount();
    return result;
  }

  void _deleteSaltPepper(BuildContext context, SaltPepperItem saltPepperItem) async {
    int result = await databaseHelper.deleteSaltPepperItem(saltPepperItem.id);
  }
}