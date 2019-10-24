import 'dart:typed_data';

import 'package:flutter/services.dart';

class CypherChannel {
  static const platform = const MethodChannel('iceberg.gunsnhoney.flutter_bone/cypher');

  //Uint8List _salt;
  static Future<Uint8List> generateSalt(Function setState) async {
    Uint8List salt;
    try {
      final Uint8List result = await platform.invokeMethod('generateSalt');
      salt = result;
    } on PlatformException catch (e) {
      int a = 4;
    }
    setState(salt);
    //Hint
//    setState(() {
//      SaltPepper.salt = salt;
//    });
    return salt;
  }

  //Uint8List _pepper;
  static Future<Uint8List> generatePepper(Function setState) async {
    Uint8List pepper;
    try {
      final Uint8List result = await platform.invokeMethod('generateIV');
      pepper = result;
    } on PlatformException catch (e) {
      int a = 4;
    }
    setState(pepper);
    //Hint
//    setState(() {
//      SaltPepper.pepper = pepper;
//    });
    return pepper;
  }

  Uint8List _encryptedMessageByteForm;
  static Future<Uint8List> encryptMsg(Function setState, String clearMessage, String password, salt, pepper) async {
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
    setState(encryptedMessageByteForm);
    //Hint
//    setState(() {
//      _encryptedMessageByteForm = encryptedMessageByteForm;
//      _encryptedMessage = encryptedMessageByteForm.toString();
//    });
    return encryptedMessageByteForm;
  }

  String _decryptedMessage = "decryptedMessage";
 static Future<String> decryptMsg(Function setState, Uint8List encryptedMessage, String password, Uint8List salt,  Uint8List pepper) async {
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

    setState(decryptedMessage);
    //Hint
//    setState(() {
//      _decryptedMessage = decryptedMessage;
//    });
    return decryptedMessage;
  }
}