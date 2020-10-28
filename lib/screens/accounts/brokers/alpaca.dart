import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";

import 'package:WMR/shared/constants.dart';
//import 'package:WMR/shared/loading.dart';
import 'package:WMR/services/apis.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

// SS _storage = SS();
// final storage = FlutterSecureStorage();

class AlpacaForm extends StatefulWidget {
  @override
  _AlpacaFormState createState() => _AlpacaFormState();
}

class _AlpacaFormState extends State<AlpacaForm> {
  final _formKey = GlobalKey<FormState>();
  String _accountName;
  //Map<String, dynamic> _items = {};
  String _endpoint;
  String _apiKeyId;
  String _secretKey;
  String _error;
  int numAccounts;
  FocusNode epFocusNode;
  FocusNode apiFocusNode;
  FocusNode secFocusNode;
  String user;
  String demoText='';

  final _st = FlutterSecureStorage();

  //Future<String> loadSettingsFuture;

  @override
  void initState() {
    //loadSettingsFuture = _readAll();
    epFocusNode = FocusNode();
    apiFocusNode = FocusNode();
    secFocusNode = FocusNode();

    epFocusNode.addListener(() {
      if (epFocusNode.hasFocus) _error = null;
    });
    apiFocusNode.addListener(() {
      if (apiFocusNode.hasFocus) _error = null;
    });
    secFocusNode.addListener(() {
      if (secFocusNode.hasFocus) _error = null;
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
    epFocusNode.dispose();
    apiFocusNode.dispose();
    secFocusNode.dispose();
    super.dispose();
  }

  Widget _showError() {
    if (_error != null)
      return Padding(
        padding: const EdgeInsets.all(12.0),
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

  Widget showAddButton() {
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

          if (_formKey.currentState.validate()) {
            await addAlpacaAccount(
                    _accountName, _endpoint, _apiKeyId, _secretKey)
                .then((result) {
              // print(
              //     "Result: $result");
              if (result == 'Success') {
                //updateItems();
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
                            Navigator.pushNamed(context, '/home');
                          })
                    ]).show();
              } else {
                setState(() => (_error = result));
                //print(result);
              }
            });
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
                setState(() => (demoText = "This is a demo account. New accounts cannot be added."));
          
            });
          }
  }
      
  

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
                'Add an Alpaca account',
                style: white14Bold(),
              ),

              //centerTitle: true,

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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Steps: ",
                              style: titleStyle(),
                            ),
                            RichText(
                              text: new TextSpan(
                                children: [
                                  new TextSpan(
                                    text: '1: Goto your account at ',
                                    //style: new TextStyle(color: Colors.black),
                                  ),
                                  new TextSpan(
                                    text: 'alpaca.markets',
                                    style: new TextStyle(color: Colors.blue),
                                    recognizer: new TapGestureRecognizer()
                                      ..onTap = () {
                                        launch('https://alpaca.markets/');
                                      },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: h1),
                            Text(
                                "2: On the right panel click on 'View your API keys'"),
                            SizedBox(height: h1),
                            Text("3: Click on 'Regenearte Key'"),
                            SizedBox(height: h1),
                            Text(
                                "4: Copy/paste the generated keys to the corresponding fields in the form below"),
                            SizedBox(height: h2),
                            Text(
                                "** The 'Account name' in below form is an arbitrary name you choose **"),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //SizedBox(height: 10.0),

                            Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                    width: w80,
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Alpaca Account Credentials: ",
                                            style: titleStyle(),
                                          ),
                                          _showError(),
                                          SizedBox(height: h2),
                                          TextFormField(
                                            //initialValue: '',
                                            //decoration: textInputDecoration.copyWith(labelText: "Account Name"),
                                            autocorrect: false,
                                            enableSuggestions: false,
                                            decoration: InputDecoration(
                                              hintText: "Account Name",
                                            ),
                                            validator: (val) => val.isEmpty
                                                ? 'Account Name (Any unique name)'
                                                : null,
                                            onChanged: (val) => setState(
                                                () => _accountName = val),
                                          ),
                                          SizedBox(height: h2),
                                          TextFormField(
                                            //initialValue: '',
                                            focusNode: epFocusNode,
                                            autocorrect: false,
                                            enableSuggestions: false,
                                            //decoration: textInputDecoration.copyWith(labelText: "Endpoint"),
                                            decoration: InputDecoration(
                                              hintText: "Endpoint",
                                            ),
                                            validator: (val) =>
                                                val.isEmpty ? 'Endpoint' : null,
                                            onChanged: (val) =>
                                                setState(() => _endpoint = val),
                                          ),
                                          SizedBox(height: h2),
                                          TextFormField(
                                            initialValue: '',
                                            autocorrect: false,
                                            enableSuggestions: false,
                                            focusNode: apiFocusNode,
                                            //decoration: textInputDecoration.copyWith(labelText: "API Key ID"),
                                            decoration: InputDecoration(
                                              hintText: "API Key ID",
                                            ),
                                            validator: (val) => val.isEmpty
                                                ? 'API Key ID'
                                                : null,
                                            onChanged: (val) =>
                                                setState(() => _apiKeyId = val),
                                          ),
                                          SizedBox(height: h2),
                                          TextFormField(
                                            initialValue: '',
                                            focusNode: secFocusNode,
                                            autocorrect: false,
                                            enableSuggestions: false,
                                            //decoration: textInputDecoration.copyWith(labelText: "Secret Key"),
                                            decoration: InputDecoration(
                                              hintText: "Secret Key",
                                            ),
                                            validator: (val) => val.isEmpty
                                                ? 'Secret Key'
                                                : null,
                                            onChanged: (val) => setState(
                                                () => _secretKey = val),
                                          ),
                                          SizedBox(height: h2),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10.0, 0, 0, 0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                RaisedButton(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      //side: BorderSide(color: Colors.red)
                                                    ),
                                                    color: Colors.grey[600],
                                                    child: Text(
                                                      'Cancel',
                                                      style: white_14(),
                                                    ),
                                                    onPressed: () async {
                                                      //print("Cancel");
                                                      //print("Result: $result");

                                                      Navigator.pop(context);
                                                    }),
                                                SizedBox(
                                                  width: w10,
                                                ),
                                                showAddButton(),
                                              ],
                                            ),
                                          ),
                                          
                                        ],
                                      ),
                                    ))),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(demoText,
                                      style:infoStyle()),
                                    )
                          ],
                        ),
                      ),
                    ),
                  ]),
            )));
  }
}
