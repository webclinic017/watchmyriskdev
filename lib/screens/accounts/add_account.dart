import 'package:WMR/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:WMR/screens/accounts/brokers/alpaca.dart';
import 'package:WMR/screens/accounts/brokers/robinhood.dart';
import 'package:WMR/screens/accounts/addPortfolio.dart';

//import 'package:WMR/screens/accounts/watchlist.dart';
import 'package:WMR/shared/loading.dart';
//import 'package:WMR/shared/constants.dart';

// import 'package:provider/provider.dart';
// import 'package:WMR/screens/rules/providers.dart';

class AddAccount extends StatefulWidget {
  final List accountNames;
  AddAccount({Key key, @required this.accountNames}) : super(key: key);
  @override
  _AddAccountState createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    // dynamic ptoken = Provider.of<WmrProviders>(context);
    // String token = ptoken.getToken;

    // void _showWatchlistForm() {
    //   showModalBottomSheet(context: context, builder: (context) {
    //     return Container(

    //       child: WatchlistForm(),
    //     );
    //   });
    // }

    // void _showAlpacaForm() {
    //   showModalBottomSheet(
    //       context: context,
    //       builder: (context) {
    //         return Container(
    //           //height: double.infinity,
    //           //transform: Matrix4.rotationZ(pi / 4),
    //           //padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
    //           //decoration: BoxDecoration(color: Colors.yellowAccent),
    //           //     decoration: BoxDecoration(
    //           //   color: Colors.yellow,
    //           //   border: Border.all(color: Colors.black, width: 3),
    //           // ),
    //           child: AlpacaForm(),
    //         );
    //       });
    // }

    // void _showRobinhoodForm() {
    //   showModalBottomSheet(
    //       context: context,
    //       builder: (context) {
    //         return Container(
    //           child: RobinhoodForm(),
    //         );
    //       });
    // }

    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: true,
            //backgroundColor: Colors.grey[100],
            appBar: AppBar( centerTitle: true,
              title: Text('Add Accounts', style: white14Bold(),),
              //backgroundColor: Colors.blueAccent,
              elevation: 0.0,
            ),
            body: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(20),

              //child: GridView.count(
              child: 
              SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                  // scrollDirection: Axis.vertical,
                  // primary: false,
                  // padding: const EdgeInsets.all(10),
                  // crossAxisSpacing: 0,
                  // mainAxisSpacing: 0,
                  // crossAxisCount: 1,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          
                          GestureDetector(
                            onTap: () {
                              //_showRobinhoodForm();
                              //print("Tapped for Robinhood");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddPortfolio(wlNames:widget.accountNames),
                                ),
                              );
                            }, // handle your image tap here
                            child: 
                            Row(
                              children: [
                                Image.asset(
                                  'assets/manualPortfolio.png',
                                  width:60,
                                  height:60,

                                  //fit: BoxFit.cover, // this is the solution for border
                                  // width: 3.0,
                                  // height: 1.0,
                                ),
                                Text(
                            "Manual Portfolio",
                            style: titleStyle().copyWith(fontSize: 24)
                            ),
                              ],
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              //_showRobinhoodForm();
                              //print("Tapped for Robinhood");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RobinhoodForm(),
                                ),
                              );
                            }, // handle your image tap here
                            child: Image.asset(
                              'assets/Robinhood.png',
                              

                              //fit: BoxFit.cover, // this is the solution for border
                              
                            ),
                          ),
                          // Text(
                          //   "Robinhood",
                          //   style: titleStyle()
                          //   ),
                        ],
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              //_showRobinhoodForm();
                              //print("Tapped for Robinhood");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AlpacaForm(),
                                ),
                              );
                            }, // handle your image tap here
                            child: Image.asset(
                              'assets/alpaca3.png',
                              //width:300,
                              height:80,
                              //fit: BoxFit.cover, // this is the solution for border
                              
                            ),
                          ),
                          // Text(
                          //   "Alpaca",
                          //   style: titleStyle()
                          //   ),
                          SizedBox(height: 3,),
                          Text(
                            "* For testing purposes, Alpaca supports creating a paper trading account.",
                            style: white_10(),
                          )
                        ],
                      ),
                    ),
                    // InkWell(
                    //         // constraints: BoxConstraints.expand(height: 100, width: 100),
                    //         // alignment: Alignment.center,
                    //         onTap: () => _showAlpacaForm(),
                    //         child: Image.asset(
                    //         "assets/alpaca.jpg",
                    //         fit: BoxFit.cover,
                    //         width:100,
                    //         //height:30,
                    //         ),
                    //       ),
                  ],
                ),
              ),
              // SizedBox(height: 50.0),
              // InkWell(
              //         // constraints: BoxConstraints.expand(height: 100, width: 100),
              //         // alignment: Alignment.center,
              //         onTap: () => _showWatchlistForm(),
              //         child: Image.asset(
              //         "assets/watchlist.jpg",
              //         fit: BoxFit.cover,
              //         width:60,
              //         height:60,
              //         ),
              //       ),

              // RaisedButton(
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10.0),
              //       //side: BorderSide(color: Colors.red)
              //     ),
              //   color: Colors.grey[600],
              //       child: Text(
              //         'Add a watchlist',
              //         style: white_14().copyWith(fontWeight: FontWeight.bold),
              //       ),
              //     onPressed: () async {

              //   //if(_formKey.currentState.validate()){
              //     // await editAccount(token,account);
              //     // Navigator.pop(context);

              //   }

              // ),
            ),
          );
  }
}
