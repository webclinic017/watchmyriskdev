import 'package:flutter/material.dart';
// import 'package:WMR/screens/accounts/brokers/alpaca.dart';
import 'package:WMR/services/apis.dart';
import 'package:WMR/shared/loading.dart';
// import 'package:provider/provider.dart';
// import 'package:WMR/screens/providers/providers.dart';
//import 'package:WMR/screens/home/home.dart';
import 'package:WMR/shared/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:WMR/shared/storage.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//SS _storage = SS();
//final storage = FlutterSecureStorage();

//import 'package:WMR/shared/globals.dart' as globals;

class EditAccount extends StatefulWidget {
  final Map account;
  EditAccount({Key key, this.account}) : super(key: key);

  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  final _formKey = GlobalKey<FormState>();
  //Map<String, dynamic> _items = {};
  bool loading = false;
  bool _showBody = true;
  Map account;
  String accountName;
  //String token;

  //bool confirm = true;
  Map<String, dynamic> editAcc;
  Map defaultAccount;
  int numAccounts;
  int numPortfolios;
  String user;
  String demoText = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _st = FlutterSecureStorage();
  // Future<String> loadSettingsFuture;
  // Future<Null> _readAll() async {
  //   await storage.readAll().then((all) {
  //     //print("All: $all");
  //     all.forEach((k, v) {
  //       setState(() {
  //         _items[k] = v;
  //         //k = v;
  //       });
  //     });
  //   });
  // }

