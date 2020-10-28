import "package:flutter/material.dart";
import 'package:WMR/services/apis.dart';
import 'package:WMR/shared/loading.dart';
import 'package:WMR/shared/constants.dart';
//import 'package:WMR/screens/home/home.dart';
//import 'package:marquee/marquee.dart';

//import 'package:WMR/shared/globals.dart' as globals;

class RulesDescription extends StatefulWidget {
  @override
  _RulesDescriptionState createState() => _RulesDescriptionState();
}

class _RulesDescriptionState extends State<RulesDescription> {
  //Map account;
  // @override
  // void initState() {
  //   super.initState();

  //   //getAccounts();
  // }

  @override
  Widget build(BuildContext context) {
    //account = ModalRoute.of(context).settings.arguments;
    // if (account == null) {
    //   account = globals.account;
    // }
    //print("Rebuilding Rules. ACCOUNT: $account");
    //final accountId = account['account_id'];
    //String accountName = account['account_name'];
    //globals.tabIndex = 0;

    // dynamic ptoken = Provider.of<WmrProviders>(context);
    // String token = ptoken.getToken;

    //create: (context) => TabIndex(),
    return Scaffold(
      //backgroundColor: bgColor,

      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Rules Desription',
          style: white14Bold(),
        ),
        //leading: IconButton (icon:Icon(Icons.arrow_back)),
        //   leading: new IconButton(
        //     icon: new Icon(Icons.arrow_back),
        //     onPressed: () {
        //       Provider.of<WmrProviders>(context, listen: false).saveIndex(1);
        //       Navigator.push(
        //         //Provider.of<TabIndex>(context, listen: false).saveIndex(1);
        //         context,
        //         MaterialPageRoute(builder: (context) => Home()),
        //       );
        //   },
        // ),

        //centerTitle: true,
        automaticallyImplyLeading: true,

        //backgroundColor: Colors.black,
        elevation: 0.0,
        // actions: <Widget>[
        //             FlatButton.icon(
        //               icon: Icon(Icons.home),
        //               label: Text(
        //                 'Home',
        //                 style: white_12().copyWith(fontSize: 16.0),
        //               ),
        //               onPressed: () {
        //                   Navigator.push(
        //                     context,
        //                     MaterialPageRoute(builder: (context) => Home()),
        //                   );
        //               },
        //             ),

        //           ],
      ),

      resizeToAvoidBottomInset: true,

      body: Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 20.0, 4.0, 4.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: h2),

              Expanded(child: rulesWidget()),
              //),

              SizedBox(height: h1),
            ]),
      ),

      // floatingActionButton: FloatingActionButton.extended(
      //         onPressed: () {},
      //         //icon: Icon(Icons.save),
      //         label: Text(
      //           "Global whitelist",
      //           style: white_10(),
      //           ),
      //       ),
    );
  }

  Widget showVolumeDir(dir) {
    if (dir == 'gte') {
      return Flexible(
          child: Text(
        "volume >= ",
        //style:white_14(),
      ));
    } else {
      return Flexible(
          child: Text(
        "volume <= ",
      ));
    }
  }

  Widget showRuleState(rule) {
    if (rule['edit_page'] != 1) {
      return Wrap(children: <Widget>[
        showVolumeDir(rule['volume']['direction']),
        SizedBox(
          width: w1,
        ),
        Text("%"),
        Text(rule['volume']['pct'].toString()),
      ]);
    }
    return (Wrap(
      children: <Widget>[
        Text('min:'),
        SizedBox(
          width: w1,
        ),
        Text(rule['min']['user'].toString()),
        SizedBox(
          width: w1,
        ),
        Text('max:'),
        SizedBox(
          width: w1,
        ),
        Text(rule['max']['user'].toString()),
      ],
    ));
  }

  Widget _signleRuleWidget(rule) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      //mainAxisSize: MainAxisSize.max,
      //mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        ListTile(
            isThreeLine: true,
            dense: true,
            //leading: Text(rule['rule_id'].toString()),
            title: Row(
              children: <Widget>[
                Text(
                  rule['rule_id'].toString(),
                  style: titleStyle(),
                ),
                Text(
                  ': ',
                  style: titleStyle(),
                ),
                Text(
                  rule['name'],
                  style: titleStyle(),
                ),
              ],
            ),
            subtitle: Wrap(children: <Widget>[
              Text(
                rule['description'],
                style: white_14(),
              ),
              //_ruleState(rule),
              //_whiteListWidget(rule),
            ])
            //
            //trailing: Text("Add")

            ),
        // Text(
        //   "Whitelisted:",
        //   style: white_12(),
        // ),
        //_whiteListWidget(rule),
      ],
    );
  }

  Widget rulesWidget() {
    //final accountId = account['account_id'];
    return FutureBuilder(
      builder: (context, rulesSnap) {
        if (rulesSnap.data == null) {
          return Loading();
        }

        return ListView.builder(
            shrinkWrap: true,
            //itemExtent: 100.0,
            scrollDirection: Axis.vertical,
            itemCount: rulesSnap.data.length,
            //itemCount: 1,
            itemBuilder: (context, index) {
              //print(accountsSnap.data[index]['account_name']);
              Map rule = rulesSnap.data[index];
              return _signleRuleWidget(rule);
            });
      },
      future: getRules('Description'),
    );
  }
}
