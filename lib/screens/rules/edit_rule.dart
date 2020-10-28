//import 'package:WMR/shared/globals.dart';
import "package:flutter/material.dart";
//import 'package:WMR/shared/constants.dart';
//import 'package:WMR/shared/loading.dart';
import 'package:WMR/services/apis.dart';
import 'package:WMR/screens/rules/rules.dart';
import 'package:WMR/screens/rules/edit_whitelist.dart';

import 'package:WMR/models/accounts.dart';
import 'package:WMR/shared/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_icons/flutter_icons.dart';

//import 'package:WMR/shared/globals.dart' as globals;

//import 'package:flutter/services.dart';
//import 'dart:convert';

class EditRuleForm extends StatefulWidget {
  final Map rule;
  final Map account;
  EditRuleForm({Key key, @required this.rule, this.account}) : super(key: key);
  @override
  _EditRuleFormState createState() => _EditRuleFormState();
}

class _EditRuleFormState extends State<EditRuleForm> {
  final _formKey = GlobalKey<FormState>();

  //pController = TextEditingController();

  // var _focusNode = new FocusNode();

  //     _focusListener() {
  //       setState(() {});
  //     }
  TextEditingController pController;
  TextEditingController vController;
  TextEditingController minController;
  TextEditingController maxController;

  @override
  void initState() {
    //_focusNode.addListener(_focusListener);
    super.initState();
    if (widget.rule['price_pct'] != null)
      pController =
          TextEditingController(text: widget.rule['price_pct'].toString());
    if (widget.rule['volume'] != null)
      vController =
          TextEditingController(text: widget.rule['volume']['pct'].toString());
    if (widget.rule['min'] != null)
      minController =
          TextEditingController(text: widget.rule['min']['user'].toString());
    if (widget.rule['max'] != null)
      maxController =
          TextEditingController(text: widget.rule['max']['user'].toString());
  }

  @override
  void dispose() {
    //_focusNode.removeListener(_focusListener);
    super.dispose();
  }

  //final _controller = TextEditingController();

  Map<String, dynamic> newRule;
  String error;
  //String iniPrice;

  bool changed;

  String _warning;

