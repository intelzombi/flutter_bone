
import 'package:flutter/material.dart';

class Matcher {

  static bool  patternMatch(String value, RegExp pattern) {
    if(value==null) {
      return false;
    }
    if(pattern.hasMatch(value)) {
      return true;
    } else {
      return false;
    }
  }

  Matcher();
}

class Notifier {
  BuildContext context;
  Notifier(this.context);
  void showAlertDialog(String lockerName, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(lockerName),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}