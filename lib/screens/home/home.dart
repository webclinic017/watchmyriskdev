import 'package:WMR/screens/accounts/activity_logs.dart';
import 'package:WMR/screens/accounts/add_account.dart';
import 'package:WMR/services/apis.dart';
import 'package:WMR/screens/accounts/detailed_transactions.dart';
import 'package:WMR/screens/home/new_user.dart';
import 'package:WMR/services/auth.dart';

import 'package:flutter/material.dart';
import 'dart:convert';

//import 'package:WMR/screens/accounts/accounts.dart';
import 'package:WMR/screens/accounts/account_tile.dart';

//import 'package:WMR/screens/accounts/transactions.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:WMR/shared/constants.dart';

//import 'package:WMR/shared/globals.dart' as globals;
import 'package:WMR/shared/loading.dart';
import 'package:WMR/screens/accounts/addPortfolio.dart';

//import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';

//import 'package:WMR/services/auth.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

// SS _storage = SS();
// final storage = FlutterSecureStorage();

//import 'package:flutter_hooks/flutter_hooks.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

//class _LinkedAccountsState extends State<LinkedAccounts> with
//AutomaticKeepAliveClientMixin <LinkedAccounts> {

//class _LinkedAccountsState extends State<LinkedAccounts> with AutomaticKeepAliveClientMixin {
class _HomeState extends State<Home> {
  //@override
  //bool get wantKeepAlive => true;
  final AuthService _auth = AuthService();
  Map<String, dynamic> _items = {};

  int i = 0;
  int currentSelectedIndex = 0;
  int accountIndex;

  String error = '';

  //String _wlName = '';
  bool loading = false;

  //bool _addWl = false;
  //String token = '';
  int indexTab = 0;
  int count = 10;
  String accountId;
  bool showAdd = true;
  Map currentAccount;
  int numLinkedAccounts;
  Map account;
  List accountNames = [];
  int numAccounts;

  //bool _userLoggedIn = true;

  //bool noLinkedAccounts = false;
  //Map transactions;

  //AnimationController percentageAnimationController;

  //FirebaseUser user;

  Future<String> loadSettingsFuture; // <-Add this
  Future<bool> checkUser; // <-Add this
  final _st = FlutterSecureStorage();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String loginType = "";

  @override
  void initState() {
    loadSettingsFuture = _numAccounts(); // <- Change This
    //checkUser = _checkUser(); // <- Change This
    //accountIndex = _items['accountIndex'];
    super.initState();
    _readAll();
  }

  Future<Null> _numAccounts() async {
    final all = await getAccounts();
    setState(() {
      if (all != null) numAccounts = all.length;
      //k = v;
    });
  }

  // Future<Null> _checkUser() async {
  //   final ret = await _auth.isUserLoggedIn();
  //   setState(() {
  //     _userLoggedIn = ret;
  //     //k = v;
  //   });
  // }

  // Future<Null> _readAll() async {
  //   //final all = await storage.readAll();

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
  void dispose() {
    super.dispose();
  }

// void linkedAccountsCount() async {
//   await getAccounts(token).then((result) {
//     //print("Num Linked Accounts: ${result.length}");
//     if (result.length == 0)
//        setState(() => noLinkedAccounts = true);

//   });
// }