  @override
  void initState() {
    loading = true;
    //loadSettingsFuture = _readAll();
    accountName = widget.account['account_name'];
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
      loading = false;
    });
  }




  bool _alert = false;

  Widget showAlert(account) {
    print("User: $user");
    if (_alert == true) {
      if (user == null) {
      return Container(
        color: Colors.black26,
        width: double.infinity,
        //padding: EdgeInsets.all(3.0),

        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Icon(
                Icons.error,
                color: Colors.red,
                size: 40.0,
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: AutoSizeText(
                    "Upon deletion, all data for this account will be deleted permanently. \n\nAre you sure you want to delete the account?",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    maxLines: 4,
                  ),
                ),
              ],
            ),
            Row(children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    //side: BorderSide(color: Colors.red)
                  ),
                  color: Colors.grey[600],
                  child: Text(
                    'Cancel',
                    style: white_14().copyWith(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    setState(() {
                      _alert = false;
                      _showBody = true;
                    });
                  },
                ),
              ),
              SizedBox(
                width: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      //side: BorderSide(color: Colors.red)
                    ),
                    color: Colors.grey[600],
                    child: Text(
                      'Yes, Delete',
                      style: white_14().copyWith(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      await deleteAccount(account).then((val) {
                        if (val != null) {
                          //updateItems();
                          Navigator.pushNamed(context, '/home');
                        } else {
                          Loading();
                        }
                      });
                    }),
              ),
            ])
          ],
        ),
      );
    }  else {
      return Container(
        color: Colors.black26,
        width: double.infinity,
        //padding: EdgeInsets.all(3.0),

        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Icon(
                Icons.error,
                color: Colors.red,
                size: 40.0,
              ),
            ),
            Text(
              demoText,
              style: infoStyle(),),
            SizedBox(height: 10,),

            Row(
              children: <Widget>[
                Expanded(
                  child: AutoSizeText(
                    "Upon deletion, all data for this account will be deleted permanently. \n\nAre you sure you want to delete the account?",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    maxLines: 4,
                  ),
                ),
              ],
            ),
            Row(children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    //side: BorderSide(color: Colors.red)
                  ),
                  color: Colors.grey[600],
                  child: Text(
                    'Cancel',
                    style: white_14().copyWith(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    setState(() {
                      _alert = false;
                      _showBody = true;
                      demoText = "";

                    });
                  },
                ),
              ),
              SizedBox(
                width: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      //side: BorderSide(color: Colors.red)
                    ),
                    color: Colors.grey[600],
                    child: Text(
                      'Yes, Delete',
                      style: white_14().copyWith(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      setState(() => (demoText = "This demo account cannot be deleted."));
                      
                    }),
              ),
            ]),
            

          ],
        ),
      );

    }
    }
    return SizedBox(
      height: 0,
    );
  }

  Widget showBody() {
    if (_showBody) {
      return Container(
        //color:Colors.red,
        alignment: Alignment.centerLeft,
        child: Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
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
                onPressed: () {
                  //Navigator.pushNamed(context, '/home');
                  setState(() => (demoText = ""));
                  Navigator.pop(context);
                  // setState(() {
                  //   _alert = false;
                  // });
                },
              ),
              SizedBox(
                width: w20,
              ),
              RaisedButton(
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(10.0),
                  //   //side: BorderSide(color: Colors.red)
                  // ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    //side: BorderSide(color: Colors.red)
                  ),
                  color: Colors.grey[600],
                  child: Text(
                    'Update',
                    style: white_14().copyWith(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    if(validate(_formKey)){
                    //if (confirm) {
                      await editAccount(account);
                      Navigator.pushNamed(context, '/home');
                    }

                    //Navigator.pop(context);
                  }),
            ]),
      );
    } else {
      return showAlert(account);
    }
  }

  // Future updateItems() async {
  //   numAccounts = numAccounts - 1;
  //   //await _storage.write('numLinkedAccounts', numAccounts);
  //   if (numAccounts > 0) {
  //     await getAccounts().then((accounts) {
  //       _storage.write('numLinkedAccounts', accounts.length);
  //       _storage.write('tIndex', 1);
  //       _storage.write('account', accounts[0]);
  //       _storage.write('accountIndex', 0);
  //       _storage.write('defaultAccount', accounts[0]);
  //     });
  //   } else {
  //     _storage.write('numLinkedAccounts', 0);
  //     _storage.write('tIndex', 0);
  //   }
  //}

  Widget build(BuildContext context) {
    account = widget.account;

    return loading
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title: Column(
                children: <Widget>[
                  Text(
                    "Account settings",
                    style: white14Bold(),
                  ),
                  Text(
                    accountName,
                    style: white_10(),
                  ),
                ],
              ),
              //leading: IconButton (icon:Icon(Icons.arrow_back)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () =>
                    Navigator.popUntil(context, ModalRoute.withName('/home')),
              ),

              //centerTitle: true,
              automaticallyImplyLeading: false,

              //backgroundColor: Colors.black,
              elevation: 0.0,
            ),
            resizeToAvoidBottomInset: true,
            body: (Container(
                child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: <Widget>[
                          // SizedBox(height: h3),
                          // Text(
                          //   account['account_name'],
                          //   style: TextStyle(fontSize: 18.0),
                          // ),
                          SizedBox(height: h3),
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(child: Text("Name:")),
                              SizedBox(
                                width: w3,
                              ),
                              Container(
                                width: w50,
                                child: TextFormField(
                                  initialValue: account['account_name'],
                                  //decoration: textInputDecoration.copyWith(labelText: "Account Name"),
                                  decoration: InputDecoration(
                                    hintText: "Account Name",
                                  ),
                                  validator: (val) => val.isEmpty
                                      ? 'Account Name (Any unique name)'
                                      : null,
                                  onSaved: (val) => account['account_name'] = val,
                                     // () => account['account_name'] = val),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: h5),
                          //showAlert(),
                          //SizedBox(height: 10.0),

                          Row(children: [
                            Text("Enable/Disable"),
                            Switch(
                              value: account['is_active'],
                              onChanged: (value) {
                                //_showMessage(value);
                                setState(() {
                                  //isActive = value;
                                  //changed = true;
                                  account['is_active'] = value;
                                });
                              },
                              activeTrackColor: Colors.lightGreenAccent,
                              activeColor: Colors.green,
                            ),
                          ]),

                          SizedBox(height: h1),
                          Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Set as default"),
                                  Checkbox(
                                    value: account['is_default'],
                                    onChanged: (value) {
                                      setState(() {
                                        
                                        account['is_default'] = value;
                                        
                                      });
                                    },
                                    //  activeTrackColor: Colors.lightGreenAccent,
                                    activeColor: Colors.grey[800],
                                    checkColor: Colors.greenAccent,
                                  ),
                                  Container(
                                    width: w40,
                                    child: IconButton(
                                      //icon: Icon(Icons.details),
                                      icon: Text(
                                        "Delete",
                                        style: white14Bold()
                                            .copyWith(color: Colors.red),
                                      ),
                                      tooltip: 'Delete the portfolio',
                                      color: Colors.white,
                                      onPressed: () {
                                        setState(() {
                                          _showBody = false;
                                          _alert = true;
                                        });
                                      },
                                    ),
                                  )
                                ]),
                          ),

                          //showAlert(),
                          SizedBox(height: h3),
                          showBody(),
                          SizedBox(height: 30.0),
                        ],
                      ),
                    )))),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     _setAlert();
            //   },
            //   tooltip: 'Delete the account',
            //   child: Icon(
            //     Icons.delete,
            //     color: Colors.red,
            //   ),
            // ),
          );
  }
}
