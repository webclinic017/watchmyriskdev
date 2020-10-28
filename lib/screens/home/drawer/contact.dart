import 'package:flutter/material.dart';

import 'package:WMR/shared/loading.dart';
import 'package:WMR/shared/constants.dart';

import 'package:WMR/services/apis.dart';
import 'package:flushbar/flushbar.dart';


class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class Message {
  int id;
  String name;
 
  Message(this.id, this.name);
 
  static List<Message> getMessages() {
    return <Message>[
      Message(1, 'Please select a category'),
      Message(2, 'Feedback'),
      Message(3, 'Support'),
      Message(4, 'How-tos'),
      Message(5, 'Billing'),
      Message(6, 'Others'),
    ];
  }
}

class _ContactState extends State<Contact> {
  final _formKey = GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();
  TextEditingController controller = TextEditingController();
  String error;
  bool loading = false;
  bool smsCodeOk = false;
  bool showSms = false;
  bool agreed = false;
  //String token;
  
  List<Message> _messages = Message.getMessages();
  List<DropdownMenuItem<Message>> _dropdownMenuItems;
  Message _selectedMessage;
 
  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_messages);
    _selectedMessage = _dropdownMenuItems[0].value;
    super.initState();
  }
 
  List<DropdownMenuItem<Message>> buildDropdownMenuItems(List messages) {
    List<DropdownMenuItem<Message>> items = List();
    for (Message message in messages) {
      items.add(
        DropdownMenuItem(
          value: message,
          child: Text(message.name),
        ),
      );
    }
    return items;
  }
 
  onChangeDropdownItem(Message selectedMessage) {
    setState(() {
      _selectedMessage = selectedMessage;
    });
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
              'Contact us',
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
                      SizedBox(height: h3),
                      
                  SizedBox(
                    height: 20.0,
                  ),
                  DropdownButton(
                    value: _selectedMessage,
                    items: _dropdownMenuItems,
                    onChanged: onChangeDropdownItem,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  
                      TextFormField(
                        maxLines: 8,
                        maxLength: 1000,
                        keyboardType: TextInputType.multiline,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: InputDecoration(
                          hintText: "Please enter your message",
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)),
                        ),
                        //validator: (val) => (val.trim().split("\\s+").length < 10)
                        validator: (val) => (val.split(" ").length < 5)
                            ? 'Please enter at least 5 words'
                            : null,
                        onSaved: (val) => text = val,
                        // {
                        //   setState(() => text = val);
                        // },
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
                            if (validate(_formKey)) {
                            //setState(() => loading = true);
                            await sendMessage(_selectedMessage.name, text);
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

