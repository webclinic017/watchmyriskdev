import 'package:flutter/material.dart';

import 'package:WMR/shared/loading.dart';
import 'package:WMR/shared/constants.dart';

import 'package:WMR/services/apis.dart';
import 'package:flushbar/flushbar.dart';

class Invite extends StatefulWidget {
  @override
  _InviteState createState() => _InviteState();
}

  

class _InviteState extends State<Invite> {
  final _formKey = GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();
  TextEditingController controller = TextEditingController();
  String error;
  bool loading = false;
  bool smsCodeOk = false;
  bool showSms = false;
  bool agreed = false;
  //String token;
  
 
 
  @override
  void initState() {
    
    super.initState();
  }
 
  
 

  // text field state
  String text = '';

  @override
  Widget build(BuildContext context) {
    // dynamic wp = Provider.of<WmrProviders>(context);
    // String token = wp.getToken;

    //SizeConfig().init(context);
    if (loading) Loading();

    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          key: globalKey,
          resizeToAvoidBottomPadding: false,
          //backgroundColor: Colors.lightBlueAccent,
          appBar: AppBar( centerTitle: true,
            // No Back Arrow
            automaticallyImplyLeading: true,
            //backgroundColor: Colors.blueGrey,
            elevation: 0.0,
            title: Text(
              'Invite Friends',
              style: white14Bold(),
            ),
            actions: <Widget>[
              // FlatButton.icon(
              //     icon: Icon(Icons.person),
              //     label: Text('Sign In'),
              //     //onPressed: () => widget.toggleView(),
              //     onPressed: () {
              //       Navigator.pushNamed(context, '/sign_in');
              //     }),
            ],
          ),
          body: Form(
            key: _formKey,
            child: Container(
              height: h80,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 20, 40, 40),
                child: 
                SingleChildScrollView(
                   child: Column(
                    children: <Widget>[
                      SizedBox(height: h5),
                      Text("Please enter your friends' phone numbers. Upon submission, an sms message with a code will be sent to them."),
                  SizedBox(
                    height: h2,
                  ),
                  
                      
                      TextFormField(
                        maxLines: 2,
                        maxLength: 100,
                        keyboardType: TextInputType.number,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: InputDecoration(
                          hintText: "Add your friends' 10-digits phone numbers (comma separated)",
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)),
                        ),
                        //validator: (val) => (val.trim().split("\\s+").length < 10)
                        validator: ((val) { 
                          //String error ='';
                          List phoneNumbers = val.replaceAll(' ','').split(",");
                           if (phoneNumbers.length < 1) {
                            return 'Please enter at least one phone number';
                           } 
                            for (var p in phoneNumbers) {
                              print("Length: ${p.length}");
                              if (p.length != 10) {
                                return 'Phone number $p is not 10 digits.';
                                //break;
                              }
                            }
                            return null;
                          
                          // return null;
                        }),
                        onChanged: (val) {
                          setState(() => text = val);
                        },
                      ),
                      SizedBox(height: h1),
                      RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            //side: BorderSide(color: Colors.red)
                          ),
                          color: Colors.grey[600],
                          child: Text(
                            'Send',
                            style: TextStyle(color: Colors.white),
                          ),
                          //showCodeField(code);
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                            //setState(() => loading = true);
                            await sendInvite(text);
                            // //print("Result: $result");
                            //if (result) {
                              Flushbar(
                                //padding: EdgeInsets.fromLTRB(100, 0, 0, 0),
                                flushbarPosition: FlushbarPosition.TOP,
                                backgroundColor: Colors.grey[700],
                                messageText: Center(
                                    child: Text(
                                  "Thank you!",
                                  style: titleStyle(),
                                )),
                                duration: Duration(seconds: 2),
                              )..show(context);
                              Future.delayed(Duration(milliseconds: 2000), () {
                                Navigator.popUntil(context, ModalRoute.withName('/home'));
                              });
                            }
                            }
                          //}
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

