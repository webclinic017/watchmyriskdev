import 'package:WMR/screens/rules/edit_rule.dart';
import "package:flutter/material.dart";
import 'package:WMR/services/apis.dart';
//import 'package:WMR/screens/rules/edit_rule.dart';
import 'package:WMR/screens/rules/edit_whitelist.dart';
import 'package:WMR/shared/loading.dart';
import 'package:WMR/shared/constants.dart';
//import 'package:WMR/screens/home/home.dart';
import 'package:WMR/models/accounts.dart';
//import 'package:marquee/marquee.dart';

//import 'package:WMR/shared/globals.dart' as globals;

class Rules extends StatefulWidget {
  final Map account;
  Rules({Key key, this.account}) : super(key: key);
  @override
  _RulesState createState() => _RulesState();
}

class _RulesState extends State<Rules> {
  //final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //Map account;
  int tIndex;
  bool loading = false;
  @override
  void initState() {
    super.initState();

    //getAccounts();
  }

  Widget showVolumeDir(dir) {
    if (dir == 'gte') {
      return Text(
        "%volume >= ",
        //style:white_14(),
      );
    } else {
      return Text(
        "%volume <= ",
      );
    }
  }

  Widget showRuleState(rule) {
    if (rule['edit_widget'] != 1) {
      return Wrap(children: <Widget>[
        showVolumeDir(rule['volume']['direction']),
        SizedBox(
          width: w1,
        ),
        Text(rule['volume']['pct'].toString()),
        SizedBox(
          width: w1,
        ),
        Text("%price: "),
        Text(rule['price_pct'].toString()),
      ]);
    }
    return (Wrap(
      children: <Widget>[
        Text('min%:'),
        SizedBox(
          width: w1,
        ),
        Text(rule['min']['user'].toString()),
        SizedBox(
          width: w1,
        ),
        Text('max%:'),
        SizedBox(
          width: w1,
        ),
        Text(rule['max']['user'].toString()),
      ],
    ));
  }

  Widget _ruleState(account, rule) {
    if (rule['is_active'] == false) {
      return (Text(
        "Disabled",
        style: white_12().copyWith(color: Colors.amberAccent),
      ));
    }
    //String isActive;
    String notiOnly;
    String eodOnly;
    //rule['is_active'] == true? isActive='enabled':isActive='disabled';
    rule['eod_only'] == true
        ? eodOnly = 'EoD-Only'
        : eodOnly = 'Checks-Regularly';
    rule['notify_only'] == true
        ? notiOnly = 'Notification-Only'
        : notiOnly = 'Places-Order';
    return (Wrap(
      children: <Widget>[
        //SizedBox(width: 5,),
        showRuleState(rule),
        SizedBox(
          width: w2,
        ),
        Text(notiOnly),
        SizedBox(
          width: w2,
        ),
        Text(eodOnly),
      ],
    ));
  }

  Widget _showGlobalWhitelist(account) {
    if (account['whitelist'].length == 0)
      return (SizedBox(
        width: 0.0,
      ));
    //if (account['is_active'] == false) return (SizedBox(height: 0));

    String wls = "";
    //List items = [];
    int i = 0;
    for (List w in account['whitelist']) {
      i += 1;
      //items.add(w[0]+"["+w[1]+"]");
      wls += w[0];
      if (w[1].toString() != 'all') wls += "[" + w[1] + "]";
      if (i != account['whitelist'].length) wls += ", ";
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5, 5, 20),
      child: SizedBox(
        width: w80,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(wls, style: white_14()),
            )),

