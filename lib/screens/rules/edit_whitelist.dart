import 'package:WMR/screens/rules/rules.dart';
import 'package:flutter/material.dart';
// import 'package:WMR/screens/accounts/brokers/alpaca.dart';
import 'package:WMR/services/apis.dart';
//import 'package:WMR/shared/loading.dart';
import 'package:WMR/shared/constants.dart';
//import 'package:WMR/shared/globals.dart' as globals;
import 'package:WMR/models/accounts.dart';
import 'package:flutter_icons/flutter_icons.dart';

class EditWhiteList extends StatefulWidget {
  @override
  _EditWhiteListState createState() => _EditWhiteListState();
}

class _EditWhiteListState extends State<EditWhiteList> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  Map account;
  TextEditingController _qcontroller = new TextEditingController();
  //TextEditingController _pcontroller = new TextEditingController();
  TextEditingController _scontroller = new TextEditingController();

  //String _price;
  String _qty;
  String _ticker;
  String _wlWarning;
  //String token;
  bool _readAccount = true;
  Map rule;
  bool _showAdd = false;
  bool _listModified = false;

  Map<String, dynamic> editAcc;
  List<String> _row;
  List<DataRow> _rowList = [];
  //  DataRow(cells: <DataCell>[
  //   DataCell(Text('AAAAAA')),
  //   DataCell(Text('1')),
  //   DataCell(Text('Yes')),
  // ]),

  //String error;

  @override
  void initState() {
    super.initState();
  }
  // final _controller = ScrollController();
  // final _height = 100.0;

  //bool isActive;
  //bool notifyOnly;
  bool _alert = false;

  //List<String> tickers = [];
  List<List<String>> data = [];
  //List<List<dynamic>> whitelist;
  List<dynamic> whitelist = [];
  //List data;
  List<String> titleColumn = ["Symbol", "QTY"];
  List<String> titleRow = [];
  final columns = 2;

  int rows = 1;

  void _deleteRow(row) {
    for (int i = 0; i < whitelist.length; i++) {
      //print(whitelist[i][0]);
      //print(row);
      if (whitelist[i][0] == row) {
        //print("Here");
        whitelist.removeAt(i);
        //tickers.remove(row);
        //break;
      }

      setState(() {
        _listModified = true;
        whitelist = whitelist;
      });
      _buildRows();
    }
  }

  void _addRow() async {
    if (_row[0] == null) {
      _row = [];
      _scontroller.clear();
      _qcontroller.clear();
      // _pcontroller.clear();
      _row = [];
      _wlWarning = 'Please fill out all fields';
      return;
    }
    //rows++;
    //print("Checking the whitelist for dups for $_row. $whitelist");

    //whitelist.forEach((w) {
    for (final w in whitelist) {
      if (w.length == 0) {
        continue;
      }
      if (w.contains(_row[0])) {
        var t = _row[0];
        _scontroller.clear();
        _qcontroller.clear();
        //_pcontroller.clear();
        _row = [];
        _wlWarning = t + " is already in the whitelist.";
        return;
      }
    }
    getQuote(_row[0].toUpperCase()).then((ret) {
      //print("Name2: $name");
      String name = ret['symbol'];
      if (name != null) {
        if (_row[1] == null) {
          _row[1] = 'all';
        }
        _row.add(name);
        whitelist.insert(0, _row);
        //print("Whitelist: $whitelist");

        setState(() {
          _wlWarning = null;
          _listModified = true;
          _scontroller.clear();
          _qcontroller.clear();
          //_pcontroller.clear();
          _row = [];
        });

        return;
      } else {
        setState(() {
          _wlWarning = _row[0] + " is not a valid symbol";
          _scontroller.clear();
          _qcontroller.clear();
          //_pcontroller.clear();
          _row = [];
        });
      }
    });

    // if (whitelist.length > account['max_watchlist_count']) {
    //     _scontroller.clear();
    //     _qcontroller.clear();
    //     //_pcontroller.clear();
    //     _row =[];
    //     _wlWarning = "You reached maximum allowed symbols per whitelist.";
    //     return;
    //   }

    // whitelist.add(_row);

    // print("WL2:$whitelist");

    // _scontroller.clear();
    // _qcontroller.clear();
    // //_pcontroller.clear();
    // _row = [];
    // _wlWarning = null;
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

    whitelist.forEach((row) {
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

  Widget showWhitelist() {
    if (_alert == true) {
      return (SizedBox(height: 0.0));
    }

    if (whitelist.length == 0) return (SizedBox(height: 0.0));

    return ListView.builder(
        //shrinkWrap: true,
        //itemExtent: 80.0,
        scrollDirection: Axis.vertical,
        itemCount: whitelist.length,
        //itemCount: 1,
        //itemBuilder: (context, index) {

        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(whitelist[index][0]),
            direction: DismissDirection.endToStart,
            confirmDismiss: (DismissDirection dismissDirection) async {
              switch (dismissDirection) {
                case DismissDirection.endToStart:
                  return await _showConfirmationDialog(
                          context, 'delete', whitelist[index][0]) ==
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
                whitelist.removeAt(index);
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
    List wl = whitelist[index];
    if (wl.length == 2) {
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
            padding: EdgeInsets.fromLTRB(30, 0, 90, 0),
            //width: w80,
            child: ListTile(
              isThreeLine: true,
              dense: true,
              title: Text(wl[0], style: white14Bold()),
              subtitle: Text(wl[2]),
              trailing: Text(wl[1]),
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
                // print(whitelist);
                // print(account);
                //account['wl'] = whitelist;
                editWhitelist(account, rule, whitelist);

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
    return Container(
      //color:Colors.red,
      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
      alignment: Alignment.centerRight,
      child: FlatButton(
        child: Text("Done",
            style: titleStyle().copyWith(
              color: lbColor,
              // decoration: TextDecoration.underline
            )),
        onPressed: () async {
          editWhitelist(account, rule, whitelist);

          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Rules(account: account),
              ));
        },
      ),
    );

    // Padding(
    //   padding: const EdgeInsets.fromLTRB(8.0,0,60,0),
    //   child: RaisedButton(
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10.0),
    //       //side: BorderSide(color: Colors.red)
    //     ),
    //     color: lbColor,
    //     child: updateButton(),
    //     onPressed: () async {

    //       editWhitelist(account, rule, whitelist);

    //       await Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => Rules(account: account),
    //           ));
    //     },

    // ),
    //       );
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

  Widget addToWhitelist() {
    //List<String> row = [];
    // String ticker;
    // String qty;
    // String price;
    _ticker = null;
    _qty = null;
    //_price = null;
    if (_showAdd == false) {
      return (SizedBox(height: 0.0));
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(50.0, 0, 0, 10),
        child: Container(
          width: w70,
          height: h5,

          // decoration: BoxDecoration(
          //     border: Border.all(
          //       color: Colors.grey[500],
          //     ),
          //     borderRadius: BorderRadius.all(Radius.circular(20))
          //   ),
          //padding: EdgeInsets.all(20),

          //color:Colors.grey[700],
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
                    // decoration: InputDecoration(
                    //   hintText: "qty",
                    // ),
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
                Container(
                  alignment: Alignment.topCenter,
                  //width:w20,
                  child: IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    tooltip: 'Add to the whitelist',
                    color: Colors.white,
                    onPressed: () async {
                      _row = [];
                      _row.add(_ticker);
                      _row.add(_qty);

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
    if (whitelist.length == 0) {
      return SizedBox(height: 0.0);
    }
    return Container(
      //color: Colors.red,
      //width: double.infinity,
      child: (Padding(
        padding: const EdgeInsets.fromLTRB(40.0, 10, 10, 0.0),
        child: Column(
          children: [
            Row(
                //mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Text("Symbol", style: white14Bold()),
                  SizedBox(width: w30),
                  new Text("    Qty", style: white14Bold()),
                ]),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  //color:Colors.red,
                  alignment: Alignment.centerLeft,
                  width: w60,
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

  Widget getTitle() {
    if (rule == null) {
      return (Text(
        'Global whitelist',
        style: white14Bold(),
      ));
    } else {
      return (Text(
        'Rule whitelist',
        style: white14Bold(),
      ));
    }
  }

  Widget ruleName() {
    if (rule == null) {
      return (Column(children: <Widget>[
        //SizedBox(height: 2,),

        ListTile(
          title: Text(
            "Description:",
            style: titleStyle(),
          ),
          subtitle: Column(children: [
            Text(
                "When a symbol is added to this global whitelist, none of the rules will be applied to it. This list superceded the whitelist created for each particular rule."),
            SizedBox(height: 5),
            Text(
                "You may choose to whitelist only a portion of your holding by entering the number of shares in the 'qty' field")
          ]),
        ),
      ]));
    } else {
      return (Column(children: <Widget>[
        //SizedBox(height: 2,),
        ListTile(
          title: Text(
            "Rule name:",
            style: titleStyle(),
          ),
          subtitle: Text(rule['name']),
        ),
        SizedBox(height: 2.0),
        ListTile(
          title: Text(
            "Description:",
            style: titleStyle(),
          ),
          subtitle: Column(children: [
            Text(
                "When a symbol is added to this whitelist, this particular rule won't be applied to it."),
            SizedBox(height: 5),
            Text(
                "You may choose to whitelist only a portion of your holding by entering the number of shares in the 'qty' field")
          ]),
        ),
      ]));
    }
  }

  String getHelpText() {
    String ret = "";
    if (rule == null) {
      ret +=
          "When a symbol is added to this global whitelist, none of the rules will be applied to it. This list superceded the whitelist created for each particular rule.\n\n";

      ret +=
          "You may choose to whitelist only a portion of your holding by entering the number of shares in the 'qty' field";
    } else {
      ret +=
          "When a symbol is added to this whitelist, this particular rule won't be applied to it.\n\n";

      ret +=
          "You may choose to whitelist only a portion of your holding by entering the number of shares in the 'qty' field";
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    //globals.tabIndex=1;
    data == null ? loading = true : loading = false;

    //print("Rebuilding");
    //data = _makeData();
    //data = output;
    if (data.length == 0) {
      for (int i = 0; i < columns; i++) {
        data.add([]);
      }
    }
    if (_readAccount) {
      // dynamic ptoken = Provider.of<WmrProviders>(context);
      // token = ptoken.getToken;
      final WhiteListArguments args = ModalRoute.of(context).settings.arguments;

      //print("ARGS: $args");
      account = args.account;
      // if (account['type'] == 'manual') {
      //   globals.tabIndex = 1;
      // } else {
      //   globals.tabIndex = 0;
      // }
      rule = args.rule;
      if (rule == null) {
        whitelist = account['whitelist'];
      } else {
        whitelist = rule['whitelist'];
      }
      if (whitelist == null) {
        whitelist = [];
      }
      _wlWarning = null;
      _readAccount = false;
    }

    //final accountId = account['account_id'];
    //final accountName = account['account_name'];

    return GestureDetector(
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
                getTitle(),
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
                showDone(),
                // ListTile(
                //   // leading: CircleAvatar(
                //   //         radius: 20.0,
                //   //         backgroundImage: AssetImage('assets/$assetImg'),
                //   //       ),
                //   title: Text(
                //     "Account name:",
                //     style: titleStyle(),
                //   ),
                //   subtitle: Text(account['account_name']),
                //   trailing: showDone(),
                // ),
                //SizedBox(height: 2.0),
                //ruleName(),

                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                    child: Column(
                      children: <Widget>[
                        //SizedBox(height: 5.0),

                        showWarning(),

                        Container(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              children: [
                                Text(
                                  "Whitelisted symbols (${whitelist.length})",
                                  textAlign: TextAlign.left,
                                  style: titleStyle(),
                                ),
                                showAddIcon(),
                                IconButton(
                                    icon:
                                        Icon(FlutterIcons.question_circle_faw),
                                    tooltip: 'description',
                                    color: Colors.white,
                                    onPressed: () {
                                      showHelp(context, "Desctiption",
                                          getHelpText(), "Ok");
                                    })
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                addToWhitelist(),

                //showUpdate(),
                //showWhitelist(),

                showHeading(),
                Expanded(child: showWhitelist()),
              ]),
          // floatingActionButton: FloatingActionButton(
          //     onPressed: ()  {
          //       _setAlert();

          //       },
          //     tooltip: 'Delete the whitelist',
          //     child: Icon(
          //       Icons.delete,
          //       color:Colors.red,
          //       ),
          //   ),
        ));
  }
}
