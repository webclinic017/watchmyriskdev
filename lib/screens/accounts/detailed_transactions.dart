import "package:flutter/material.dart";
import 'package:WMR/services/apis.dart';
//import 'package:WMR/screens/providers/providers.dart';
import 'package:WMR/shared/loading.dart';
import 'package:WMR/shared/constants.dart';
//import 'package:provider/provider.dart';
import 'package:WMR/screens/accounts/show_transaction.dart';

//import 'package:WMR/screens/home/home.dart';
//import 'package:WMR/models/accounts.dart';
//import 'package:marquee/marquee.dart';

//import 'package:WMR/shared/globals.dart' as globals;

class DetailedTransactions extends StatefulWidget {
  final Map account;
  DetailedTransactions({Key key, this.account}) : super(key: key);
  @override
  _DetailedTransactionsState createState() => _DetailedTransactionsState();
}

class _DetailedTransactionsState extends State<DetailedTransactions> {
  Map account;
  int count = 100;
  String accountType;
  String accountId;
  String token;

  @override
  void initState() {
    super.initState();

    //getAccounts();
  }

  @override
  Widget build(BuildContext context) {
    // dynamic wp = Provider.of<WmrProviders>(context);
    // token = wp.getToken;
    account = widget.account;
    //print("Account:$account");
    // int index = wp.getIndex;
    // if (index == 0) {
    // account = wp.getAccount;
    // } else {
    // account = wp.getWatchlist;
    // }

    // account = wp.getAccount;
    // account = ModalRoute.of(context).settings.arguments;
    // if (account == null) {
    //   account = globals.account;
    // }

    //globals.tabIndex = 0;
    accountType = account['type'];
    accountId = account['account_id'];

    // dynamic ptoken = Provider.of<WmrProviders>(context);
    // token = ptoken.getToken;

    return Scaffold(
      //backgroundColor: bgColor,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: <Widget>[
            Text(
              "Rule Matches",
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

      body: _showTrTable(),
    );
  }

  Widget _showTrTable() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 30, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Symbol",
                  style: titleStyle(),
                ),
                SizedBox(width: 30),
                // Text(
                //   "Qty",
                //   style: titleStyle(),
                // ),
                Text(
                  "P/L",
                  style: titleStyle(),
                ),
              ],
            ),
          ),
          Expanded(child: trWidget(count, accountType, accountId)),
        ],
      ),
    );
  }

  Widget _signleTrWidget(context, tr) {
    //print("TR: $tr");
    if (tr['rule']['name'] == null) {
      tr['rule']['name'] = 'NA';
    }
    Color color = Colors.lightBlueAccent;
    if (tr['rule']['notify_only'] == true) {
      color = Colors.deepOrangeAccent;
    }
    //Color _trColor = Colors.white;
    // if (rule['is_active'] == false) {
    //   _ruleColor = Colors.orangeAccent;
    // }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisSize: MainAxisSize.max,
        //mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: ListTile(
                isThreeLine: true,
                dense: true,
                //leading: Icon(Icons.check_circle_outline),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.radio_button_checked,
                      size: 10,
                      color: color,
                    ),
                    SizedBox(width: 2),
                    showSymbol(context, tr),
                  ],
                ),
                subtitle: Container(
                  //color:Colors.red,
                  //width: w30,
                  alignment: Alignment.topLeft,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(tr['rule']['name']),
                        Text(tr['date'])
                        // _ruleState(rule),
                        // _whiteListWidget(rule),
                      ]),
                ),
                //
                trailing: Container(
                    alignment: Alignment.topCenter,
                    width: 70,
                    //color:Colors.red,
                    child: Container(
                        alignment: Alignment.topRight,
                        //width: w20,
                        child: Text(tr['pl_pc'].toString())))),
          ),
          // Text(
          //   "Whitelisted:",
          //   style: white_12(),
          // ),
          //_whiteListWidget(rule),
        ],
      ),
    );
  }

  Widget showSymbol(context, tr) {
    //print(tr);

    String sym = "${tr['ticker']} (${tr['qty'].toInt().toString()}) ";
    return GestureDetector(
        onTap: () async {
          //print("Tapped");

          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ShowTransaction(tr, account, 'Rule match'),
              ));
        },
        child: Text(sym, style: white14Bold()));
  }

  Widget trWidget(count, accountType, accountId) {
    //print("Here In Transaction Widget $accountType");
    return FutureBuilder(
      builder: (context, transactionsSnap) {
        
        if (transactionsSnap.hasData && !transactionsSnap.hasError) {

        return ListView.builder(
          itemCount: transactionsSnap.data.length,
          //itemCount: 1,
          itemBuilder: (context, index) {
            //print(accountsSnap.data[index]['account_name']);
            Map tr = transactionsSnap.data[index];
            return _signleTrWidget(context, tr);
          },
        );
        } else {
          return Loading();
        }
      },
      future: getTransactions(count, accountId),
    );
  }
}
