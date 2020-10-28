import "package:flutter/material.dart";
import 'package:WMR/shared/constants.dart';
//import 'package:WMR/shared/loading.dart';
import 'package:WMR/services/apis.dart';
//import 'package:WMR/shared/constants.dart';
import 'package:WMR/shared/storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';

SS _storage = SS();
//final storage = FlutterSecureStorage();
//import 'package:super_rich_text/super_rich_text.dart';

//import 'package:url_launcher/url_launcher.dart';
//import 'package:WMR/shared/globals.dart' as globals;

class AddPortfolio extends StatefulWidget {
  final List wlNames;
  AddPortfolio({Key key, @required this.wlNames}) : super(key: key);
  @override
  _AddPortfolioState createState() => _AddPortfolioState();
}

class _AddPortfolioState extends State<AddPortfolio> {
  final _formKey = GlobalKey<FormState>();
  //List wlNames = [];
  String error = '';
  String _wlName = '';
  List wlNames;
  bool loading = false;
  //bool _addWl = false;
  String token;
  dynamic numAccounts;

  String user;
  String demoText = '';
  final _st = FlutterSecureStorage();
  // FocusNode epFocusNode;
  // FocusNode apiFocusNode;
  // FocusNode secFocusNode;

  //List wlNames = await _storage.read("accountNames");

  String validateWL(String value) {
    if (value.isEmpty)
      return 'Name must be more than 2 charater';
    else if (widget.wlNames.contains(value.toUpperCase()))
      return 'Name alraedy exists';
    else if (value.length > 15) return 'Name too long. Choose <= 15';
    return null;
  }

  @override
  void initState() {
    wlNames = widget.wlNames;
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

    super.dispose();
  }

  // _launchURL() async {
  //   const url = 'https://www.alpaca.markets/';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // Widget _showError() {
  //   if (_error != null)
  //     return Padding(
  //       padding: const EdgeInsets.all(12.0),
  //       child: Container(
  //         alignment: Alignment.center,
  //         child: (Text(
  //           _error,
  //           style: errorStyle(),
  //         )),
  //       ),
  //     );
  //   return SizedBox(height: 0);
  // }

  Future updateItems() async {
    await _storage.write('numAccounts', wlNames.length);
    // if (wlNames.length == 1) {
    //   await getWatchlists().then((accounts) {
    //       _storage.write('watchlistIndex', 0);
    //       _storage.write('numManualPortfolios', accounts.length);
    //       _storage.write('watchlist', accounts[0]);
    //       _storage.write('defaultWatchlist', accounts[0]);
    //   });
    // }
  }

  Future readToken() async {
    token = await _storage.read('token');
  }

  Widget showAddButton() {
    if (user == null) {
      return RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            //side: BorderSide(color: Colors.red)
          ),
          color: Colors.grey[600],
          child: Text(
            'Add',
            style: white_14(),
          ),
          onPressed: () async {
            //if (_formKey.currentState.validate()) {
            if (validate(_formKey)) {
              await addWatchlist(_wlName);
              setState(() => wlNames.add(_wlName));
              updateItems();
              await Navigator.pushNamed(context, '/home');
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
            'Add',
            style: white_14(),
          ),
          onPressed: () async {
            setState(() => (demoText =
                "This is a demo account. New portfolios cannot be added."));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    wlNames = widget.wlNames;
    //readToken();
    //print("WL Names: $wlNames");
    // dynamic wp = Provider.of<WmrProviders>(context);
    // String token = wp.getToken;
    // numAccounts = wp.numLinkedAccounts;
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
                'Add a manual portfolio',
                style: white14Bold(),
              ),

              //centerTitle: true,

              automaticallyImplyLeading: true,
              // leading: IconButton(
              //     icon: Icon(Icons.arrow_back, color: Colors.white),
              //     onPressed: () =>
              //         Navigator.popUntil(context, ModalRoute.withName('/home')),
              //   ),

              //backgroundColor: Colors.black,
              elevation: 0.0,
            ),
            body: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Steps: ",
                              style: titleStyle(),
                            ),

                            SizedBox(height: h1),
                            Text(
                                "1: Add any arbitrary name in below text field and click 'Add'."),
                            SizedBox(height: h1),
                            Text(
                                "2: After clicking 'Add' you will be redirected to the 'Manual Portfoios' page."),
                            SizedBox(height: h1),
                            Text(
                                "3: Click on settings and enable the account."),
                            //SizedBox(height: h1),
                            SizedBox(height: h1),
                            Text(
                                "4: Click on the rules icon and go to the 'Rules' page."),
                            SizedBox(height: h1),
                            Text(
                                "5: Review rules one by one and enable/edit the ones you want"),

