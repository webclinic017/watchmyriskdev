import 'package:WMR/screens/accounts/add_account.dart';
import 'package:flutter/material.dart';
import 'package:WMR/shared/constants.dart';
//import 'package:WMR/services/apis.dart';
//import 'package:WMR/shared/size_config.dart';

import 'package:WMR/services/auth.dart';

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  final AuthService _auth = AuthService();
  bool loading = false;
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
                  child: 
                  Container(
                    height:100,
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
                  await _auth.signOut();
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
                leading: Icon(Icons.warning),
                title: Text('Disclaimer'),
                onTap: () => Navigator.pushNamed(context, '/disclaimer'),
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
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[700]))),
              child: ListTile(
                leading: Icon(Icons.personal_video),
                title: Text('Privacy'),
                onTap: () => Navigator.pushNamed(context, '/privacy'),
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

  @override
  Widget build(BuildContext context) {
    boldMarker('|', Colors.deepOrangeAccent);
    return Material(
        child: Scaffold(
            drawer: showDrawer(),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(70.0), // here the desired height

              child: AppBar(
                centerTitle: true,
                automaticallyImplyLeading: true,
                title: Text(
                  "Welcome",
                  style: white14Bold(),
                ),
              ),
            ),
            body: Container(
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
                            "1) Add a manual portfolio and/or link your brokerage account",
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
                            "4) If desired, add symbols to the global or rule whitelist",
                            style: white_12(),
                          ),
                          SizedBox(height: h2),
                          Row(children: [
                            Text("You can find more details in "),
                            GestureDetector(
                                child: Text(
                                  "how-tos",
                                  style:
                                      TextStyle(color: Colors.lightBlueAccent),
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
                                  style:
                                      TextStyle(color: Colors.lightBlueAccent),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddAccount(accountNames: []),
                                    ),
                                  );
                                }),
                            Text(" to add an account "),


                            
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
