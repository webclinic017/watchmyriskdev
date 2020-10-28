import "package:flutter/material.dart";
import 'package:WMR/services/apis.dart';
//import 'package:WMR/screens/providers/providers.dart';
import 'package:WMR/shared/loading.dart';
import 'package:WMR/shared/constants.dart';
//import 'package:provider/provider.dart';

//import 'package:WMR/screens/home/home.dart';
//import 'package:WMR/models/accounts.dart';
//import 'package:marquee/marquee.dart';

//import 'package:WMR/shared/globals.dart' as globals;

class Holdings extends StatefulWidget {
  final Map account;
  Holdings({Key key, this.account}) : super(key: key);
  @override
  _HoldingsState createState() => _HoldingsState();
}

class _HoldingsState extends State<Holdings> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Map account;
  int count = 100;
  String accountType;
  String accountId;
  String token;
  String glSign = '';
  List holdings;
  bool sort = true;
  bool showDollar = false;
  bool loading = true;

  String portfolioValue;
  String totGL;
  String totPlpc;
  //Future<bool> checkUser;

  //Future<List> _holdings;

  @override
  void initState() {
    _getHoldings();
    super.initState();

    //getAccounts();
  }

  Future<Null> _getHoldings() async {
    final ret = await getHoldings(widget.account);
    double totPurchasePrice = 0;
    double totCurrentPrice = 0;
    ret.forEach((l) {
      //print(l);
      //double qty = double.parse(l['qty']);
      double qty = l['qty'];
      double buyPrice = l['buy_price'];
      double price = l['current_price'];
      totPurchasePrice += buyPrice * qty;
      totCurrentPrice += price * qty;
    });

    double myTotGL = (totCurrentPrice - totPurchasePrice);
    double myTotPlpc = 100 * (myTotGL / totPurchasePrice);

    setState(() {
      if (myTotGL < 0) { 
        glSign='-';
        }
      totGL = myTotGL.toStringAsFixed(1).replaceAll('-', '');
      totPlpc = myTotPlpc.toStringAsFixed(1);
      portfolioValue = totCurrentPrice.toStringAsFixed(1);
      holdings = ret;
      loading = false;
    });
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        holdings.sort((a, b) => a['ticker'].compareTo(b['ticker']));
      } else {
        holdings.sort((a, b) => b['ticker'].compareTo(a['ticker']));
      }
    }
  }

  Widget showGL() {
    if (holdings.isEmpty) {
      return SizedBox(height:0);
    } else {
    Color c = Colors.green;
    if (glSign == '-') {
      c = Colors.red;
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0,40.0,0,10),
      child: Column(
        children: [
          Row(
            children: [
              Text("Total portfolio value ",style: infoStyle()),
              Text("(excluding cash):", style: white_10().copyWith(fontSize:10)),
              Text(" \$${portfolioValue.toString()}",
                  style: infoStyle().copyWith(fontSize: 14, color: c))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text("Total Gain/Loss:", style: infoStyle()),
              Text(" $glSign\$${totGL.toString()} (${totPlpc.toString()}%)",
                  style: infoStyle().copyWith(fontSize: 14, color: c))
            ],
          ),
        ],
      ),
    );
    }
  }

  Widget showPL(h) {
    Color c = gColor;
    if(h['pl_pc'] < 0) {c = Colors.red;}
    if (showDollar) {
      return Text(h['pl'].toStringAsFixed(1), style: white_10().copyWith(color:c));
    } else {
      return Text(h['pl_pc'].toStringAsFixed(1), style: white_10().copyWith(color:c));
    }
  }
 