                            SizedBox(height: h4),
                            Row(children: [
                              Container(
                                width: w50,
                                child: TextFormField(
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  initialValue: '',

                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Portfolio name",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[500]),

                                    // prefixIcon: const Icon(
                                    //   Icons.account_balance_wallet,
                                    //   color: Colors.lightGreen,
                                    // ),
                                  ),
                                  validator: validateWL,
                                  onSaved: (val) => _wlName = val,
                                  //   onChanged: (val) =>
                                  //       setState(() => _wlName = val),
                                ),
                              ),

                              // Row(children: [
                              //     //             Padding(
                              //   RaisedButton(
                              //                           shape: RoundedRectangleBorder(
                              //                             borderRadius:
                              //                                 BorderRadius.circular(
                              //                                     10.0),
                              //                             //side: BorderSide(color: Colors.red)
                              //                           ),
                              //                           color: Colors.grey[600],
                              //                           child: Text(
                              //                             'Cancel',
                              //                             style: white_14(),
                              //                           ),
                              //                           onPressed: () async {
                              //                             //print("Cancel");
                              //                             //print("Result: $result");

                              //                             Navigator.pop(context);
                              //                           }),
                              //                       SizedBox(width: w3,),

                              SizedBox(width: w5),
                              showAddButton(),
                            ]),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(demoText, style: infoStyle()),
                            )
                          ]),
                    )))));

    //   Form(
    //     key: _formKey,
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Row(
    //           //mainAxisAlignment: MainAxisAlignment.end,
    //           children: <Widget>[
    //             Expanded(
    //               child: new TextFormField(
    //                 initialValue: '',
    //                 style: TextStyle(fontSize: 20, color: Colors.white),
    //                 //decoration: textInputDecoration.copyWith(labelText: "Name"),
    //                 decoration: InputDecoration(
    //                   hintText: "Portfolio name",
    //                   hintStyle: TextStyle(color: Colors.grey[500]),

    //                   prefixIcon: const Icon(
    //                     Icons.account_balance_wallet,
    //                     color: Colors.lightGreen,
    //                   ),
    //                 ),
    //                 validator: validateWL,
    //                 onChanged: (val) => setState(() => _wlName = val),
    //               ),
    //             ),
    //             SizedBox(height: 0),
    //             Padding(
    //               padding: const EdgeInsets.only(left: 8.0),
    //               child: RaisedButton(
    //                   shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(10.0),
    //                     //side: BorderSide(color: Colors.red)
    //                   ),
    //                   color: Colors.grey[600],
    //                   child: Text(
    //                     'Add',
    //                     style: white_14().copyWith(fontWeight: FontWeight.bold),
    //                   ),
    //                   onPressed: () async {
    //                     if (_formKey.currentState.validate()) {
    //                       //print("WL Names: $wlNames");
    //                       addWatchlist(token, _wlName).then((val) {
    //                         if (val != null) {
    //                           Future.delayed(Duration(milliseconds: 500), () {
    //                             //incrementNumPortfolios(context);
    //                             //print("Adding to num wl");
    //                             Provider.of<WmrProviders>(context,
    //                                     listen: false)
    //                                 .saveNumManualPortfolios(numPortfolios + 1);
    //                             //setState(() => numPortfolios += 1);
    //                             //print("Num P: ${wp.numPortfolios}");
    //                             // if (numLinkedAccounts  == 0) {
    //                             //     Provider.of<WmrProviders>(context, listen: false).saveIndex(0);
    //                             //      }
    //                             //  Future.delayed(Duration(milliseconds: 500), () {
    //                             Navigator.pushNamed(context, '/home');
    //                             //});
    //                           });
    //                         }
    //                         // } else {
    //                         //   Loading();
    //                         // }
    //                         //Navigator.popUntil(context, ModalRoute.withName('/home'));
    //                       });
    //                       //Navigator.pop(context);
    //                       //Navigator.popUntil(context, ModalRoute.withName('/home'));

    //                       // Navigator.push(
    //                       //   context,
    //                       //   MaterialPageRoute(builder: (context) => Home()),
    //                       // );
    //                     }
    //                   }),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.only(left: 8.0),
    //               child: IconButton(
    //                 icon: Icon(Icons.cancel),
    //                 tooltip: 'cancel',
    //                 color: Colors.cyanAccent,
    //                 onPressed: (() {
    //                   print("Pressed");
    //                   });
    //                 },
    //               ),
    //           ]
    //             )
    //     )))
    //           ]),
    //     ),
  }
}
