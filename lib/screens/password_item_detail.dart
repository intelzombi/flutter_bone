import 'package:flutter/material.dart';
import 'package:flutter_bone/models/wallet_item.dart';
import 'package:flutter_bone/utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class PasswordItemDetail extends StatefulWidget {
  final String appBarTitle;
  final WalletItem note;
  PasswordItemDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return PaswordItemDetailState(this.note, appBarTitle);
  }
}

class PaswordItemDetailState extends State<PasswordItemDetail> {
  static var _lockerTypes = ['Device', 'Site'];
  var _formKey = GlobalKey<FormState>();
  DatabaseHelper helper = DatabaseHelper();

  TextEditingController lockerNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String appBarTitle;
  WalletItem passwordItem;
  PaswordItemDetailState(this.passwordItem, this.appBarTitle);
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .title;

    lockerNameController.text = passwordItem.lockerName;
    userNameController.text = passwordItem.userName;
    passwordController.text = passwordItem.password;

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
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: DropdownButton(
                      items: _lockerTypes.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      style: textStyle,
                      value: updateLockerTypeAsString(passwordItem.lockerType),
                      onChanged: (valueSelectedByUser) {
                        setState(() {
                          debugPrint('User selected $valueSelectedByUser');
                          updateLockerTypeAsInt(valueSelectedByUser);
                        });
                      },
                    ),
                  ),

                  //Second Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextFormField(
                      validator: (String value) {
                        if(value.isEmpty){
                          return 'Please enter Locker Name for the wallet item';
                        }
                      },
                      controller: lockerNameController,
                      style: textStyle,
                      onChanged: (value) {
                        debugPrint('Something changed in the LockerName Text Field');
                        updateLockerName();
                      },
                      decoration: InputDecoration(
                          labelText: "Locker Name",
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

                  //Third Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextFormField(
                      validator: (String value) {
                        if(value.isEmpty){
                          return 'Please enter user name for the wallet item';
                        }
                      },
                      controller: userNameController,
                      style: textStyle,
                      onChanged: (value) {
                        debugPrint(
                            'Something changed in the User Name Text Field');
                        updateUserName();
                      },
                      decoration: InputDecoration(
                          labelText: "User Name",
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

                  //fourth Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextFormField(
                      validator: (String value) {
                        if(value.isEmpty){
                          return 'Please enter password for the wallet item';
                        }
                      },
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

                  //Fifth Element
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
                              'Save',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("Save button clicked");
                                if(_formKey.currentState.validate()) {
                                  _save();
                                }
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
                              'Delete',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("Delete button clicked");
                                _delete();
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

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateLockerTypeAsInt(String value) {
    switch (value) {
      case 'Device':
        passwordItem.lockerType = 1;
        break;
      case 'Site':
        passwordItem.lockerType = 2;
        break;
    }
  }

  String updateLockerTypeAsString(int value) {
    switch (value) {
      case 1:
        return _lockerTypes[0];
      case 2:
        return _lockerTypes[1];
    }
  }

  void updateLockerName() {
    passwordItem.lockerName = lockerNameController.text;
  }

  void updateUserName() {
    passwordItem.userName = userNameController.text;
  }

  void updatePassword() {
    passwordItem.password = passwordController.text;
  }

  void _save() async {
    moveToLastScreen();
    int result;
    if (passwordItem.id != null) {
      result = await helper.updateWalletItem(passwordItem);
    } else {
      result = await helper.insertWalletItem(passwordItem);
    }

    if (result != 0) { //success
      _showAlertDialog('Status', 'Wallet Item Saved Successfully');
    } else { //fail
      _showAlertDialog('Status', 'Problem Saving Wallet Item');
    }
  }

  void _delete() async {
    moveToLastScreen();
    if(passwordItem.id == null) {
      _showAlertDialog('Status', 'No Wallet Item was deleted');
      return;
    }
    int result = await helper.deleteWalletItem(passwordItem.id);
    if(result!=0) {
      _showAlertDialog('Status', 'Wallet Item Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Wallet Item');
    }
  }
  void _showAlertDialog(String lockerName, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(lockerName),
      content: Text(message),
    );
    showDialog(context: context,builder: (_) => alertDialog);
  }
}