        //
        //trailing: Text("Add")
      ),
    );
  }

  Widget _whiteListWidget(account, rule) {
    //print("WL: ${rule['is_active']}");
    if (rule['whitelist'].length == 0) return (SizedBox(height: 0));
    if (rule['is_active'] == false) return (SizedBox(height: 0));

    String wls = "Whitelist: ";
    //List items = [];
    int i = 0;
    for (List w in rule['whitelist']) {
      i += 1;
      //items.add(w[0]+"["+w[1]+"]");
      wls += w[0];
      if (w[1].toString() != 'all') wls += "[" + w[1] + "]";
      if (i != rule['whitelist'].length) wls += ", ";
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 20.0, 0),
      child: SizedBox(
        width: w80,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(wls, style: white_12().copyWith(color: gColor)),
            )),
      ),
    );
  }

  Widget _singleRuleWidget(rule, account) {
    Color _ruleColor = Colors.white;
    if (rule['is_active'] == false) {
      _ruleColor = Colors.orangeAccent;
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisSize: MainAxisSize.max,
        //mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
            //onTap: widget.onSelect,
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditRuleForm(account: account, rule: rule),
                  ));
            },

            child: ListTile(
                isThreeLine: true,
                dense: true,
                title: Text(
                  rule['name'],
                  style: white_14()
                      .copyWith(color: _ruleColor, fontWeight: FontWeight.bold),
                ),
                subtitle: Wrap(children: <Widget>[
                  _ruleState(account, rule),
                  _whiteListWidget(account, rule),
                ])
                //
                //trailing: Text("Add")

                ),
          ),
        ],
      ),
    );
  }

  Widget rulesWidget(account) {
    //print("Here In Transaction Widget $accountType");
    return FutureBuilder(
      builder: (context, rulesSnap) {
        if (rulesSnap.hasData && !rulesSnap.hasError) {
        return ListView.builder(
          itemCount: rulesSnap.data.length,
          //itemCount: 1,
          itemBuilder: (context, index) {
            //print(accountsSnap.data[index]['account_name']);
            Map rule = rulesSnap.data[index];
            return _singleRuleWidget(rule, account);
          },
        );
        }
        else {
            //return noAccount();
            return Loading();
          }
      },
      
      future: getRules(account),
    );
      
  }
  @override
  Widget build(BuildContext context) {
    //account = ModalRoute.of(context).settings.arguments;

    // if (account == null) {
    //   dynamic wp = Provider.of<WmrProviders>(context);
    //   tIndex = wp.getIndex;
    //   //account = globals.account;
    //   tIndex == 1 ? account = wp.getAccount : account = wp.getWatchlist;
    // }
    final Map account = widget.account;
    //String accountName = account['account_name'];

    // dynamic wp = Provider.of<WmrProviders>(context);
    // String token = wp.getToken;

    return loading
        ? Loading()
        : Scaffold(
            //backgroundColor: bgColor,
            key: _scaffoldKey,
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              centerTitle: true,
              title: Column(
                children: <Widget>[
                  Text(
                    "Rules",
                    style: white14Bold(),
                  ),
                  Text(
                    account['account_name'],
                    style: white_10(),
                  ),
                ],
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () =>
                    Navigator.popUntil(context, ModalRoute.withName('/home')),
              ),
              //backgroundColor: Colors.black,
              elevation: 0.0,
            ),

            resizeToAvoidBottomInset: true,

            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Text(
                //   "Account: ",
                //   style: titleStyle(),
                // ),
                // SizedBox(height: h1),
                // Text(
                //   "   $accountName",
                //   style: white14Bold(),
                // ),
                SizedBox(height: h1),

                Row(
                  children: <Widget>[
                    Text(
                      "Global whitelist (${account['whitelist'].length}): ",
                      style: titleStyle(),
                    ),
                    IconButton(
                        icon: Icon(Icons.edit),
                        tooltip: 'Edit whitelist',
                        color: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  //Rules(accountId: account['account_id']))
                                  EditWhiteList(),
                              settings: RouteSettings(
                                //arguments: account,
                                arguments: WhiteListArguments(account, null),
                              ),
                            ),
                          );
                        }),
                  ],
                ),

                _showGlobalWhitelist(account),

                SizedBox(height: h1),

                //Text("Add/Edit the global whitelist"),
                Text(
                  "Rules: ",
                  style: titleStyle(),
                ),
                //Expanded(
                Expanded(child: rulesWidget(account)),
                //),

                SizedBox(height: h1),
              ],
            ),
          );
  }
}
