//import 'dart:async';

import "package:flutter/material.dart";
import 'package:WMR/shared/constants.dart';
//import 'package:WMR/shared/loading.dart';
import 'package:WMR/services/apis.dart';
import 'package:WMR/shared/loading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// SS _storage = SS();
// final storage = FlutterSecureStorage();

//import 'package:WMR/shared/globals.dart' as globals;

class RobinhoodForm extends StatefulWidget {
  @override
  _RobinhoodFormState createState() => _RobinhoodFormState();
}

class _RobinhoodFormState extends State<RobinhoodForm> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  FocusNode loginFocusNode;
  FocusNode pwFocusNode;
  bool smsCode = false;
  String _accountName;
  String _username;
  String _password;
  bool _bySMS = true;
  int resend = 0;
  String _error;
  bool accountExists = false;
  bool loading = false;

  String _smsCode;
  //String token;
  int numAccounts;
  String user;
  String demoText = '';

  final _st = FlutterSecureStorage();
  //Future<String> loadSettingsFuture;

  @override
  void initState() {
    //loadSettingsFuture = _readAll();
    loginFocusNode = FocusNode();
    pwFocusNode = FocusNode();

    loginFocusNode.addListener(() {
      if (loginFocusNode.hasFocus) _error = null;
    });
    pwFocusNode.addListener(() {
      if (pwFocusNode.hasFocus) _error = null;
    });
    _readAll();

    super.initState();
  }

  Future<Null> _readAll() async {
    await _st.read(key: 'user').then((e) {
      setState(() {
        if (e != null) {
          user = e.toString();
        }
      });
      //loading = false;
    });
  }

  void dispose() {
    // Clean up the focus node when the Form is disposed.
    loginFocusNode.dispose();
    pwFocusNode.dispose();
    super.dispose();
  }

  //we omitted the brackets '{}' and are using fat arrow '=>' instead, this is dart syntax
  void _bySMSChanged(bool value) => setState(() => _bySMS = value);

  Widget showAddButton() {
    print("User: $user");
    if (user == null) {
      return RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            //side: BorderSide(color: Colors.red)
          ),
          color: Colors.grey[600],
          child: Text(
            'Add Account',
            style: white_14(),
          ),
          onPressed: () async {
            FocusScope.of(context).requestFocus(new FocusNode());
            //if (_formKey1.currentState.validate()) {
            if (validate(_formKey1)) {
              await addRobinhoodAccount(
                      _accountName, _username, _password, _bySMS)
                  .then((result) {
                print("Result: $result");
                if (result == 'SMS') {
                  setState(() {
                    smsCode = true;
                    _error = null;
                  });
                } else {
                  setState(() => (_error = result));
                  //print(result);
                }
              });
              //Navigator.pop(context);
            }
          });
    } else {
      return RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            //side: BorderSide(color: Colors.red)
          ),
          color: Colors.grey[600],
          child: Text(
            'Add Account',
            style: white_14(),
          ),
          onPressed: () async {
            FocusScope.of(context).requestFocus(new FocusNode());
            setState(() => (demoText =
                "This is a demo account. New accounts cannot be added."));
          });
    }
  }

  Widget _showError() {
    if (_error != null)
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          alignment: Alignment.center,
          child: (Text(
            _error,
            style: errorStyle(),
          )),
        ),
      );
    return SizedBox(height: 0);
  }

  Widget _showCredentialForm() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Steps: ",
            style: titleStyle(),
          ),
          SizedBox(height: h1),
          Text(
            "1: Fill out below form. The 'Account name' is any arbitrary name you choose. If you have enabled 2FA in your Robinhood account, make sure to keep the 2FA checkbox, checked, ",
            style: white_12(),
          ),
          SizedBox(height: h1),
          Text(
              "2: Depending on your Robinhood account 2FA settings, after the login/password is sent to Robinhood, you will recieve a code by SMS or email."),
          SizedBox(height: h1),
          Text(
            "3: You need to enter that code in next screen for us to be able to add your account.",
            style: white_12(),
          ),
          showForm(),
        ]);
  }

  Widget showForm() {
    if (smsCode == true) return _showSmsCodeForm();
    return SingleChildScrollView(
      child: (Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              //width: w80,
              child: Form(
                key: _formKey1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: h2),
                    Text(
                      "Robinhood Account Credentials: ",
                      style: titleStyle(),
                    ),

                    SizedBox(height: h1),
                    _showError(),
                    TextFormField(
                      //initialValue: _accountName == null ? '': _accountName,
                      initialValue: '',
                      autocorrect: false,
                      enableSuggestions: false,
                      //decoration: textInputDecoration.copyWith(labelText: "Account Name"),
                      decoration: InputDecoration(
                        hintText: "Account Name",
                      ),
                      validator: (val) =>
                          val.isEmpty ? 'Account Name (Any unique name)' : null,
                      onSaved: (val) => _accountName = val,
                    ),
                    SizedBox(height: h1),
                    TextFormField(
                      //initialValue: '',
                      //decoration: textInputDecoration.copyWith(labelText: "Robinhood username"),
                      autocorrect: false,
                      enableSuggestions: false,
                      focusNode: loginFocusNode,
                      decoration: InputDecoration(
                        hintText: "Robinhood username",
                      ),
                      validator: (val) =>
                          val.isEmpty ? 'Robinhood username' : null,
                      onSaved: (val) => _username = val,
                    ),
                    SizedBox(height: h1),
                    TextFormField(
                      obscureText: true,
                      //initialValue: '',
                      //decoration: textInputDecoration.copyWith(labelText: "Robinhood password"),
                      autocorrect: false,
                      enableSuggestions: false,
                      focusNode: pwFocusNode,
                      decoration: InputDecoration(
                        hintText: "Robinhood password",
                      ),
                      validator: (val) =>
                          val.isEmpty ? 'Robinhood password' : null,

                      onSaved: (val) => _password = val,
                    ),
                    SizedBox(height: h1),
                    //Checkbox(value: _bySMS, onChanged: _bySMSChanged(value)),
                    CheckboxListTile(
                      value: _bySMS,
                      onChanged: _bySMSChanged,
                      title: new Text('Robinhood 2FA Method'),
                      //controlAffinity: ListTileControlAffinity.leading,
                      //subtitle: new Text('Check if Robinhood Sends you code by SMS'),
                      //secondary: new Icon(Icons.archive),
                      activeColor: Colors.red,
                    ),
                    SizedBox(height: h2),

                    Container(
                      //alignment: Alignment.centerLeft,
                      //color:Colors.red,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                //side: BorderSide(color: Colors.red)
                              ),
                              color: Colors.grey[600],
                              child: Text(
                                'Cancel',
                                style: white_14(),
                              ),
                              onPressed: () async {
                                Navigator.pop(context);
                                //Navigator.pushNamed(context, '/home');

                                //Navigator.pop(context);
                              }),
                          SizedBox(
                            width: w30,
                          ),
                          showAddButton(),
                        ],
                      ),
                    ),
                    //SizedBox(height:20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(demoText, style: infoStyle()),
                    )
                  ],
                ),
              ),
            )
          ])),
    );
  }

  // Widget _showResend() {
  //   return Container(
  //     child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Container(
  //             width: double.infinity,
  //             child: Form(
  //                 key: _formKey2,
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: <Widget>[
  //                     SizedBox(height: 20.0),
  //                     Wrap(
  //                       children: <Widget>[
  //                         Text(
  //                           "The code was wrong again. Please start over!",
  //                           style: white_12().copyWith(
  //                               color: Colors.deepOrangeAccent,
  //                               fontWeight: FontWeight.bold),
  //                         ),
  //                         SizedBox(width: 20.0),
  //                         RaisedButton(
  //                           color: Colors.grey[800],
  //                           child: Text(
  //                             'Ok',
  //                             style: white_14(),
  //                           ),
  //                           onPressed: () async {
  //                             Navigator.pushNamed(context, '/robinhood');
  //                           },
  //                         )
  //                       ],
  //                     )
  //                   ],
  //                 )))),
  //   );
  // }

  Widget _showSmsCodeForm() {
    // if (resend == 2)
    //   return(_showResend());

    return loading
        ? Loading()
        : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                width: double.infinity,
                child: Form(
                  key: _formKey2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: h2),
                      Text(
                        "Please enter the SMS code you just received from Robinhood.",
                        style: white_14().copyWith(
                            color: Colors.blue[300],
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: h1),
                      _showError(),
                      TextFormField(
                        //initialValue: '',
                        decoration: InputDecoration(
                          hintText: "SMS Code",
                        ),

                        validator: (val) => val.isEmpty
                            ? 'SMS Code return fromRobinhood'
                            : null,
                        onSaved: (val) => _smsCode = val,
                      ),
                      SizedBox(height: h1),
                      RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            //side: BorderSide(color: Colors.red)
                          ),
                          color: Colors.grey[600],
                          child: Text(
                            'Add Account',
                            style: white_14(),
                          ),
                          onPressed: () async {
                            if (validate(_formKey2)) {
                              //loading=true;
                              await sendCodeToRobinhood(_smsCode, resend)
                                  .then((result) {
                                //print("Result: $result");
                                //loading=true;
                                if (result.toUpperCase() == 'WRONG CODE') {
                                  Alert(
                                      context: context,
                                      //type:AlertType.error,
                                      style: AlertStyle(
                                          backgroundColor: Colors.grey[700],
                                          titleStyle: white_14().copyWith(
                                              color: Colors.amberAccent),
                                          descStyle: white_12().copyWith(
                                              color: Colors.amberAccent)),
                                      //title:'',
                                      title: "The code you entered was wrong!",
                                      desc: "Please try again.",
                                      buttons: [
                                        DialogButton(
                                            child: Text("Ok"),
                                            color: Colors.blueAccent,
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/robinhood');
                                            })
                                      ]).show();
                                } else {
                                  //updateItems();
                                  //loading = false;
                                  //Timer(Duration(milliseconds: 500), (){
                                  Alert(
                                      context: context,
                                      //type:AlertType.success,
                                      style: AlertStyle(
                                          backgroundColor: Colors.grey[700],
                                          titleStyle: white_14()),
                                      //title:'',
                                      title: "Account is added successfully!",
                                      buttons: [
                                        DialogButton(
                                            child: Text("Ok"),
                                            color: Colors.blueAccent,
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/home');
                                            })
                                      ]).show();

                                  //Navigator.pop(context);

                                }
                              });
                            }
                          }),
                    ],
                  ),
                )));
  }

  // Future updateItems() async {
  //   if (numAccounts == 0) {
  //     await getAccounts().then((accounts) {
  //       _storage.write('numLinkedAccounts', accounts.length);
  //       _storage.write('tIndex', 1);
  //       _storage.write('account', accounts[0]);
  //       _storage.write('accountIndex', 0);
  //       _storage.write('defaultAccount', accounts[0]);
  //     });
  //   } else {
  //     await _storage.write('numLinkedAccounts', numAccounts + 1);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Add a Robinhood account',
                style: white14Bold(),
              ),
              automaticallyImplyLeading: true,
              // leading: IconButton(
              //   icon: Icon(Icons.arrow_back, color: Colors.white),
              //   onPressed: () =>
              //       Navigator.popUntil(context, ModalRoute.withName('/home')),
              // ),
              //backgroundColor: Colors.black,
              elevation: 0.0,
            ),
            body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _showCredentialForm(),
                              // _showSmsCodeForm(),
                              //showForm(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
            )));
  }
}
