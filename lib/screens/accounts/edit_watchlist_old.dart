import 'package:WMR/screens/rules/rules.dart';
import 'package:WMR/shared/loading.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
// import 'package:WMR/screens/accounts/brokers/alpaca.dart';
import 'package:WMR/services/apis.dart';
//import 'package:WMR/shared/loading.dart';
import 'package:WMR/shared/constants.dart';
//import 'package:WMR/shared/globals.dart' as globals;

class EditWatchlist extends StatefulWidget {
  final Map account;
  EditWatchlist({Key key, this.account}) : super(key: key);
  @override
  _EditWatchlistState createState() => _EditWatchlistState();
}

class _EditWatchlistState extends State<EditWatchlist> {
  final _formKey = GlobalKey<FormState>();
  var uuid = Uuid();
  bool loading = true;
  Map account;
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
  List<DataRow> _rowList = [];
  List<Map<String,dynamic>> holdings=[];
  //  DataRow(cells: <DataCell>[
  //   DataCell(Text('AAAAAA')),
  //   DataCell(Text('1')),
  //   DataCell(Text('Yes')),
  // ]),

  //String error;

  @override
  void initState() {
    //_getHoldings();
    _updateWatchlist();
    super.initState();

    //getAccounts();
  }
  Future<Null> _updateWatchlist() async {
    List myHoldings=[];
    //Map<String,dynamic> h = {};
    await updateWatchlist(widget.account).then((quotes) {
      //print("Quotes: $quotes");
    List wl = widget.account['watchlist'];
    wl.forEach((l){
      //print("L:$l");
      Map<String, dynamic> h = {};
      h['ticker'] = l[0];
      h['qty'] = l[1];
      h['buy_price'] = l[2];
      h['name'] = l[3];
      h['asset_id'] = l[4];
      h['close'] = quotes[l[0]].toString();
      double buyPrice  = double.parse(h['buy_price']);
      double price = double.parse(h['close']);
      double plPc = 100 * (price - buyPrice) / buyPrice;
      h['pl_pc'] = plPc.toStringAsFixed(1);
      myHoldings.add(h);
    }); 
    setState(() {
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

      setState(() {
        _listModified = true;
        watchlist = watchlist;
      });
      _buildRows();
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
        var t = _row[0];
        _scontroller.clear();
        _qcontroller.clear();
        _pcontroller.clear();
        _row = [];
        _wlWarning = t + " is already in the watchlist.";
        return;
      }
    }
    getQuote(_row[0].toUpperCase()).then((ret) {
      //print("Name2: $name");
      String name = ret['symbol'];
      double price = ret['price'];
      if (name != null) {
        //print("Here");
        //watchlist.add(_row);
        _row.add(name);
        var uid = uuid.v1().replaceAll('-', '');
        _row.add(uid);
        _row.add(price.toString());
        double buyPrice  = double.parse(_row[3]);
        double plPc = 100 * (price - buyPrice) / buyPrice;
        _row.add(plPc.toStringAsFixed(1));
        //print(_row);
        watchlist.insert(0, _row);

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

  void _buildRows() {
    //print("Build Rows");
    _rowList = [];

    watchlist.forEach((row) {
      if (row[1] == null) {
        row[1] = 'all';
      }
      _rowList.add(DataRow(cells: <DataCell>[
        DataCell(
          Text(
            row[0],
            style: white_10().copyWith(fontWeight: FontWeight.bold),
          ),
          placeholder: true,
          onTap: () {
            print("Tapped");
          },
        ),
        DataCell(
          Text(
            row[1],
            style: white_10().copyWith(fontWeight: FontWeight.bold),
          ),
          placeholder: true,
        ),
        DataCell(
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
              icon: new Icon(
                //Icons.remove_circle,
                Icons.delete_forever,
                color: Colors.red,
                size: 20.0,
              ),
              onPressed: () {
                //print("Pressed Delete");
                _deleteRow(row[0]);
                //setState(() => _rowToDelete = row[0]);
              },
            ),
          ),
        ),
      ]));
    });
  }

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

  Widget showUpdate() {
    if (_alert == true) {
      return (SizedBox(height: 0));
    }
    return Container(
      padding: EdgeInsets.fromLTRB(30, 5, 5, 0),
      //color:Colors.red,
      alignment: Alignment.centerLeft,
      child: (Row(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  //side: BorderSide(color: Colors.red)
                ),
                color: Colors.grey[600],
                child: Text(
                  'Cancel',
                  style: white_14().copyWith(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            SizedBox(
              width: w30,
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                //side: BorderSide(color: Colors.red)
              ),
              color: Colors.grey[600],
              child: updateButton(),
              onPressed: () async {
                //if(_formKey.currentState.validate()){
                // print(watchlist);
                // print(account);
                //account['wl'] = watchlist;
                editWatchlist(account);

                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Rules(account: account),
                    ));
              },
            )
          ])),
    );
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
                  Expanded(child: new Text("Symbol")),

                  //SizedBox(width:30.0),
                  Expanded(
                    child: SizedBox(
                        //width: w20,
                        //child: new Text("Hi"),
                        child: new Text("           Qty")),
                  ),

                  Expanded(
                    child: SizedBox(
                      //width: w1,
                      //child: new Text("Hi"),
                      child: new Text("Price"),
                    ),
                  )
                ]),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  //color:Colors.red,
                  alignment: Alignment.centerLeft,
                  width: 270,
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

  @override
  Widget build(BuildContext context) {
    account = widget.account;
    //_updateWatchlist();
    watchlist = account['watchlist'];
    print("Holdings: $holdings");
    // if (watchlist.length > 0 ) {
    //   if (watchlist[0].length < 7) {
    //       loading = true;
    //   }
    // }

    return loading
        ? Loading():GestureDetector( 
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
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
            //leading: IconButton (icon:Icon(Icons.arrow_back)),
            // leading: new IconButton(
            //   icon: new Icon(Icons.arrow_back),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => Home()),
            //     );
            //   },
            // ),

            //centerTitle: true,
            automaticallyImplyLeading: true,

            //backgroundColor: Colors.black,
            elevation: 0.0,
          ),

          resizeToAvoidBottomInset: true,
          body: Column(
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
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              children: [
                                Text(
                                  "Current holdings (${watchlist.length})",
                                  textAlign: TextAlign.left,
                                  style: titleStyle().copyWith(color: gColor),
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

                //showUpdate(),
                //showWatchlist(),

                showHeading(),
                Expanded(child: showWatchlist()),
              ]),
          // floatingActionButton: FloatingActionButton(
          //     onPressed: ()  {
          //       _setAlert();

          //       },
          //     tooltip: 'Delete the watchlist',
          //     child: Icon(
          //       Icons.delete,
          //       color:Colors.red,
          //       ),
          //   ),
        ));
  }
}
