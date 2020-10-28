import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';
import "package:flutter/material.dart";
import 'package:WMR/services/apis.dart';
//import 'package:WMR/screens/providers/providers.dart';
import 'package:WMR/shared/loading.dart';
import 'package:WMR/shared/constants.dart';
import 'package:uuid/uuid.dart';
//import 'package:provider/provider.dart';

//import 'package:WMR/screens/home/home.dart';
//import 'package:WMR/models/accounts.dart';
//import 'package:marquee/marquee.dart';

//import 'package:WMR/shared/globals.dart' as globals;

class EditWatchlist extends StatefulWidget {
  final Map account;
  EditWatchlist({Key key, this.account}) : super(key: key);
  @override
  _EditWatchlistState createState() => _EditWatchlistState();
}

class _EditWatchlistState extends State<EditWatchlist> {
  final _formKey = GlobalKey<FormState>();
  //final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Map account;
  int count = 100;
  String accountType;
  String accountId;
  String token;
  String glSign = '';
  List holdings;
  bool sort = true;
  bool loading = true;
  bool showDollar = false;
  //bool _showFlushbar = true;
  String toDelete;
  Color dollarColor = dbColor;
  Color pctColor = gColor;

  var uuid = Uuid();

  TextEditingController _qcontroller = new TextEditingController();
  TextEditingController _pcontroller = new TextEditingController();
  TextEditingController _scontroller = new TextEditingController();

  String _price;
  String _qty;
  String _ticker;
  String _wlWarning;
  //String token;
  //bool _readAccount = true;
  Map rule;
  bool _showAdd = false;
  bool _listModified = false;

  Map<String, dynamic> editAcc;
  List<String> _row;
  //List<DataRow> _rowList = [];
  String portfolioValue;
  String totGL;
  String totPlpc;

  //Future<bool> checkUser;

  //Future<List> _holdings;

  @override
  void initState() {
    //_getHoldings();
    _updateWatchlist();
    super.initState();

    //getAccounts();
  }

  Future<Null> _updateWatchlist() async {
    print("Updating Totals");
    List myHoldings = [];
    //Map<String,dynamic> h = {};
    await updateWatchlist(widget.account).then((quotes) {
      //print("Quotes: $quotes");
      List wl = widget.account['watchlist'];
      double totPurchasePrice = 0;
      double totCurrentPrice = 0;
      wl.forEach((l) {
        //print("L:$l");
        Map<String, dynamic> h = {};
        h['ticker'] = l[0];
        h['qty'] = l[1];
        h['buy_price'] = l[2];
        h['name'] = l[3];
        h['asset_id'] = l[4];
        h['close'] = quotes[l[0]];
        double qty = double.parse(h['qty']);
        double buyPrice = double.parse(h['buy_price']);
        double price = h['close'];
        double plPc = 100 * (price - buyPrice) / buyPrice;
        double pl = qty * (price - buyPrice);
        totPurchasePrice += buyPrice * qty;
        totCurrentPrice += price * qty;
        h['pl_pc'] = plPc;
        h['pl'] = pl;
        myHoldings.add(h);
      });
      double myTotGL = (totCurrentPrice - totPurchasePrice);
      double myTotPlpc = 100 * (myTotGL / totPurchasePrice);

      setState(() {
        if (myTotGL < 0) {
          glSign = '-';
        }
        totGL = myTotGL.toStringAsFixed(1).replaceAll('-', '');
        totPlpc = myTotPlpc.toStringAsFixed(1);
        portfolioValue = totCurrentPrice.toStringAsFixed(1);
        holdings = myHoldings;
        loading = false;
      });
    });
  }

  bool _alert = false;

  //List<String> tickers = [];
  List<List<String>> data = [];
  //List<List<dynamic>> watchlist;
  List<dynamic> watchlist = [];
  //List data;
  List<String> titleColumn = ["Symbol", "QTY"];
  List<String> titleRow = [];
  final columns = 2;

  int rows = 1;

