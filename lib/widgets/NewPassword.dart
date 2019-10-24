import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bone/utils/utils.dart';

class NewPassword extends StatefulWidget {

  Function successfulAction;

  @override
  NewPasswordState createState() {
    return NewPasswordState(successfulAction);
  }

  NewPassword(this.successfulAction);
}

class NewPasswordState extends State<NewPassword> {
  var _formKey = GlobalKey<FormState>();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Function successfulAction;

  NewPasswordState(this.successfulAction);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .title;
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
        child: Padding(
          padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Text(
                  "Enter New Password",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: TextFormField(
                  controller: passwordController,
                  style: textStyle,
                  decoration: InputDecoration(
                      labelText: "",
                      labelStyle: textStyle,
                      errorStyle: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 15.0,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  validator: (String value) {
                    RegExp pattern = new RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$%^&*~]).{8,}$');
                    if (!Matcher.patternMatch(value, pattern)) {
                      return 'Please enter a strong password';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Text(
                  "Confirm New Password",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: TextFormField(
                        controller: passwordConfirmController,
                        style: textStyle,
                        decoration: InputDecoration(
                            labelText: "",
                            labelStyle: textStyle,
                            errorStyle: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 15.0,
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(5.0))),
                      ),
                    ),
                    Container(width: 5.0),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: RaisedButton(
                        color: Theme
                            .of(context)
                            .primaryColorDark,
                        textColor: Theme
                            .of(context)
                            .primaryColorLight,
                        child: Text(
                          'Create Password',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            if (_comparePasswords()) {
                              successfulAction(passwordController.text);
                              Notifier(context).showAlertDialog(
                                  "Password", "Good Password");
                            } else {
                              Notifier(context).showAlertDialog(
                                  "Password", "Passwords don't match");
                            }
                          } else {
                            Notifier(context).showAlertDialog(
                                "Password", "Password needs to be stronger");
                          }
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _comparePasswords() {
    if (passwordController.text == passwordConfirmController.text) {
      return true;
    } else {
      return false;
    }
  }
}