  Widget showWhitelist(account, rule) {
    return ListTile(
      dense: true,
      title: Text("Whitelisted symbols for this rule: ", style: titleStyle()),
      subtitle: _showRuleWhitelist(rule),
      trailing: IconButton(
          icon: Icon(Icons.edit),
          tooltip: 'Add whitelist',
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    //Rules(accountId: account['account_id']))
                    EditWhiteList(),
                settings: RouteSettings(
                  arguments: WhiteListArguments(account, rule),
                ),
              ),
            );
          }),
    );
  }

  Widget _showRuleWhitelist(rule) {
    if (rule['whitelist'].length == 0)
      return Container(
        alignment: Alignment.centerLeft,
        child: (Text(
          "None",
          style: white_14(),
        )),
      );
    if (rule['is_active'] == false) return (SizedBox(height: 0));

    String wls = "";
    //List items = [];
    int i = 0;
    for (List w in rule['whitelist']) {
      i += 1;
      //items.add(w[0]+"["+w[1]+"]");
      wls += w[0];
      if (w[1].toString() != 'all') wls += "[" + w[1] + "]";
      if (i != rule['whitelist'].length) wls += ", ";
    }

    return Container(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5.0, 5, 5, 20),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(wls, style: white_14()),
            )),
      ),
    );
  }

  Widget showVolumeDir(dir) {
    if (dir == 'gte') {
      return SizedBox(
        width: w50,
        child: Text(
          "% change of higher volume",
          //style:white_14(),
        ),
      );
    } else {
      return SizedBox(
        width: w50,
        child: Text(
          "% change of lower volume",
        ),
      );
    }
  }

  Widget showVolume(rule, account) {
    if (rule['can_be_edited'] != true) return SizedBox(height: 0);
    if (rule['edit_widget'] == 1) {
      return SizedBox(
        height: 0,
      );
    }
    if (!rule.containsKey('volume')) {
      return SizedBox(
        height: 0,
      );
    } else {
      return Column(children: [
        Row(children: [
          Container(
              width: w60, child: showVolumeDir(rule['volume']['direction'])),
          SizedBox(width: w5),
          new SizedBox(
              width: w10,
              child: TextFormField(
                controller: vController,
                maxLines: 1,
                //initialValue: rule['volume']['pct'].toString(),
                //keyboardType: TextInputType.number,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                autocorrect: false,
                enableSuggestions: false,

                style: white14Bold(),
                //style: inputStyle(),
                decoration: new InputDecoration(
                  fillColor: Colors.transparent,
                  //border: InputBorder.none,
                  // border: _focusNode.hasFocus
                  //     ? OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  //         borderSide: BorderSide(color: Colors.blue))
                  //     : InputBorder.none,
                  //filled: true,
                  //contentPadding: EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0),
                  hintText: "% volume change",

                  //labelText: 'Title',
                ),
                // decoration: InputDecoration(
                //   hintText: "% volume change",

                // ),

                onSaved: (val) => rule['volume']['pct'] = double.parse(val),
                // setState(() {
                //   rule['volume']['pct'] = double.parse(val);
                // }),
                //onSaved: (String val) {rule['volume']['pct'] = double.parse(val);},
                validator: (val) {
                  if (val.isEmpty) {
                    setState(() {
                      _warning = "Please enter the volume %";
                    });
                    return '';
                  }
                  //error = '';
                  return null;
                },
              )),
        ]),
        showPrice(rule),
      ]);
    }
  }

  Widget showPrice(rule) {
    if (rule['has_price'] == true) {
      return Row(children: [
        Container(width: w60, child: Text(rule['price_description'])),
        SizedBox(width: w5),
        new SizedBox(
          width: w10,
          // child: TextFormField(
          //   //controller: _minController,
          //   //focusNode: _focusNode,
          //   maxLines: 1,
          //   initialValue: rule['price_pct'].toString(),
          //   keyboardType: TextInputType.number,
          //   autocorrect: false,
          //   decoration: InputDecoration(
          //     hintText: "% change",
          //   ),

          //   onChanged: (val) => setState(() {
          //     rule['price_pct'] = double.parse(val);
          //   }),
          //   validator: (val) {
          //     if (val.isEmpty) {
          //       setState(() {
          //         _warning = "Please enter % change";
          //       });
          //     }
          //     //error = '';
          //     return null;
          //   },
          // )),

          child: TextFormField(
            //focusNode: _focusNode,
            //initialValue: rule['price_pct'].toString(),
            //initialValue: iniPrice,
            controller: pController,
            //style: inputStyle(),
            style: white14Bold(),

            //keyboardType: TextInputType.number,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            autocorrect: false,
            enableSuggestions: false,
            decoration: new InputDecoration(
              fillColor: Colors.transparent,
              //border: InputBorder.none,

              // border: _focusNode.hasFocus
              //     ? OutlineInputBorder(
              //         borderRadius: BorderRadius.all(Radius.circular(5.0)),
              //         borderSide: BorderSide(color: Colors.blue))
              //     : InputBorder.none,
              //filled: true,
              //contentPadding: EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0),
              //labelText: 'Title',
              hintText: "% ",
            ),

            onSaved: (val) => rule['price_pct'] = double.parse(val),
            // setState(() {
            //   rule['price_pct'] = double.parse(val);
            //   //double price_pct= double.parse(val);
            //   //print("VAL: $val");
            // }),
            validator: (val) {
              if (val.isEmpty) {
                setState(() {
                  _warning = "Please enter % change";
                });
                return '';
              }
              //error = '';
              return null;
            },
          ),
        )
      ]);
    } else {
      return SizedBox(
        height: 0.0,
      );
    }
  }

  Widget showEodOnly(rule, account) {
    if (rule['can_be_edited'] != true) return SizedBox(height: 0);
    if (rule['can_modify_eod'] != true) return SizedBox(height: 0);
    if (account == null) return SizedBox(height: 0);
    return Row(
      children: [
        Text("End Of Day Only"),
        Switch(
          value: rule['eod_only'],
          onChanged: (value) {
            setState(() {
              rule['eod_only'] = value;
            });
          },
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
        ),
      ],
    );
  }

  Widget showNotifyOnly(rule, account) {
    if (rule['can_be_edited'] != true) return SizedBox(height: 0);
    if (rule['can_modify_noti'] != true) return SizedBox(height: 0);
    if (account == null) return SizedBox(height: 0);
    if (account['type'] != 'linked') return SizedBox(height: 0);
    return Row(
      children: <Widget>[
        Text("Notification Only"),
        Switch(
          value: rule['notify_only'],
          onChanged: (value) {
            setState(() {
              rule['notify_only'] = value;
            });
          },
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
        ),
      ],
    );
  }

  Widget showMinMax(rule, account) {
    //if (rule[''])
    if (rule['can_be_edited'] != true) return SizedBox(height: 0);
    if (rule['edit_widget'] != 1) {
      return SizedBox(
        height: 0,
      );
    } else {
      return Column(children: [
        Row(children: [
          Text("Min % price change: "),
          SizedBox(width: w2),
          new SizedBox(
              width: w20,
              child: TextFormField(
                controller: minController,
                maxLines: 1,
                //initialValue: rule['min']['user'].toString(),
                //keyboardType: TextInputType.number,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  hintText: "Min %",
                ),

                //onSaved: (val) => rule['min']['user'] = double.parse(val),
                onChanged: ((val) { 
                  setState(() {
                    rule['min']['user'] = double.parse(val);
                  });
                }),
                validator: (minVal) {
                  if (minVal.isEmpty) {
                    //return 'Max %';
                    setState(() {
                      _warning = "Please enter the Min %";
                    });

                    return '';
                  } else if (rule['min']['user'] >= rule['max']['user']) {
                    setState(() {
                      _warning = "Min cannot be >= Max";
                    });
                    return '';
                  } else if (rule['min']['user'] <= 0) {
                    setState(() {
                      _warning = "Please enter a positive number";
                    });

                    return '';
                  } else if (rule['min']['user'] < rule['min']['limit']) {
                    setState(() {
                      _warning = "Min cannot be <  ${rule['min']['limit']}";
                    });

                    return '';
                  }

                  error = '';
                  return null;
                },
              )),
          Flexible(
              child: Text(
            "A value >= ${rule['min']['limit']}",
            style: white_10(),
          ))
        ]),
        SizedBox(width: w5),
        Row(
          children: [
            Text("Max % price change: "),
            SizedBox(width: w2),
            new SizedBox(
                width: w20,
                child: TextFormField(
                  maxLines: 1,
                  controller: maxController,
                  //initialValue: rule['max']['user'].toString(),
                  //keyboardType: TextInputType.number,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    hintText: "Max %",
                  ),
                  //onSaved: (val) => rule['max']['user'] = double.parse(val),
                  // setState(() {
                  //   rule['max']['user'] = double.parse(val);
                  // }),
                  onChanged: ((val) { 
                      setState(() {
                        rule['max']['user'] = double.parse(val);
                      });
                  }),


                  validator: (maxVal) {
                    if (maxVal.isEmpty) {
                      //return 'Max %';
                      setState(() {
                        _warning = "Please enter the max %";
                      });

                      return '';
                    } else if (rule['max']['user'] <= rule['min']['user']) {
                      setState(() {
                        _warning = "Max cannot be <= Min";
                      });

                      return '';
                    } else if (rule['max']['user'] <= 0) {
                      setState(() {
                        _warning = "Please enter a positive number";
                      });

                      return '';
                    } else if (rule['max']['user'] > rule['max']['limit']) {
                      setState(() {
                        _warning = "Max cannot be >  ${rule['max']['limit']}";
                      });

                      return '';
                    }

                    error = '';
                    return null;
                  },
                )),
            Flexible(
                child: Text(
              "A value <= ${rule['max']['limit']}",
              style: white_10(),
            ))
          ],
        ),
      ]);
    }
  }

  Widget showAlert() {
    if (_warning != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.grey[400],
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
              child: Icon(
                Icons.error_outline,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: AutoSizeText(
                _warning,
                style: TextStyle(fontSize: 16, color: Colors.red[900]),
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _warning = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    // dynamic wp = Provider.of<WmrProviders>(context);
    // String token = wp.getToken;
    //Map rule = wp.ruleToEdit;
    // final  Map<String, Object>rcvdData = ModalRoute.of(context).settings.arguments;
    // Map account = rcvdData['account'];
    // Map rule = rcvdData['rule'];
    Map rule = widget.rule;
    Map account = widget.account;
    //print("Rule: $rule");
    //iniPrice = rule['price_pct'].toString();
    //pController(text: rule['price_pct'].toString());
    //final pController = TextEditingController(text: rule['price_pct'].toString());

    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Column(
                children: <Widget>[
                  Text(
                    "Edit a rule",
                    style: white14Bold(),
                  ),
                  Text(
                    account['account_name'],
                    style: white_10(),
                  ),
                ],
              ),
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Rules(account: account),
                      ));
                },
              ),

              //centerTitle: true,
              automaticallyImplyLeading: true,

              //backgroundColor: Colors.black,
              elevation: 0.0,
            ),
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            dense: true,
                            title: Text("Name:", style: titleStyle()),
                            subtitle: Row(
                              children: [
                                Text(rule['name']),
                                IconButton(
                                    icon:
                                        Icon(FlutterIcons.question_circle_faw),
                                    tooltip: 'description',
                                    color: Colors.white,
                                    onPressed: () {
                                      showHelp(context, "Desctiption",
                                          rule['description'], "Ok");
                                    })
                              ],
                            ),
                          ),
                          SizedBox(height: h1),
                          showWhitelist(account, rule),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                            child: Text("Settings:", style: titleStyle()),
                          ),

                          // ListTile(
                          //   // leading: CircleAvatar(
                          //   //         radius: 20.0,
                          //   //         backgroundImage: AssetImage('assets/$assetImg'),
                          //   //       ),
                          //   title: Text("Description:", style: titleStyle()),
                          //   subtitle: Text(rule['description']),
                          // ),
                          Form(
                            key: _formKey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 5.0, 0, 5.0),
                              child: Container(
                                //color:Colors.red,
                                child: Column(children: <Widget>[
                                  //SizedBox(height: h1),
                                  Row(children: [
                                    Text("Enable/Disable"),
                                    Switch(
                                      value: rule['is_active'],
                                      onChanged: (value) {
                                        setState(() {
                                          rule['is_active'] = value;
                                        });
                                      },
                                      activeTrackColor: Colors.lightGreenAccent,
                                      activeColor: Colors.green,
                                    ),
                                  ]),
                                  //SizedBox(height: h1),
                                  showEodOnly(rule, account),
                                  //SizedBox(height: h1),
                                  showNotifyOnly(rule, account),
                                  //SizedBox(height: h1),
                                  showMinMax(rule, account),
                                  //SizedBox(height: h1),
                                  showVolume(rule, account),
                                  //SizedBox(height: h1),
                                  showAlert(),
                                  //SizedBox(height: h2),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              //side: BorderSide(color: Colors.red)
                                            ),
                                            color: Colors.grey[600],
                                            child: Text(
                                              'Cancel',
                                              style: white_14().copyWith(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () async {
                                              Navigator.pop(context, account);
                                            }),
                                        SizedBox(
                                          width: w20,
                                        ),
                                        RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              //side: BorderSide(color: Colors.red)
                                            ),
                                            color: Colors.grey[600],
                                            child: Text(
                                              'Update',
                                              style: white14Bold(),
                                            ),
                                            onPressed: () async {
                                              if (validate(_formKey)) {
                                                await updateRule(rule);
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Rules(
                                                              account: account),
                                                    ));
                                              }
                                            }),
                                      ],
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: h1,
                          ),
                        ])))));
  }
}