  void showInfoFlushbar(BuildContext context) {
    Flushbar(
      title: 'This action is prohibited',
      message: 'Lorem ipsum dolor sit amet',
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Colors.blue.shade300,
      ),
      leftBarIndicatorColor: Colors.blue.shade300,
      duration: Duration(seconds: 3),
    )..show(context);
  }

  void showInfoFlushbarHelper(BuildContext context) {
    FlushbarHelper.createInformation(
      title: 'This action is prohibited',
      message: 'Lorem ipsum dolor sit amet',
    ).show(context);
  }

  void showFloatingFlushbar(BuildContext context, String symbol) {
    Flushbar(
      // onTap: (flushbar) {
      //   print("Hi");
      // },
      messageText: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            //height: 30,
            alignment: Alignment.center,
            child: FlatButton(
              onPressed: () {
                _deleteRow(symbol);
              },
              child: Column(
                children: [
                  Text('Tap to remove $symbol',
                      style: TextStyle(color: Colors.white)),
                  SizedBox(height: 5.0),
                  Text(
                    'Drag down to dismiss',
                    style: white_10().copyWith(color: Colors.black),
                  )
                ],
              ),
            ),
          ),
          // Container(
          //   height: 20,
          //   alignment: Alignment.center,
          //   child: FlatButton(
          //     onPressed: () {

          //     },
          //     child: Text('Dismiss', style: TextStyle(color: Colors.black)),
          //   ),
          // ),
          // Text('ERREUR',
          //     style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          // Text('Hi there', style: TextStyle(color: Colors.lightBlue[50])),
          // Container(
          //   alignment: Alignment.bottomRight,
          //   child: FlatButton(
          //     onPressed: () {
          //       print("Pressed");
          //     },
          //     child: Text('Yes',
          //         style: TextStyle(color: Colors.lightBlue[500])),
          //   ),
          // ),
        ],
      ),
      //icon: Icon(Icons.warning),
      //padding: EdgeInsets.all(10),
      isDismissible: true,
      borderRadius: 8,
      backgroundGradient: LinearGradient(
        colors: [Colors.orange.shade800, Colors.orange.shade800],
        stops: [0.0, 1],
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      // All of the previous Flushbars could be dismissed by swiping down
      // now we want to swipe to the sides
      //dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      // The default curve is Curves.easeOut
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      //title: '',
      //title: 'Tap to delete $symbol',
      //message: ' ',

      //onTap: () => showFloatingFlushbar(context, h['ticker']),
    )..show(context);
  }

  void showFlushbar(BuildContext context) {
    Flushbar(
      // There is also a messageText property for when you want to
      // use a Text widget and not just a simple String
      message: 'Hello from a Flushbar',
      // Even the button can be styled to your heart's content
      mainButton: FlatButton(
        child: Text(
          'Click Me',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        onPressed: () {},
      ),
      duration: Duration(seconds: 3),
      // Show it with a cascading operator
    )..show(context);
  }

  Widget showGL() {
    if (holdings.isEmpty) {
      return SizedBox(height: 0);
    } else {
      Color c = Colors.green;
      if (glSign == '-') {
        c = Colors.red;
      }
      return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0, 10),
        child: Column(
          children: [
            Row(
              children: [
                Text("Total portfolio value:", style: infoStyle()),
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
    if (h['pl_pc'] < 0) {
      c = Colors.red;
    }
    if (showDollar) {
      return Text(h['pl'].toStringAsFixed(1),
          style: white_10().copyWith(color: c));
    } else {
      return Text(h['pl_pc'].toStringAsFixed(1),
          style: white_10().copyWith(color: c));
    }
  }

  Widget showUnit() {
    if (showDollar) {
      return Text(" \$", style: infoStyle().copyWith(fontSize: 12));
    } else {
      return Text(" %", style: infoStyle().copyWith(fontSize: 12));
    }
  }

  Widget showDelete() {
    if (toDelete == null) {
      return SizedBox(height: 0);
    } else {
      return Row(
        children: [
          Text("Delete $toDelete ?"),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  //side: BorderSide(color: Colors.red)
                ),
                color: Colors.grey[600],
                child: Text(
                  'Yes',
                  style: white_14().copyWith(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  print("Deleting $toDelete");
                }),
          ),
        ],
      );
    }
  }

  void _deleteRow(row) {
    for (int i = 0; i < watchlist.length; i++) {
      //print(watchlist[i][0]);
      //print(row);
      if (watchlist[i][0] == row) {
        //print("Here");
        watchlist.removeAt(i);
        //tickers.remove(row);
        //break;
      }
      _updateWatchlist();
      setState(() {
        _listModified = true;
        watchlist = watchlist;
      });
    }
  }

  void _addRow() async {
    // print("In Add Row1");
    // print("ROW:$_row");
    // print("WL:$watchlist");
    //print(tickers);
    if (watchlist.length > account['max_watchlist_count']) {
      _row = [];
      _scontroller.clear();
      _qcontroller.clear();
      _pcontroller.clear();
      _row = [];
      _wlWarning =
          'Number of symbols exceeds ${account['max_watchlist_count']}';
      return;
    }
    if ((_row[0] == null) || (_row[1] == null) || (_row[2] == null)) {
      _row = [];
      _scontroller.clear();
      _qcontroller.clear();
      _pcontroller.clear();
      _row = [];
      _wlWarning = 'Please fill out all fields';
      return;
    }
    rows++;

    //watchlist.forEach((w) {
    for (final w in watchlist) {
      if (w.length == 0) {
        continue;
      }
      if (w.contains(_row[0])) {
        //List newRow = [];
        double totShares = double.parse(_row[1]) + double.parse(w[1]);
        double totPrice = double.parse(_row[1]) * double.parse(_row[2]) +
            double.parse(w[1]) * double.parse(w[2]);
        double avgPps = totPrice / totShares;
        w[1] = totShares.toStringAsFixed(1);
        w[2] = avgPps.toStringAsFixed(1);
        //watchlist.insert(0, w);
        _updateWatchlist();
        //var t = _row[0];
        setState(() {
          _listModified = true;
          _wlWarning = null;
          _scontroller.clear();
          _qcontroller.clear();
          _pcontroller.clear();
          _row = [];
        });
        //_wlWarning = t + " is already in the watchlist.";
        return;
      }
    }
    getQuote(_row[0].toUpperCase()).then((ret) {
      //print("Name2: $name");
      String name = ret['symbol'];
      //double price = ret['price'];
      if (name != null) {
        //print("Here");
        //watchlist.add(_row);
        _row.add(name);
        var uid = uuid.v1().replaceAll('-', '');
        _row.add(uid);
        //_row.add(price.toString());
        //double buyPrice  = double.parse(_row[3]);
        //double plPc = 100 * (price - buyPrice) / buyPrice;
        //_row.add(plPc.toStringAsFixed(1));
        print(_row);
        watchlist.insert(0, _row);
        _updateWatchlist();

        //print("Watchlist:$watchlist");
        setState(() {
          _listModified = true;
          _wlWarning = null;
          _scontroller.clear();
          _qcontroller.clear();
          _pcontroller.clear();
          _row = [];
        });

        return;
      } else {
        setState(() {
          _wlWarning = _row[0] + " is not a valid symbol";
          _scontroller.clear();
          _qcontroller.clear();
          _pcontroller.clear();
          _row = [];
        });
      }
    });
  }

  bool numberValidator(String value) {
    if (value == null) {
      return false;
    }
    final n = num.tryParse(value);
    if (n <= 0) {
      return false;
    }
    return true;
  }

  // void _buildRows() {
  //   //print("Build Rows");
  //   _rowList = [];

  //   watchlist.forEach((row) {
  //     if (row[1] == null) {
  //       row[1] = 'all';
  //     }
  //     _rowList.add(DataRow(cells: <DataCell>[
  //       DataCell(
  //         Text(
  //           row[0],
  //           style: white_10().copyWith(fontWeight: FontWeight.bold),
  //         ),
  //         placeholder: true,
  //         onTap: () {
  //           print("Tapped");
  //         },
  //       ),
  //       DataCell(
  //         Text(
  //           row[1],
  //           style: white_10().copyWith(fontWeight: FontWeight.bold),
  //         ),
  //         placeholder: true,
  //       ),
  //       DataCell(
  //         Padding(
  //           padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
  //           child: IconButton(
  //             icon: new Icon(
  //               //Icons.remove_circle,
  //               Icons.delete_forever,
  //               color: Colors.red,
  //               size: 20.0,
  //             ),
  //             onPressed: () {
  //               //print("Pressed Delete");
  //               _deleteRow(row[0]);
  //               //setState(() => _rowToDelete = row[0]);
  //             },
  //           ),
  //         ),
  //       ),
  //     ]));
  //   });
  // }

  Future<bool> _showConfirmationDialog(
      BuildContext context, String action, String symbol) {
    return showDialog<bool>(
      context: context,
      //barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          //insetPadding: EdgeInsets.only(left:50),
          titleTextStyle: white_14(),
          title: Container(
              //color:Colors.red,
              alignment: Alignment.center,
              child: Text('Delete $symbol from the list?')),
          //title: Text('Do you want to $action this item?'),
          actions: <Widget>[
            Container(
              //padding: EdgeInsets.only(right:100),
              //color:Colors.red,
              alignment: Alignment.center,
              width: 400,
              //color:Colors.red,
              child: Row(

                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        'Yes',
                        style: errorStyle(),
                      ),
                      onPressed: () {
                        Navigator.pop(
                            context, true); // showDialog() returns true
                      },
                    ),
                    //SizedBox(width:100),

                    FlatButton(
                      child: Text('No', style: errorStyle()),
                      onPressed: () {
                        Navigator.pop(
                            context, false); // showDialog() returns false
                      },
                    ),

                    //SizedBox(width:100),
                  ]),
            )
          ],
        );
      },
    );
  }

  Widget showAddIcon() {
    if (_showAdd == true) {
      return IconButton(
          icon: Icon(Icons.clear),
          tooltip: 'Add a new symbol',
          color: Colors.deepOrangeAccent,
          onPressed: () {
            setState(() => _showAdd = false);
          });
    } else {
      return IconButton(
          icon: Icon(Icons.add),
          tooltip: 'Close',
          color: Colors.white,
          onPressed: () {
            setState(() => _showAdd = true);
          });
    }
  }

  Widget showWatchlist() {
    if (_alert == true) {
      return (SizedBox(height: 0.0));
    }

    if (watchlist.length == 0) return (SizedBox(height: 0.0));

    return ListView.builder(
        //shrinkWrap: true,
        //itemExtent: 80.0,
        scrollDirection: Axis.vertical,
        itemCount: watchlist.length,
        //itemCount: 1,
        //itemBuilder: (context, index) {

        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(watchlist[index][0]),
            direction: DismissDirection.endToStart,
            confirmDismiss: (DismissDirection dismissDirection) async {
              switch (dismissDirection) {
                case DismissDirection.endToStart:
                  return await _showConfirmationDialog(
                          context, 'delete', watchlist[index][0]) ==
                      true;
                // case DismissDirection.endToStart:
                //   return await _showConfirmationDialog(context, 'archive') == true;
                // case DismissDirection.startToEnd:
                //   return await _showConfirmationDialog(context, 'delete') == true;
                case DismissDirection.startToEnd:
                case DismissDirection.horizontal:
                case DismissDirection.vertical:
                case DismissDirection.up:
                case DismissDirection.down:
                  assert(false);
              }
              return false;
            },
            background: Container(
                alignment: AlignmentDirectional.centerEnd,
                //color:Colors.red,
                child: Icon(Icons.delete, color: Colors.red)),
            onDismissed: (direction) {
              setState(() {
                watchlist.removeAt(index);
                _listModified = true;
              });
            },
            child: _singleList(index),
          );

          //print(accountsSnap.data[index]['account_name']);
          // List wl = whitelist[index];
          // return _signleList(wl);
        });
  }

  Widget getName(h) {
    List name = h['name'].split(" ");
    if (name.length >= 3) {
      return (Text(
        "${name.sublist(0, 3).join(' ')}",
        style: white_10(),
      ));
    } else if (name.length >= 2) {
      return (Text(
        "${name.sublist(0, 2).join(' ')}",
        style: white_10(),
      ));
    }
    return (Text(
        "${name.join(' ')}",
        style: white_10(),
      ));

  }

  Widget _singleList(index) {
    List wl = watchlist[index];
    if (wl.length == 3) {
      wl.add('NA');
    }
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
              isThreeLine: true,
              dense: true,
              title: Text(wl[0], style: white14Bold()),
              subtitle: Text(
                wl[3],
                style: white_10(),
              ),
              trailing: Container(
                //color:Colors.red,
                width: w40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: w20,
                        //color: Colors.blue,
                        alignment: Alignment.topLeft,
                        child: Text(wl[1])),
                    //SizedBox(width:30),
                    Container(
                        width: w20,
                        //color: Colors.yellow,

                        alignment: Alignment.topLeft,
                        child: Text(wl[2])),
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

  Widget updateButton() {
    return (Text(
      'Done',
      style: white14Bold(),
    ));
  }

  Widget showDone() {
    if (_listModified == false) {
      return (SizedBox(height: 0));
    }
    return new FlatButton(
      child: Text("Done",
          style: titleStyle().copyWith(
            color: lbColor,
            // decoration: TextDecoration.underline
          )),
      onPressed: () async {
        //await editWatchlist(account);
        await editAccount(account);
        Navigator.pop(
          context,
        );
      },
    );
  }

  Widget showWarning() {
    if (_wlWarning != null) {
      return (Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Text(
              _wlWarning,
              style: TextStyle(fontSize: 16, color: Colors.red[900]),
              //maxLines: 1,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _wlWarning = null;
                  });
                },
              ),
            ))
          ])));
    } else {
      return (SizedBox(width: 0.0));
    }
  }

  Widget addToWatchlist() {
    //List<String> row = [];
    // String ticker;
    // String qty;
    // String price;
    _ticker = null;
    _qty = null;
    _price = null;
    if (_showAdd == false) {
      return (SizedBox(height: 0.0));
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10, 0, 20),
        child: Container(
          //width: infinity,
          height: h5,

          alignment: Alignment.center,
          child: (Row(
              //mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  width: 80,
                  child: new TextFormField(
                    controller: _scontroller,
                    autocorrect: false,
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.characters,
                    //initialValue: '',
                    // decoration: InputDecoration(
                    //   hintText: "symbol",
                    // ),

                    decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide:
                              new BorderSide(color: Colors.transparent)),
                      // hintText: 'Tell us about yourself',
                      // helperText: 'symbol',
                      labelText: 'symbol',
                      // prefixIcon: const Icon(
                      //   Icons.person,
                      //   color: Colors.green,
                    ),
                    // prefixText: ' ',
                    // suffixText: 'symbol',
                    //suffixStyle: const TextStyle(color: Colors.green)),

                    //validator: (val) => val.isEmpty ? 'Secret Key' : null,
                    //onChanged: (val) => setState(() => _ticker = val),
                    onChanged: (val) => _ticker = val.toUpperCase(),
                    // onChanged: (val) => row.add(val),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  alignment: Alignment.center,
                  width: w20,
                  //color:Colors.red,

                  child: new TextFormField(
                    controller: _qcontroller,
                    //initialValue: 'all',
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.red)),
                      //borderSide: new BorderSide(color: Colors.transparent)),
                      // hintText: 'Tell us about yourself',
                      // helperText: 'symbol',
                      labelText: 'qty',
                      // prefixIcon: const Icon(
                      //   Icons.person,
                      //   color: Colors.green,
                    ),
                    // prefixText: ' ',
                    // suffixText: 'symbol',
                    //suffixStyle: const TextStyle(color: Colors.green)),

                    onChanged: (val) => _qty = val,
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  alignment: Alignment.center,
                  width: w20,
                  //color:Colors.red,

                  child: new TextFormField(
                    controller: _pcontroller,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    autocorrect: false,
                    decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.red)),
                      labelText: 'price',
                    ),
                    onChanged: (val) => _price = val,
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  //width:w20,
                  child: IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    tooltip: 'Add to the watchlist',
                    color: Colors.white,
                    onPressed: () async {
                      _row = [];
                      _row.add(_ticker);
                      _row.add(_qty);
                      _row.add(_price);
                      _addRow();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ])),
        ),
      );
    }
  }

  // onSortColum(int columnIndex, bool ascending) {
  //   if (columnIndex == 0) {
  //     if (ascending) {
  //       holdings.sort((a, b) => a['ticker'].compareTo(b['ticker']));
  //     } else {
  //       holdings.sort((a, b) => b['ticker'].compareTo(a['ticker']));
  //     }
  //   }
  // }

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
        Container(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 3.0, 0, 0),
            child: Text("* To remove a position, click on the symbol",
                style: white_10()),
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
                      Text("Symbol", style: infoStyle().copyWith(fontSize: 12)),
                      Text("(qty @ price)",
                          style: infoStyle().copyWith(fontSize: 12)),
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
                    Text("Last", style: infoStyle().copyWith(fontSize: 12)),
                    Text("close", style: infoStyle().copyWith(fontSize: 12)),
                  ],
                ),
                //numeric: false,
                onSort: (columnIndex, ascending) {
                  setState(() {
                    if (sort)
                      holdings.sort((a, b) => a['close'].compareTo(b['close']));
                    else
                      holdings.sort((a, b) => b['close'].compareTo(a['close']));
                    sort = !sort;
                  });
                },
              ),
              DataColumn(
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("P/L", style: infoStyle().copyWith(fontSize: 12)),
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
                            getName(h),
                          ],
                        ),
                        showEditIcon: false,
                        placeholder: false,
                        //onTap: () => showFloatingFlushbar(context, h['ticker']),
                        onTap: () {
                      final snackBar = SnackBar(
                        content: Container(
                          height: 70,
                          alignment: Alignment.center,
                          child: FlatButton(
                            onPressed: () {
                              _deleteRow(h['ticker']);
                              _scaffoldKey.currentState.hideCurrentSnackBar();
                            },
                            child: Column(
                              children: [
                                Text('Tap here to remove ${h['ticker']}',
                                    style: TextStyle(color: Colors.white)),
                                SizedBox(height: 5.0),
                                FlatButton(
                                  child: Text("Dismiss"),
                                  onPressed: () {
                                    _scaffoldKey.currentState
                                        .hideCurrentSnackBar();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        backgroundColor: Colors.red[600],
                        elevation: 10,
                        // action:
                        // SnackBarAction(
                        //   label: "Click to delete ${h['ticker']}",
                        //   onPressed: () {
                        //     print("Deleting");
                        //   },
                        // ),
                        duration: Duration(seconds: 60),
                      );
                      _scaffoldKey.currentState.showSnackBar(snackBar);
                    }
                        //     onTap: () {

                        //   print('delete ${h['ticker']}');
                        //   setState(() => toDelete = h['ticker']);
                        // }
                        ),
                    // DataCell(
                    //   Text(h['qty'].toString()),
                    // ),
                    DataCell(Container(
                      //width: 50, //SET width
                      child: Text(h['close'].toStringAsFixed(1),
                          style: white_10()),
                    )),

                    DataCell(showPL(h)
                        //])
                        //showPL(h),
                        ),
                  ]),
                )
                .toList(),
          ),
        ),
        //SizedBox(height: 3,),
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

  @override
  Widget build(BuildContext context) {
    // dynamic wp = Provider.of<WmrProviders>(context);
    // token = wp.getToken;

    account = widget.account;
    watchlist = account['watchlist'];
    //_updateWatchlist();
    //print("Watchlist:$watchlist");
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
            // body: Container(
            //   padding: EdgeInsets.fromLTRB(5, 20, 5, 20),
            //   child: bodyData(),

            body: Builder(
              builder: (context) => SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                          child: Column(
                            children: <Widget>[
                              showWarning(),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Current holdings (${watchlist.length})",
                                        textAlign: TextAlign.left,
                                        style: infoStyle(),
                                      ),
                                      showAddIcon(),
                                      showDone(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      addToWatchlist(),
                      //showHeading(),
                      showGL(),
                      bodyData(),
                      //showDelete(),
                      // Padding(
                      //   padding: const EdgeInsets.all(20.0),
                      //   child: Text("* To remove, click on the symbol",
                      //       style: white_10()),
                      // ),
                    ]),
              ),
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
}
