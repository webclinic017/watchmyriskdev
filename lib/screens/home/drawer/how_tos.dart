import 'package:flutter/material.dart';
import 'package:WMR/shared/constants.dart';
import 'package:super_rich_text/super_rich_text.dart';
import 'package:flutter_icons/flutter_icons.dart';


class HowTos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    boldMarker('|', Colors.deepOrangeAccent);
    return Material(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(70.0), // here the desired height

              child: AppBar( centerTitle: true,
                automaticallyImplyLeading: true,
                title: Text("How-tos", style: white14Bold(),),
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
                      "Steps",
                      style: titleStyle(),
                    ),
                    Text(
                      "In order to use this application you need to follow these steps. In each step, there will be detailed description on how to perform the action.",
                      style: white_14(),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "1) Add a portfolio manually and/or link a supported brokrage account",
                            //style: white_12(),
                          ),
                          Text(
                            "2) Review rules and edit as you wish",
                            //style: white_12(),
                          ),
                          Text(
                            "3) If needed, add symbols to the global whitelist",
                            //style: white_12(),
                          ),
                          Text(
                            "4) If needed, add symbols to the rule(s) whitelist",
                            //style: white_12(),
                          ),
                          Text(
                            "5) Enable the rule(s)",
                            //style: white_12(),
                          ),
                        ],
                      ),
                    ),

                    // SuperRichText(
                    //   text: 'Text in *bold* and /italic/ ',
                    //   style: white_12(),
                    // ),
                    

                    SizedBox(height: 10.0),

                    Text(
                      "Adding a portfolio manually",
                      style: titleStyle(),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "1) On the home page,  click on the ",
                                ),
                                WidgetSpan(
                                  child: Icon(Icons.add,
                                      size: 18, color: Colors.deepOrangeAccent),
                                ),
                                TextSpan(
                                  text: " icon next to the 'Accounts' ",
                                ),
                              ],
                            ),
                          ),
                          Text(
                           
                                "2) In the next page, click on 'Manual Portfolios' image",
                            //style: white_12(),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "3) Fill out the field for the 'Portfolio name' and click 'Add'\n",
                                ),
                                TextSpan(
                                  text:
                                      "4) Once added, click on the ",
                                ),
                                WidgetSpan(
                                  child: Icon(Icons.settings,
                                      size: 18, color: Colors.deepOrangeAccent),
                                ),
                                TextSpan(
                                  text: " icon to go to the setting page and enable the account ",
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "5) On the home hage, click on the "),
                                WidgetSpan(
                                  child: Icon(FlutterIcons.briefcase_mco,
                                      size: 18, color: Colors.deepOrangeAccent),
                                ),
                                  TextSpan(
                                  text:
                                      " sign and go to the holdings page to add holdings to your portfoio ",
                                ), 
                            
                                
                              ],
                            ),
                          ),
                          SuperRichText(
                            text:
                                "6) On holding apge, to remove a holding, drag the row to the left",
                            style: white_14(),
                          ),
                          SuperRichText(
                            text: "7) Once finished, click on 'Done''",
                            style: white_14(),
                          ),
                          SuperRichText(
                            text:
                                "8) Once done, edit/enable rules as explained in the 'Editting rules' section below",
                            style: white_14(),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10.0),

                    Text(
                      "Linking a brokrage account",
                      style: titleStyle(),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "1) On the home page,  click on the ",
                                ),
                                WidgetSpan(
                                  child: Icon(Icons.add,
                                      size: 18, color: Colors.deepOrangeAccent),
                                ),
                                TextSpan(
                                  text: " icon next to the 'Accounts' ",
                                ),
                              ],
                            ),
                          ),
                          SuperRichText(
                            text: "2) On the next page click on a broker icon",
                            //style: white_12(),
                          ),
                          SuperRichText(
                            text:
                                "3) Follow the steps on the page for the broker",
                            //style: white_12(),
                          ),
                          SuperRichText(
                            text:
                                "4) Once done, edit/enable rules by clicking on the rules icon next to the account name",
                            //style: white_12(),
                          ),
                          
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "5) On the home page,  click on the ",
                                ),
                                WidgetSpan(
                                  child: Icon(Icons.settings,
                                      size: 18, color: Colors.deepOrangeAccent),
                                ),
                                TextSpan(
                                  text: " icon to enable the account",
                                ),
                              ],
                            ),
                          ),



                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),

                    Text(
                      "Editting rules",
                      style: titleStyle(),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "1) On the home page, click on the ",
                                ),
                                WidgetSpan(
                                  child: Icon(FlutterIcons.sound_mix_ent,
                                      size: 18, color: Colors.deepOrangeAccent),
                                ),
                                TextSpan(
                                  text: " next to an account",
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "2) In the next page (Rules), click on the rule name",
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "3) A page will be shown where you can edit the rule",
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "4) Once done, click 'Update'",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),

                    Text(
                      "Managing the global whitelist",
                      style: titleStyle(),
                    ),
                    SuperRichText(
                      text:
                          "You may add whitelist to prevent rules being applied to all or portion of your holdings. The whitelist can be added for globally per account or per each rule. Whitelist are managed from the rules page. To manage global whilelists follow below steps:",
                      //style: white_12(),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "1) On the home page, click on the ",
                                ),
                                WidgetSpan(
                                  child: Icon(FlutterIcons.sound_mix_ent,
                                      size: 18, color: Colors.deepOrangeAccent),
                                ),
                                TextSpan(
                                  text:
                                      " next to the account's name, which will takes you to the rules page",
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "2) At the bottom of the page next to 'Global whitelist' click on ",
                                ),
                                WidgetSpan(
                                  child: Icon(Icons.edit,
                                      size: 18, color: Colors.deepOrangeAccent),
                                ),
                                TextSpan(
                                  text: " icon",
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "3) A page will be shown where you can add/delete symbols to/from the whitelist",
                                ),
                              ],
                            ),
                          ),
                          SuperRichText(
                            text:
                                "4) Leave the 'qty' field blank if you want to whitelist the entire holding.",
                            //style: white_12(),
                          ),
                          SuperRichText(
                            text:
                                "5) To remove a symbol, drag the symbol row to the left",
                            //style: white_12(),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "6) Once done, click 'Update'",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10.0),

                    Text(
                      "Managing a rule whitelist",
                      style: titleStyle(),
                    ),
                    SuperRichText(
                      text:
                          "Managing whitelist for a particular rule is almost the same as managing the global whitelist. The difference is that it gets applied to a rule only.",
                      //style: white_12(),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "1) On the home page, click on the ",
                                ),
                                WidgetSpan(
                                  child: Icon(FlutterIcons.sound_mix_ent,
                                      size: 18, color: Colors.deepOrangeAccent),
                                ),
                                TextSpan(
                                  text:
                                      " next to the account's name which will takes you to the rules page",
                                ),
                              ],
                            ),
                          ),
                          SuperRichText(
                            text:
                                "2) Click on the name of the rule to go to 'Edit a rule' page",
                            //style: white_12(),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "3) At the bottom of the page next to the 'Whitelist symbols for this rule' click on ",
                                ),
                                WidgetSpan(
                                  child: Icon(Icons.edit,
                                      size: 18, color: Colors.deepOrangeAccent),
                                ),
                                TextSpan(
                                  text: " icon",
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "4) A page will be shown where you can add/delete symbols to/from the whitelist",
                                ),
                              ],
                            ),
                          ),
                          SuperRichText(
                            text:
                                "5) Leave the 'qty' field blank if you want to whitelist the entire holding.",
                            //style: white_12(),
                          ),
                          SuperRichText(
                            text:
                                "6) To remove a symbol, drag the symbol row to the left",
                            //style: white_12(),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "7) Once done, click 'Update'",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
