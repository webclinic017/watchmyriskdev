import 'package:WMR/screens/accounts/activity_logs.dart';
import 'package:WMR/screens/accounts/edit_watchlist.dart';
import 'package:WMR/screens/accounts/holdings.dart';
import 'package:WMR/shared/constants.dart';
import 'package:flutter/material.dart';
//import 'package:WMR/services/apis.dart';

//import 'package:WMR/models/accounts.dart';
import 'package:WMR/screens/rules/rules.dart';
import 'package:WMR/screens/accounts/edit_account.dart';
//import 'package:WMR/screens/accounts/account_details.dart';
//import 'package:WMR/shared/globals.dart' as globals;

import 'package:flutter_icons/flutter_icons.dart';
import 'package:WMR/screens/accounts/detailed_transactions.dart';

// Icon(AntDesign.stepforward),
// Icon(Ionicons.ios_search),
// Icon(FontAwesome.glass),
// Icon(MaterialIcons.ac_unit),
// Icon(FontAwesome5.address_book),
// Icon(FontAwesome5Solid.address_book),
// Icon(FontAwesome5Brands.$500px)
//import 'package:WMR/shared/storage.dart';

//SS _storage = SS();

class AccountTile extends StatelessWidget {
  final Map account;
 
  
  AccountTile({this.account});
  Widget showRules(account, context) {
  
    return (IconButton(
      icon: Icon(FlutterIcons.sound_mix_ent),
      tooltip: 'Rules',
      color: Colors.white,
      onPressed: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Rules(account: account),
            ));
      },
    )); // icon-1
  
}

Widget showDisabled(account) {
  //print("In Show Edit, account:$account");
  if (account['reachable'] == false) {
    return Text(
        "Not reachable",
        textAlign: TextAlign.left,
        //overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
          letterSpacing: 1,
        ),
    );

  }
  if (account['is_active'] == true) {
    return SizedBox(width: 0.0);
  } else {
    return Text(
        "Disabled",
        textAlign: TextAlign.left,
        //overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
          fontSize: 10.0,
          letterSpacing: 1,
        ),
    );
    
  }
}

Widget showSettings(account, context) {
  //print("Setting account: $account");
  return IconButton(
                  //icon: Icon(FlutterIcons.edit_ant),
                  icon: Icon(Icons.settings),
                  tooltip: 'Settings',
                  color: Colors.white,
                  onPressed: () async {
                    //globals.account = account;
                    //await _storage.write('account', account);
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditAccount(account: account),
                        ));

                   
                     });
}

Widget showHoldings(account, context) {
  if (account['type'] == 'manual') {
  return IconButton(
                  icon: Icon(FlutterIcons.briefcase_mco),
                  tooltip: 'Holdings',
                  color: Colors.white,
                  onPressed: () async {
                    // updateWatchlist(account['watchlist']).then((w) {
                    // account['watchlist'] = w;
                    // print("Tile WL: $w");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditWatchlist(account: account),
                        ));

                   });
                     
  } else {
    return IconButton(
                  icon: Icon(FlutterIcons.briefcase_mco),
                  tooltip: 'Holdings',
                  color: Colors.white,
                  onPressed: () async {
                    //globals.account = account;
                    //await _storage.write('account', account);
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Holdings(account: account),
                        ));

                   
                     });

  }
}

Widget showBroker(account) {
  if (account['broker'] != null) {       
     return 
     Text(
       account['broker'],
       style:white_10());
  } else {
    return Text(
      "manual",
      style:white_10(),
      );
  }
}

Widget showRulesMatches(account,context) {
    if (account == null) return SizedBox(height: 0.0);
    //if (account['num_transactions'] > 10) {
     else { return Container(
        //width: h15,
        child: IconButton(
            //icon: Icon(Icons.details),    
            icon: Icon(FlutterIcons.notification_ent),   
            tooltip: 'Rule Matches',
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
  
  }


Widget showActivities(account, context) {
  return IconButton(
                  icon: Icon(FlutterIcons.activity_fea),
                  //icon: Icon(FlutterIcons.notification_ent),
                  tooltip: 'Activities',
                  color: Colors.white,
                  onPressed: () async {
                    //globals.account = account;
                    //await _storage.write('account', account);
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ActivityLogs(account: account),
                        ));

                    
                  });

}



  @override
  Widget build(BuildContext context) {
    dynamic assetImg = 'malqu.jpg';
    
    if (account['broker'] == 'alpaca') {
      assetImg = 'alpaca.png';
    } else if (account['broker'] == 'robinhood') {
      assetImg = 'robinhood40.png';
    }
    if (account['type'] == 'manual') {
        assetImg = 'manualPortfolio.png';
    }
    return  Container(
        //margin: EdgeInsets.all(5.0),
        
        child: 
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 20.0,
                backgroundImage: AssetImage('assets/$assetImg'),
              ),
              // title: Text("Title ${widget.index}"),
              // subtitle: Text("Description ${widget.index}"),
                //title: showDisabled(account),
                //account['account_name'],
                

                
              // subtitle: 
              // Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
                
              //   children: [
              //     //Text(account['broker']),
              //     //showBroker(account),
              //     //showDisabled(account)
              //   ],
              // ),
              trailing: Wrap(
                //mainAxisSize: MainAxisSize.min,
                //spacing: 10, // space between two icons
                children: <Widget>[
                  
                  showSettings(account, context),
                  showHoldings(account, context),
                  showRules(account, context),
                  showRulesMatches(account, context),
                  showActivities(account, context),

                      
                ],
              ),
            ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0,0,0,10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text(
                        account['account_name'],
                        style: white14Bold(),), 
                      showBroker(account),
                      showDisabled(account),
                      SizedBox(height: h3,)
                  ],
                ),
              ),
          ],
        ),
    );
  }
}