Widget showUnit() {
    if (showDollar) {
      return Text(" \$", style: infoStyle().copyWith(fontSize:12));
    } else {
      return Text(" %", style: infoStyle().copyWith(fontSize:12));
    }
  }

  Widget bodyData() {
    if ((holdings == null) | (holdings.length == 0)) {
      return SizedBox(
        height: 0,
      );
    }
    // if (holdings.length == 0) {
    //   return Text("No stock holdings yet!", style: titleStyle());
    // }
    //print("Bbb: Holdings $holdings");

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 5, 0, 0),
          child: Row(
            children: [
              Text(
                "Show P/L in dollar value",
                style: white_12(),
              ),
              Checkbox(
                value: showDollar,
                onChanged: (value) {
                  setState(() {
                    showDollar = value;
                  });
                },
                //  activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.transparent,
                checkColor: lbColor,
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          child: DataTable(
            //onSelectAll: (b) {},
            //sortColumnIndex: 0,
            //showCheckboxColumn: true,
            sortAscending: sort,
            // sortAscending: sort,
            // sortColumnIndex: 0,

            columns: [
              //  DataColumn(
              //     label: Text("Symbol (qty)", style:TextStyle(color: gColor)),
              //     numeric: false,
              //     onSort: (columnIndex, ascending) {
              //       setState(() {
              //           sort = !sort;
              //       });
              //       onSortColum(columnIndex, ascending);
              //     }
              //  ),

              DataColumn(
                label: Container(
                  //color: Colors.red,
                  //width:w20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Symbol", style: infoStyle().copyWith(fontSize:12)),
                      Text("(qty @ price)", style: infoStyle().copyWith(fontSize:12)),
                    ],
                  ),
                ),
                numeric: false,
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (sort)
                      holdings
                          .sort((a, b) => a['ticker'].compareTo(b['ticker']));
                    else
                      holdings
                          .sort((a, b) => b['ticker'].compareTo(a['ticker']));
                    sort = !sort;
                  });
                },
                //tooltip: "",
              ),

              //  DataColumn(
              //     label: Text("Qty"),
              //     numeric: false,
              //    ),
              DataColumn(
                label: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Last", style: infoStyle().copyWith(fontSize:12)),
                    Text("close", style: infoStyle().copyWith(fontSize:12)),
                  ],
                ),
                //numeric: false,
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (sort)
                      holdings.sort((a, b) =>
                          a['current_price'].compareTo(b['current_price']));
                    else
                      holdings.sort((a, b) =>
                          b['current_price'].compareTo(a['current_price']));
                    sort = !sort;
                  });
                },
              ),
              DataColumn(
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("P/L", style: infoStyle().copyWith(fontSize:12)),
                      SizedBox(
                        height: 3,
                      ),
                      showUnit(),
                      // Row(
                      //   children: [
                      //     GestureDetector(
                      //         child: Text("\%",
                      //             style:
                      //                 white14Bold().copyWith(color: pctColor)),
                      //         onTap: () {
                      //           setState(() {
                      //             showDollar = false;
                      //             dollarColor = dbColor;
                      //             pctColor = gColor;
                      //           });
                      //         }),
                      //     SizedBox(
                      //       width: 6,
                      //     ),
                      //     GestureDetector(
                      //         child: Text("\$",
                      //             style: white14Bold()
                      //                 .copyWith(color: dollarColor)),
                      //         onTap: () {
                      //           setState(() {
                      //             showDollar = true;
                      //             dollarColor = gColor;
                      //             pctColor = dbColor;
                      //           });
                      //         }),
                      //   ],
                      // ),
                    ],
                  ),
                  //numeric: false,
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (sort) {
                        if (showDollar) {
                          holdings.sort((a, b) => a['pl'].compareTo(b['pl']));
                        } else {
                          holdings
                              .sort((a, b) => a['pl_pc'].compareTo(b['pl_pc']));
                        }
                      } else if (showDollar) {
                        holdings.sort((a, b) => b['pl'].compareTo(a['pl']));
                      } else {
                        holdings
                            .sort((a, b) => b['pl_pc'].compareTo(a['pl_pc']));
                      }
                      sort = !sort;
                    });
                  }),
            ],

            rows: holdings
                .map(
                  (h) => DataRow(cells: [
                    DataCell(
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${h['ticker']} (${h['qty']} \@ ${h['buy_price']})",
                                style: white_10()),
                            // Text(
                            //   //"${h['name'].split(" ").sublist(0, 2).join(' ')}",
                            //   style: white_10(),
                            // ),
                          ],
                        ),
                        showEditIcon: false,
                        placeholder: false,
                        //onTap: () => showFloatingFlushbar(context, h['ticker']),
                    //     onTap: () {
                    //   print("Tapped");
                    // }
                        //   final snackBar = SnackBar(
                        //     content: Container(
                        //       height: 100,
                        //       alignment: Alignment.center,
                        //       child: FlatButton(
                        //         onPressed: () {
                        //           print("Sell");
                        //           _scaffoldKey.currentState.hideCurrentSnackBar();
                        //         },
                        //         child: Column(
                        //           children: [
                        //             Text('Tap here to sell ${h['qty']} shares of ${h['ticker']} @ market',
                        //                 style: white_12()),
                        //             SizedBox(height: 5.0),
                        //             FlatButton(
                        //               child: Text("Dismiss"),
                        //               onPressed: () {
                        //                 _scaffoldKey.currentState
                        //                     .hideCurrentSnackBar();
                        //               },
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //     backgroundColor: Colors.red[600],
                        //     elevation: 10,
                        //     // action:
                        //     // SnackBarAction(
                        //     //   label: "Click to delete ${h['ticker']}",
                        //     //   onPressed: () {
                        //     //     print("Deleting");
                        //     //   },
                        //     // ),
                        //     duration: Duration(seconds: 60),
                        //   );
                        //   _scaffoldKey.currentState.showSnackBar(snackBar);
                        // }
                        //     onTap: () {

                        //   print('delete ${h['ticker']}');
                        //   setState(() => toDelete = h['ticker']);
                        // }
                        ),
                    // DataCell(
                    //   Text(h['qty'].toString()),
                    // ),
                    DataCell(Container(
                      alignment: Alignment.centerLeft,
                      //width: 50, //SET width
                      child: Text(h['current_price'].toStringAsFixed(1),
                          style: white_10()),
                    )),

                    DataCell(Container(
                            alignment: Alignment.centerLeft, child: showPL(h))
                        //])
                        //showPL(h),
                        ),
                  ]),
                )
                .toList(),
          ),
        ),
        //SizedBox(height: 3,),
        // Container(
        //   alignment: Alignment.topLeft,
        //   child: Padding(
        //                 padding: const EdgeInsets.fromLTRB(30.0,3.0,0,0),
        //                 child: Text("* To sell, click on the symbol",
        //                     style: white_10()),
        //               ),
        // ),
      ],
    );

    // onSelectAll: (b) {},
    // sortColumnIndex: 1,
    // sortAscending: true,
    // columns: <DataColumn>[
    //   DataColumn(
    //     label: Text("First Name"),
    //     numeric: false,
    //     onSort: (i, b) {
    //       print("$i $b");
    //       setState(() {
    //         holdings.sort((a, b) => a.ticker.compareTo(b.ticker));
    //       });
    //     },
    //     tooltip: "To display first name of the Name",
    //   ),
    //   DataColumn(
    //     label: Text("Last Name"),
    //     numeric: false,
    //     onSort: (i, b) {
    //       print("$i $b");
    //       setState(() {
    //         holdings.sort((a, b) => a.pl_pc.compareTo(b.pl_pc));
    //       });
    //     },
    //     tooltip: "To display last name of the Name",
    //   ),
    // ],
    // rows: holdings
    //     .map(
    //       (name) => DataRow(
    //             cells: [
    //               DataCell(
    //                 Text(name.ticker),
    //                 showEditIcon: false,
    //                 placeholder: false,
    //               ),
    //               DataCell(
    //                 Text(name.plpc),
    //                 showEditIcon: false,
    //                 placeholder: false,
    //               )
    //             ],
    //           ),
    //     )
    //     .toList());
  }

  Widget bodyData1() {
    if (holdings == null) {
      return SizedBox(
        height: 0,
      );
    }
    if (holdings.length == 0) {
      return Text("No stock holdings yet!", style: titleStyle());
    }
    print("Bbb: Holdings $holdings");

    return SingleChildScrollView(
      child: DataTable(
          //onSelectAll: (b) {},
          //sortColumnIndex: 0,
          sortAscending: sort,
          // sortAscending: sort,
          // sortColumnIndex: 0,

          columns: [
            //  DataColumn(
            //     label: Text("Symbol (qty)", style:TextStyle(color: gColor)),
            //     numeric: false,
            //     onSort: (columnIndex, ascending) {
            //       setState(() {
            //           sort = !sort;
            //       });
            //       onSortColum(columnIndex, ascending);
            //     }
            //  ),

            DataColumn(
              label: Container(
                //color: Colors.red,
                //width:w20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Symbol", style: TextStyle(color: gColor)),
                    Text("(qty)", style: TextStyle(color: gColor)),
                  ],
                ),
              ),
              numeric: false,
              onSort: (columnIndex, ascending) {
                setState(() {
                  if (sort)
                    holdings.sort((a, b) => a['ticker'].compareTo(b['ticker']));
                  else
                    holdings.sort((a, b) => b['ticker'].compareTo(a['ticker']));
                  sort = !sort;
                });
              },
              //tooltip: "",
            ),

            //  DataColumn(
            //     label: Text("Qty"),
            //     numeric: false,
            //    ),
            DataColumn(
              label: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Buy", style: TextStyle(color: gColor)),
                  Text("Price", style: TextStyle(color: gColor)),
                ],
              ),
              //numeric: false,
              onSort: (columnIndex, ascending) {
                setState(() {
                  if (sort)
                    holdings.sort(
                        (a, b) => a['buy_price'].compareTo(b['buy_price']));
                  else
                    holdings.sort(
                        (a, b) => b['buy_price'].compareTo(a['buy_price']));
                  sort = !sort;
                });
              },
            ),
            DataColumn(
                label: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("P/L", style: TextStyle(color: gColor)),
                    Text("(%)", style: TextStyle(color: gColor)),
                  ],
                ),
                //numeric: false,
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (sort)
                      holdings.sort((a, b) => a['pl_pc'].compareTo(b['pl_pc']));
                    else
                      holdings.sort((a, b) => b['pl_pc'].compareTo(a['pl_pc']));
                    sort = !sort;
                  });
                }),
          ],
          rows: holdings
              .map(
                (h) => DataRow(cells: [
                  DataCell(
                    Text("${h['ticker']} (${h['qty']})"),
                    showEditIcon: false,
                    placeholder: false,
                  ),
                  // DataCell(
                  //   Text(h['qty'].toString()),
                  // ),
                  DataCell(
                    Text(h['buy_price'].toString()),
                  ),
                  DataCell(
                    Text(h['pl_pc'].toString()),
                  ),
                ]),
              )
              .toList()),
    );
    // onSelectAll: (b) {},
    // sortColumnIndex: 1,
    // sortAscending: true,
    // columns: <DataColumn>[
    //   DataColumn(
    //     label: Text("First Name"),
    //     numeric: false,
    //     onSort: (i, b) {
    //       print("$i $b");
    //       setState(() {
    //         holdings.sort((a, b) => a.ticker.compareTo(b.ticker));
    //       });
    //     },
    //     tooltip: "To display first name of the Name",
    //   ),
    //   DataColumn(
    //     label: Text("Last Name"),
    //     numeric: false,
    //     onSort: (i, b) {
    //       print("$i $b");
    //       setState(() {
    //         holdings.sort((a, b) => a.pl_pc.compareTo(b.pl_pc));
    //       });
    //     },
    //     tooltip: "To display last name of the Name",
    //   ),
    // ],
    // rows: holdings
    //     .map(
    //       (name) => DataRow(
    //             cells: [
    //               DataCell(
    //                 Text(name.ticker),
    //                 showEditIcon: false,
    //                 placeholder: false,
    //               ),
    //               DataCell(
    //                 Text(name.plpc),
    //                 showEditIcon: false,
    //                 placeholder: false,
    //               )
    //             ],
    //           ),
    //     )
    //     .toList());
  }

  @override
  Widget build(BuildContext context) {
    // dynamic wp = Provider.of<WmrProviders>(context);
    // token = wp.getToken;
    account = widget.account;
    //print("BB Holdings:$holdings");
    //accountType = account['type'];
    //accountId = account['account_id'];

    // dynamic ptoken = Provider.of<WmrProviders>(context);
    // token = ptoken.getToken;

    return loading
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            //backgroundColor: bgColor,
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              centerTitle: true,
              title: Column(
                children: <Widget>[
                  Text(
                    "Holdings",
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
            body: Builder(
              builder: (context) => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    
                    
                    //showHeading(),
                    showGL(),
                    bodyData(),
                    //showDelete(),
                    // Padding(
                    //   padding: const EdgeInsets.all(20.0),
                    //   child: Text("* To remove, click on the symbol",
                    //       style: white_10()),
                    // ),
                    //showGL(),
                  ]),
            ));

    //_showTrTable(),
  }

  Widget showHeading() {
    return Container(
      width: double.infinity,
      child: (Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0.0),
        child: Column(
          children: [
            Row(
                //mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(child: new Text("Symbol (qty)")),

                  //SizedBox(width:30.0),
                  Expanded(
                    child: SizedBox(
                        //width: w30,
                        //child: new Text("Hi"),
                        child: new Text("Purchase price")),
                  ),

                  Expanded(
                    child: SizedBox(
                      //width: w1,
                      //child: new Text("Hi"),
                      child: new Text("P/L %"),
                    ),
                  )
                ]),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  //color:Colors.red,
                  alignment: Alignment.centerLeft,
                  width: 280,
                  child: Divider(color: Colors.white),
                ),
              ],
            ),
            //SizedBox(height:50.0)
          ],
        ),
      )),
    );
  }

  Widget _singleTrWidget(context, h) {
    //print("H: $h");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      //mainAxisSize: MainAxisSize.max,
      //mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          //onTap: widget.onSelect,
          onTap: () {
            print("Tapped");
          },

          child: Container(
            //color:Colors.red,
            padding: EdgeInsets.fromLTRB(5, 0, 20, 0),
            //width: w80,
            child: ListTile(
              //isThreeLine: true,
              dense: true,
              title: showSymbol(context, h),
              subtitle: Text(''),
              //   h[''].toString(),
              //   style: white_10(),
              // ),
              trailing: Container(
                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                //clor:Colors.red,
                width: w60,
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        width: w30,
                        //color: Colors.blue,
                        alignment: Alignment.topLeft,
                        child: Text(h['buy_price'].toString())),
                    //SizedBox(width:30),
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        width: w20,
                        //color: Colors.yellow,

                        alignment: Alignment.topLeft,
                        child: Text(h['pl_pc'].toString())),
                  ],
                ),
              ),
              //leading: Text(wl[0]),
            ),
          ),
        ),
      ],
    );
  }

  Widget showSymbol(context, h) {
    //print(tr);

    String sym = "${h['ticker']} (${h['qty'].toInt().toString()}) ";
    return Text(sym);
    // return GestureDetector(
    //     onTap: () async {
    //       //print("Tapped");

    //       await Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                   builder: (context) =>
    //                       ShowHolding(h),
    //                 ));
    //     },
    //     child: Text(sym, style: white14Bold()));
  }

  Widget trWidget(account) {
    //print("Here In Transaction Widget $accountType");
    return FutureBuilder(
      builder: (context, transactionsSnap) {
        if (transactionsSnap.data == null) {
          return Loading();
        }
        return ListView.builder(
          itemCount: transactionsSnap.data.length,
          //itemCount: 1,
          itemBuilder: (context, index) {
            //print(accountsSnap.data[index]['account_name']);
            Map h = transactionsSnap.data[index];
            return _singleTrWidget(context, h);
          },
        );
      },
      future: getHoldings(account),
    );
  }
}