  Widget showDrawer() {
    return Container(
      width: 250,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  // gradient: LinearGradient(colors: <Color>[
                  //   Colors.deepOrange,
                  //   Colors.orangeAccent,
                  // ])
                  ),
              child: Container(
                  child: Column(children: [
                Material(
                  //borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  elevation: 0,
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Image.asset(
                          //'assets/WMR_40x40.png',
                          'assets/WMR2.png',
                        )),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Watch My Risk",
                      style: titleStyle(),
                    ))
              ])),
              // decoration: BoxDecoration(
              //     color: Colors.green,
              //     image: DecorationImage(
              //         fit: BoxFit.fill,
              //         image: AssetImage('assets/images/cover.jpg'))),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[700]))),
              child: ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign off'),
                onTap: () async {

                  if (loginType == 'google') {
                    signOutGoogle();
                  }else{
                    await _auth.signOut();
                  }
                  setState(() => loading = true);
                  await Navigator.pushNamed(context, '/sign_in');
                  //Navigator.of(context).pop();
                },
              ),
            ),

            Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[700]))),
              child: ListTile(
                leading: Icon(Icons.book),
                title: Text('How-tos'),
                onTap: () => Navigator.pushNamed(context, '/how_tos'),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[700]))),
              child: ListTile(
                leading: Icon(Icons.speaker_notes),
                title: Text('Rules description'),
                onTap: () => Navigator.pushNamed(context, '/rules_description'),
              ),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //       border: Border(bottom: BorderSide(color: Colors.grey[700]))),
            //   child: ListTile(
            //     leading: Icon(Icons.settings),
            //     title: Text('Profile'),
            //     onTap: () => Navigator.pushNamed(context, '/settings'),
            //   ),
            // ),
            Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[700]))),
              child: ListTile(
                leading: Icon(Icons.border_color),
                title: Text('Contact'),
                onTap: () => Navigator.pushNamed(context, '/contact'),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[700]))),
              child: ListTile(
                leading: Icon(Icons.person_add),
                title: Text('Invite friends'),
                onTap: () => Navigator.pushNamed(context, '/invite'),
              ),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //       border: Border(bottom: BorderSide(color: Colors.grey[700]))),
            //   child: ListTile(
            //     leading: Icon(Icons.payment),
            //     title: Text('Billing dashboard'),
            //     onTap: () => Navigator.pushNamed(context, '/billing'),
            //   ),
            // ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[700]))),
              child: Row(
                children: [
                  Icon(FlutterIcons.warning_ant),
                  SizedBox(
                    width: 30,
                  ),
                  RichText(
                    text: new TextSpan(
                      children: [
                        new TextSpan(
                          text: 'Privacy',
                          //style: new TextStyle(color: Colors.blue),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch('https://www.watchmyrisk.com/privacy');
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[700]))),
              child: Row(
                children: [
                  Icon(FlutterIcons.warning_ant),
                  SizedBox(
                    width: 30,
                  ),
                  RichText(
                    text: new TextSpan(
                      children: [
                        new TextSpan(
                          text: 'Disclaimer',
                          //style: new TextStyle(color: Colors.blue),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch('https://www.watchmyrisk.com/disclaimer');
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[700]))),
              child: ListTile(
                leading: Icon(Icons.announcement),
                title: Text('About'),
                onTap: () => Navigator.pushNamed(context, '/about'),
              ),
            ),

            // Container(
            //   decoration: BoxDecoration(
            //       border: Border(bottom: BorderSide(color: Colors.grey[700]))),
            //   child: ListTile(
            //     leading: Icon(Icons.contact_phone),
            //     title: Text('Contact'),
            //     onTap: () => Navigator.pushNamed(context, '/contact'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // Widget showTransactions() {
  //   //print("Account: $accountId");
  //   //print("numTr: ${account['num_transactions']}");
  //   if (account == null) {
  //     return SizedBox(
  //       height: 0,
  //     );
  //   }
  //   if (account['num_transactions'] == 0) {
  //     return (Text(
  //       "No matched rules yet!",
  //       style: errorStyle(),
  //     ));
  //   }
  //   return Column(
  //     children: <Widget>[
  //       Container(
  //         padding: EdgeInsets.fromLTRB(15, 0, 20, 10),
  //         //alignment: Alignment.centerLeft,
  //         color: Colors.transparent,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: <Widget>[
  //             Text(
  //               "Symbol",
  //               style: titleStyle(),
  //             ),
  //             // SizedBox(width: 10),
  //             // Text(
  //             //   "Qty",
  //             //   style: titleStyle(),
  //             // ),
  //             Text(
  //               "P/L",
  //               style: titleStyle(),
  //             ),
  //           ],
  //         ),
  //       ),
  //       Container(height: h30, child: trWidget(count, 'linked', accountId)),
  //     ],
  //   );
  // }

  Widget noAccount() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Welcome to watch-my-risk",
              style: titleStyle(),
            ),
            SizedBox(height: h2),
            Text(
              "In order to use this application you need to follow below four steps. In each step, there will be detailed description on how to perform the action.",
              style: white_14(),
            ),
            SizedBox(height: h3),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "1) Add manual portfolio and/or link your brokerage account",
                    style: white_12(),
                  ),
                  SizedBox(height: h1),
                  Text(
                    "2) Enable the account",
                    style: white_12(),
                  ),
                  SizedBox(height: h1),
                  Text(
                    "3) Review rules and enable/edit the ones you like",
                    style: white_12(),
                  ),
                  SizedBox(height: h1),
                  Text(
                    "4) If needed, add symbols to the global or rule whitelist",
                    style: white_12(),
                  ),
                  SizedBox(height: h2),
                  Row(children: [
                    Text("You can find more details in "),
                    GestureDetector(
                        child: Text(
                          "how-tos",
                          style: TextStyle(color: Colors.lightBlueAccent),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/how_tos');
                          FocusScope.of(context).unfocus();
                        }),
                  ]),
                  SizedBox(height: h2),
                  Row(children: [
                    GestureDetector(
                        child: Text(
                          "Click here",
                          style: TextStyle(color: Colors.lightBlueAccent),
                        ),
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddPortfolio(wlNames: []),
                              ));
                        }),
                    Text(" to add a manual portfolio "),
                  ]),
                  SizedBox(height: h2),
                  Row(children: [
                    GestureDetector(
                        child: Text(
                          "Click here",
                          style: TextStyle(color: Colors.lightBlueAccent),
                        ),
                        onTap: () async {
                          await Navigator.pushNamed(context, '/add_account');
                        }),
                    Text(" to link a supported brokrage account "),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget accountsWidget() {
    print("In accounts widget");
    // if ((numLinkedAccounts > 0) & (account == null))
    //   return SizedBox(height: 0.0);
    //if (numLinkedAccounts == 0)
    //  return (Text("No account yet!", style: errorStyle()));
    //print("Num: $numLinkedAccounts");

    return FutureBuilder(
        //future: _future,
        future: getAccounts(),
        builder: (context, accountsSnap) {
          if (accountsSnap.hasData && !accountsSnap.hasError) {
            return Expanded(
              child: ListView.builder(
                //scrollDirection: Axis.vertical,
                itemCount: accountsSnap.data.length,
                //itemCount: 1,
                itemBuilder: (context, index) {
                  //print(accountsSnap.data[index]['account_name']);
                  Map account = accountsSnap.data[index];
                  //print("Account: $account");
                  if (!(accountNames).contains(account['account_name'])) {
                    accountNames.add(account['account_name'].toUpperCase());
                  }
                  return AccountTile(account: account);
                },
              ),
            );
          } else {
            //return noAccount();
            return Loading();
          }
        });
  }

  Widget showMoreWidget() {
    if (account == null) return SizedBox(height: 0.0);
    if (account['num_transactions'] > 10) {
      return Container(
        width: h20,
        child: IconButton(
            //icon: Icon(Icons.details),
            icon: Text(
              "   show more",
              style: white_14().copyWith(color: gColor),
              //style: white_14().copyWith(color: Colors.yellowAccent),
            ),
            tooltip: 'All rule matches',
            color: Colors.white,
            onPressed: () async {
              //Navigator.pushNamed(context, '/detailed_transactions');
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailedTransactions(account: account),
                  ));
            }),
      );
    }
    return (SizedBox(
      width: 0,
    ));
  }

  Widget showActivities(account) {
    if (account == null)
      return SizedBox(height: 0.0);
    //if (account['num_transactions'] > 10) {
    else {
      return Container(
        width: h15,
        child: IconButton(
            //icon: Icon(Icons.details),
            icon: Text(
              "activities",
              style: white_14().copyWith(color: gColor),
            ),
            tooltip: 'All activities',
            color: Colors.white,
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityLogs(account: account),
                  ));
            }),
      );
    }
  }

  Widget showAccounts() {
    // if (numAccounts == 0) {
    //   return NewUser();
    // }
    //print("HERE $account");

    //globals.tabIndex = 0;
    loading = true;
    return (Container(
        child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height: h1,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Accounts:',
                    overflow: TextOverflow.ellipsis,
                    style: white14Bold(),
                  ),
                  IconButton(
                      icon: Icon(Icons.add),
                      tooltip: 'Add a new account',
                      color: Colors.white,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddAccount(accountNames: accountNames),
                          ),
                        );
                      }),
                  //showActivities(),
                ],
              ),
            ),
            accountsWidget(),
            SizedBox(
              height: h5,
            ),
            // Text(
            //   'Latest Rule Matches',
            //   overflow: TextOverflow.ellipsis,
            //   style: white14Bold(),
            // ),
            // //showMoreWidget(),
            // SizedBox(
            //   height: h1,
            // ),
            // Text(
            //   'Latest Activities',
            //   overflow: TextOverflow.ellipsis,
            //   style: white14Bold(),
            // ),
          ]),
    )));
  }

  void populateData() {
    print("Rebuilding Linked Accounts");
    //print("Items: $_items");
    numLinkedAccounts = int.parse(_items['numLinkedAccounts']);
    if (_items['account'] != null) {
      account = json.decode(_items['account']);
      accountIndex = int.parse(_items['accountIndex']);
      //token = _items['token'];
      accountId = account['account_id'];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (numAccounts == 0) {
      return NewUser();
    } else {
      return Material(
          child: Scaffold(
        drawer: showDrawer(),

        appBar: (
            // preferredSize:
            // Size.fromHeight(70.0), // here the desired height
            AppBar(
          centerTitle: true,
          automaticallyImplyLeading: true,
          title: Text(
            "Watch My Risk",
            style: white14Bold(),
          ),

          //backgroundColor: Colors.black,
          elevation: 0.0,
        )),
        body: showAccounts(),
        //floatingActionButton: linkedFloating(),
      ));
    }
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }

  Future<Null> _readAll() async {
    await _st.read(key: 'user_type').then((e) {
      setState(() {
        if (e != null) {
          print("type:::" + e.toString());
          loginType = e.toString();
        } else {
          loginType = '';
          print("type:::" + 'Type is not available');
        }
      });
    });
  }
}
