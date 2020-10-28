import 'package:WMR/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:WMR/shared/constants.dart';
//import 'package:super_rich_text/super_rich_text.dart';


class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //boldOrangeMarker();
    return Material(
        child: Scaffold( 
          
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0), // here the desired height
            
            child: AppBar( centerTitle: true,
             automaticallyImplyLeading: true,
             title: Text("About",style: white14Bold(),),
             leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignIn(),
                      ));
                },
              ),
            ),
          ),

      body: 
      Container(
        padding: EdgeInsets.all(20.0),
        child: 
        SingleChildScrollView(
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            Text("Mission",
            style: titleStyle(),),
            Text(
              "To take emotions out of trading.",
              style: white14Bold(),
              ),
              SizedBox(height:10.0),
              Text("Features",
              style: titleStyle(),),
              Text(
              "Below are a list of notable features:",
              style: white14Bold(),
              ),
              SizedBox(height:10.0),
              Text("Sell Rules",
              style: titleStyle(),),
              Text(
              "Watch My Risk aka. WMR provides the users the ability to employ a set of sell/exit rules governing their exit critria after they acquired a position in the stock market.",
              style: white_14(),
              ),
              SizedBox(height:10.0),
              Text("Manual portfolios",
              style: titleStyle(),),
              Text(
              "Users may create portfolios manually. After adding a portfolio, a set of default rules will be presented to them and thye may choose which ones to use and edit them.",
              style: white_14(),
              ),

              SizedBox(height:10.0),
              Text("Linked accounts",
              style: titleStyle(),),
              Text(
              "Users may link their brokerage account(s). After linking an account, a set of default rules will be presented to them and they may choose which ones to use and edit them.",
              style: white_14(),
              ),
              SizedBox(height:10.0),
              Text("Notification-only",
              style: titleStyle(),),
              Text(
              "For the linked accounts, users may choose to keep them in notification-only mode meaning the WMR won't place any sell order on their behalf upon a triggered rule",
              style: white_14(),
              ),
              SizedBox(height:10.0),
              Text("Whitelists",
              style: titleStyle(),),
              Text(
              "Sell rules are applied to all the long positions held in an account. Users may wish to prevent rule(s) being applied to certain positions. In that case, they may whitelist those positions either for all rules or for some rules. Once a position is white listed, the rule(s) won't get applied to it. It is also possible to whitelist only a portion of a holding",
              style: white_14(),
              ),

              SizedBox(height:10.0),
              Text("End-Of-Day only",
              style: titleStyle(),),
              Text(
              "The user may choose to have rules to be applied at about fifteen minutes before the closing of a trading day or on a regular basis during the trading hours.",
              style: white_14(),
              ),
              SizedBox(height:10.0),
              Text("Supported trading types",
              style: titleStyle(),),
              Text(
              "Currently, WMR only support long stock positions.",
              style: white_14(),
              ),

          ],),
        ),
      )
      
        )
    );
  }
}