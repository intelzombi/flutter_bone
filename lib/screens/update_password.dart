//@override
//Widget build(BuildContext context) {
//  TextStyle textStyle = Theme
//      .of(context)
//      .textTheme
//      .title;
//  return WillPopScope(
//    onWillPop: () {
//      moveToLastScreen();
//    },
//    child: Scaffold(
//        appBar: AppBar(
//          title: Text(appBarTitle),
//          leading: IconButton(icon: Icon(Icons.arrow_back),
//            onPressed: () {
//              moveToLastScreen();
//            },
//          ),
//        ),
//        body: Container(
//          child: Padding(
//            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
//            child: ListView(
//              children: <Widget>[
//                //First Element
//                Padding(
//                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//                  child: Text( _welcomeAcknowledged ? _initialWelcomeMessage : _welcomeMessage,
//
//                    style: textStyle,
//                    softWrap: true,
//                  ),
//                ),
//
//                //Second Element
//                Padding(
//                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//                  child: Text("Enter Password",
//                  ),
//                ),
//
//                //fourth Element
//                Padding(
//                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//                  child: Column(
//                    children: <Widget>[
//                      Expanded(
//                        child: TextFormField(
//                          controller: passwordController,
//                          style: textStyle,
//                          decoration: InputDecoration(
//                              labelText: "Password A-Z,a-z,0-9,special",
//                              labelStyle: textStyle,
//                              errorStyle: TextStyle(
//                                color: Colors.redAccent,
//                                fontSize: 15.0,
//                              ),
//                              border: OutlineInputBorder(
//                                  borderRadius: BorderRadius.circular(5.0)
//                              )
//                          ),
//                          validator: Validators.compose([
//                            Validators.required('Password is required'),
//                            Validators.patternString(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$', 'Invalid Password')
//                          ]),
//                        ),
//                      ),
//                      Container(width: 5.0),
//                      Expanded(
//                        child: RaisedButton(
//                          color: Theme
//                              .of(context)
//                              .primaryColorDark,
//                          textColor: Theme
//                              .of(context)
//                              .primaryColorLight,
//                          child: Text(
//                            'set or update password',
//                            textScaleFactor: 1.5,
//                          ),
//                          onPressed: () {
//                            setState(() {
//                              debugPrint("set password button clicked");
//                              _generateSaltPepper();
//                            });
//                          },
//                        ),
//                      ),
//                      Container(width: 5.0),
//                      Expanded(
//                        child: RaisedButton(
//                          color: Theme
//                              .of(context)
//                              .primaryColorDark,
//                          textColor: Theme
//                              .of(context)
//                              .primaryColorLight,
//                          child: Text(
//                            'Login',
//                            textScaleFactor: 1.5,
//                          ),
//                          onPressed: () {
//                            setState(() {
//                              debugPrint("Login button clicked");
//                              _testPassword();
//                            });
//                          },
//                        ),
//                      )
//                    ],
//                  ),
//                ),
//
//                //fifth Element
//                Padding(
//                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//                  child: Text(_decryptedMessage,
//                  ),
//                ),
//                //sixth Element
//                Padding(
//                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: RaisedButton(
//                          color: Theme
//                              .of(context)
//                              .primaryColorDark,
//                          textColor: Theme
//                              .of(context)
//                              .primaryColorLight,
//                          child: Text(
//                            'salt',
//                            textScaleFactor: 1.5,
//                          ),
//                          onPressed: () {
//                            setState(() {
//                              debugPrint("salt button clicked");
//                              _generateSalt();
//                            });
//                          },
//                        ),
//                      ),
//                      Container(width: 5.0),
//                      Expanded(
//                        child: RaisedButton(
//                          color: Theme
//                              .of(context)
//                              .primaryColorDark,
//                          textColor: Theme
//                              .of(context)
//                              .primaryColorLight,
//                          child: Text(
//                            'pepper',
//                            textScaleFactor: 1.5,
//                          ),
//                          onPressed: () {
//                            setState(() {
//                              debugPrint("pepper button clicked");
//                              _generatePepper();
//                            });
//                          },
//                        ),
//                      )
//                    ],
//                  ),
//                ),
//                //seventh Element
//                Padding(
//                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: RaisedButton(
//                          color: Theme
//                              .of(context)
//                              .primaryColorDark,
//                          textColor: Theme
//                              .of(context)
//                              .primaryColorLight,
//                          child: Text(
//                            'Encrypt',
//                            textScaleFactor: 1.5,
//                          ),
//                          onPressed: () {
//                            setState(() {
//                              debugPrint("encrypt button clicked");
//                              _encrypt();
//                            });
//                          },
//                        ),
//                      ),
//                      Container(width: 5.0),
//                      Expanded(
//                        child: RaisedButton(
//                          color: Theme
//                              .of(context)
//                              .primaryColorDark,
//                          textColor: Theme
//                              .of(context)
//                              .primaryColorLight,
//                          child: Text(
//                            'Decrypt',
//                            textScaleFactor: 1.5,
//                          ),
//                          onPressed: () {
//                            setState(() {
//                              debugPrint("Decrypt button clicked");
//                              _decrypt();
//                            });
//                          },
//                        ),
//                      )
//                    ],
//                  ),
//                )
//              ],
//            ),
//          ),
//        )),
//  );
//}