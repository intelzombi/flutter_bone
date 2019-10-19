import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

class EncryptDecryptPoc extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EncryptDecryptPocState();
  }
}

class EncryptDecryptPocState extends State<EncryptDecryptPoc> {

  String appBarTitle = "Hide Me if you can";
  TextEditingController clearMessageController = TextEditingController();
  TextEditingController encryptedMessageController = TextEditingController();
  TextEditingController decryptedMessageController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // local state variables
  String clearMessage = "new message";
  String encryptedMessage = "encryptedMessage";
  String decryptedMessage = "decryptedMessage";
  String password = "aPassword";

  static const platform = const MethodChannel('iceberg.gunsnhoney.flutter_bone/cypher');
  Uint8List clearMessageByteForm;
  Uint8List encryptedMessageByteForm;
  Uint8List salt;
  Uint8List pepper;

  Future<Uint8List> _generateSalt() async {
    Uint8List resultEncryptedMessage;

    try {
      final Uint8List result = await platform.invokeMethod('generateSalt');
      salt = result;
      return result;
    } on PlatformException catch (e) {
      setState(() {

      });
    }
  }

  Future<Uint8List> _generatePepper() async {
    Uint8List resultEncryptedMessage;

    try {
      final Uint8List result = await platform.invokeMethod('generateIV');
      pepper = result;
      return result;
    } on PlatformException catch (e) {
      setState(() {

      });
    }
  }

  Future<Uint8List> _encryptMsg(String clearMessage, String password, salt, pepper) async {
    Uint8List resultEncryptedMessage;

    try {
      final Uint8List result = await platform.invokeMethod('encryptMsg', <String, dynamic> {
        'password': password,
        'clearMessage': clearMessage,
        'salt': salt,
        'pepper': pepper,
      });
      resultEncryptedMessage = result;
      encryptedMessageByteForm = result;
      updateEncryptedMessage(resultEncryptedMessage);
      return result;
    } on PlatformException catch (e) {

    }
    setState(() {
      encryptedMessageByteForm = resultEncryptedMessage;
    });
  }


  Future<String> _decryptMsg(Uint8List encryptedMessage, String password, Uint8List salt,  Uint8List pepper) async {
    String resultDecryptedMessage;
    try {
      final String result = await platform.invokeMethod('decryptMsg', <String, dynamic> {
        'password': password,
        'encryptedMessage': encryptedMessage,
        'salt': salt,
        'pepper': pepper,
      });
      resultDecryptedMessage = result;
      updateDecryptedMessage(resultDecryptedMessage);
      return result;
    } on PlatformException catch (e) {
      //iv='we didn\'t see the cat';
    }

    setState(() {
      decryptedMessage = resultDecryptedMessage;
    });
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
                    child: Text(encryptedMessage,
                          ),
                    ),

                  //fourth Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
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

                  //fifth Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Text(decryptedMessage,
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
    clearMessage = clearMessageController.text;
  }
  void updateEncryptedMessage(Uint8List encryptedMsg) {
    encryptedMessage = encryptedMsg.toString();
  }
  void updateDecryptedMessage(String decryptedMsg) {
    decryptedMessage = decryptedMsg;
  }
  void updatePassword() {
    password = passwordController.text;
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void _encrypt() async {

    Uint8List resultEncryptedMsg = await _encryptMsg(clearMessage, password, salt, pepper);

    int result = 1;

//    if (result != 0) { //success
//      _showAlertDialog('Status', 'Wallet Item Saved Successfully');
//    } else { //fail
//      _showAlertDialog('Status', 'Problem Saving Wallet Item');
//    }
  }

  void _decrypt() async {
    String resultDecrypt = await _decryptMsg(encryptedMessageByteForm, password, salt, pepper);

    int result =1 ;
//    if(result!=0) {
//      _showAlertDialog('Status', 'Wallet Item Deleted Successfully');
//    } else {
//      _showAlertDialog('Status', 'Error Occured while Deleting Wallet Item');
//    }
  }

  void _showAlertDialog(String lockerName, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(lockerName),
      content: Text(message),
    );
    showDialog(context: context,builder: (_) => alertDialog);
  }
}