import 'package:WMR/screens/authenticate/sign_in.dart';
import 'package:WMR/services/auth.dart';
//import 'package:WMR/shared/constants.dart';
import 'package:WMR/shared/loading.dart';
//import 'package:WMR/shared/validators.dart';
import 'package:flutter/material.dart';
import 'package:WMR/shared/constants.dart';
//import 'package:flutter_icons/flutter_icons.dart';

import 'package:WMR/services/apis.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';
//import 'package:dropdown_banner/dropdown_banner.dart';
import 'package:flushbar/flushbar.dart';
//import 'package:sms_autofill/sms_autofill.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'package:WMR/shared/globals.dart' as globals;

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();
  TextEditingController controller = TextEditingController();
  String error;
  bool loading = false;
  bool smsCodeOk = false;
  bool showSms = false;
  bool agreed = false;
  bool usePhone = false;

  // text field state
  String name = '';
  String email = '';
  String password = '';
  String aphoneNumber = '';
  String countryCode = '1';
  String rePassword = '';
  String smsCode = 'glgjhklgyut';
  String enteredSmsCode = '';

  String validatePassword(value) {
    if (value != password) {
      return "Passwords don't match";
    } else if (value.isEmpty) {
      return "Password can't be empty";
    } else if (value.length < 8) {
      return "Enter a password 8+ chars long";
    }
    return null;
  }

  Widget showPhone() {
    if (usePhone == true) {
      return Column(children: [
        Row(
          children: [
            Text("+"),
            SizedBox(width: 5.0),
            Container(
              width:25,
              child: TextFormField(
                //controller: controller,
                initialValue: '1',
                keyboardType: TextInputType.number,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  hintText: "CC",
                ),
                validator: (value) =>
                    value.isEmpty ? 'CC' : null,
                onSaved: ((value) {
                  countryCode = value;
                  //showSms = true;
                }),
              ),
            ),
            SizedBox(width:5.0),
            Expanded(
                child: 
                Container(
                  width:w50,
                  child: TextFormField(
              //controller: controller,
              keyboardType: TextInputType.number,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                  hintText: "Phone number",
              ),
              validator: (value) =>
                    value.isEmpty ? 'Enter your phone number' : null,
              onSaved: ((value) {
                  aphoneNumber = value;
                  showSms = true;
              }),
            ),
                )),

            // onChanged: (val) {
            //   setState(() => aphoneNumber = val);
            //   showSms = true;
            // }),

            showSmsButton(),
          ],
        ),
        SizedBox(height: h2),
        showCodeField(),
        SizedBox(height: h1),
        Text(
            "To proceed, please click on the 'Send sms code' button and enter the code you will recieve in the field appearing above."),
      ]);
    } else {
      setState(() => smsCodeOk = true);
      return SizedBox(height: 0,);
      // return Text(
      //   "You won't be notified by a text message when a rule is triggered.\nYou will need to check the matched rules from the app.",
      //   style: errorStyle(),
      // ); 
      
      
    }
  }

  Widget showRegister() {
    bool greyOut = true;
    Color c = Colors.grey[700];
    //print("Entered: $enteredSmsCode and smsCode:$smsCode");
    if (usePhone == true) {
       print("Validating Here1: $agreed,  $enteredSmsCode, $smsCode");
      if ((enteredSmsCode == smsCode) & (agreed)) {
        //print("Code ok");
        greyOut = false;
        smsCodeOk = true;
        c = Colors.blueAccent;
      }
    } else {

      if (agreed) {
        //print("Code ok");
        greyOut = false;
        smsCodeOk = true;
        c = Colors.blueAccent;
      }
    }
    if ((greyOut == false) & (_formKey.currentState != null))
      //_formKey.currentState.save();
      {
      print("Validating Here");
      if (!validate(_formKey)) {
          setState(() => greyOut = true);
      }
      }

    return RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          //side: BorderSide(color: Colors.red)
        ),
        color: c,
        child: Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
        //showCodeField(code);
        onPressed: greyOut
            ? null
            : () async {
                setState(() => loading = true);
                print("Email: $email");
                print(password);
                dynamic result =
                    await _auth.registerWithEmailAndPassword(email, password);
                //print("Result: $result");
                if (!(result.startsWith("ERROR: "))) {
                  await addUserAccount(result, name, email, countryCode, aphoneNumber);
                  Flushbar(
                    //padding: EdgeInsets.fromLTRB(100, 0, 0, 0),
                    flushbarPosition: FlushbarPosition.TOP,
                    backgroundColor: Colors.grey[700],
                    titleText: Center(
                        child: Text("Wellcome to WMR!", style: white14Bold())),
                    messageText: Center(
                        child: Text(
                      "You signed on successfully!",
                      style: titleStyle(),
                    )),
                    duration: Duration(seconds: 5),
                  )..show(context);
                  Future.delayed(Duration(milliseconds: 3000), () async {
                    await Navigator.pushNamed(context, '/sign_in');
                  });
                } else {
                  String _error = result.replaceAll('ERROR: ', '');
                  setState(() {
                    loading = false;
                    error = _error;
                  });
                }
              });
    
  }

  Widget showCodeField() {
    if (showSms) {
      return Column(children: [
        SizedBox(height: h1),
        TextFormField(
          keyboardType: TextInputType.number,
          autocorrect: false,
          enableSuggestions: false,
          decoration: InputDecoration(
            hintText: "sms code",
          ),
          //onSaved: (value) => enteredSmsCode = value,
          onChanged: (val) {
            setState(() => enteredSmsCode = val);
          },
        ),
      ]);
    } else {
      return SizedBox(height: 0);
    }
  }

  Widget showError() {
    print(error);
    if (error == null) return SizedBox(height: 0.0);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.grey[400],
      ),
      //color: Colors.grey[200],
      //width: double.infinity,
      //padding: EdgeInsets.all(3.0),
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
              error,
              style: TextStyle(fontSize: 14, color: Colors.red[900]),
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
                  error = null;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget showSmsButton() {
    return RaisedButton(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          //side: BorderSide(color: Colors.red)
        ),
        color: Colors.grey[600],
        child: Text(
          'Send sms code',
          style: TextStyle(color: Colors.white),
        ),
        //showCodeField(code);

        onPressed: () async {
          // Flushbar(
          //               //padding: EdgeInsets.fromLTRB(100, 0, 0, 0),
          //               flushbarPosition: FlushbarPosition.TOP,
          //               backgroundColor: Colors.grey[700],
          //               titleText:  Center(child:Text("Wellcome to WMR!", style:white14Bold())),
          //               messageText:  Center(child:Text("You signed on successfully!", style: titleStyle(),)),
          //               duration:  Duration(seconds: 5),
          // )..show(context);
          if (validate(_formKey)) {
            await sendUserSMS(countryCode, aphoneNumber).then((code) {
              print("Text sent: $code");
              if (code != null) {
                setState(() => smsCode = code);
                //showCodeField(code);
              }
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    // controller.addListener(() {
    //   print(controller.text);
    // });
    // Scaffold.of(context).showSnackBar(snackBar);

    SizeConfig().init(context);
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
          //resizeToAvoidBottomPadding: false,
          //backgroundColor: Colors.lightBlueAccent,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Register",
              style: white14Bold(),
            ),

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

            //centerTitle: true,
            automaticallyImplyLeading: true,

            //backgroundColor: Colors.black,
            elevation: 0.0,
          ),
          body: Form(
            key: _formKey,
            child: Container(
              //height: h80,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 20, 20, 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      //SizedBox(height: h1),
                      showError(),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: " Name",
                        ),
                        validator: (value) =>
                            value.isEmpty ? 'Enter your name' : null,
                        onSaved: (value) => name = value,
                        // onChanged: (val) {
                        //   setState(() => name = val);
                        // },
                      ),
                      SizedBox(height: h1),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: InputDecoration(
                          hintText: " Email address",
                        ),
                        validator: (value) =>
                            value.isEmpty ? 'Enter your email' : null,
                        //onSaved: (value) => email = value,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),

                      SizedBox(height: h1),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Password",
                        ),
                        obscureText: true,
                        validator: (value) => value.length < 8
                            ? 'Enter a password 8+ chars long'
                            : null,
                        //onSaved: (value) => password = value,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(height: h1),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: " Re-enter the password",
                        ),
                        obscureText: true,
                        validator: validatePassword,
                        //validator: PasswordValidator.validate,
                        // validator: (value) => value.length < 6
                        //     ? 'Enter a password 6+ chars long'
                        //     : null,
                        //onSaved: (value) => rePassword = value,
                        onChanged: (val) {
                          setState(() => rePassword = val);
                        },
                      ),
                      SizedBox(height: h1),
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Upon triggered sell rules,"),
                              Text("notify me with an sms message."),
                            ],
                          ),
                          // IconButton(
                          //           icon:
                          //               Icon(FlutterIcons.question_ant),
                          //           tooltip: 'info',
                          //           color: Colors.white,
                          //           onPressed: () {
                          //             showHelp(context, "What happens",
                          //                 "No sms text will be sent when a rule is triggered. You need to check matched rules in the app.", "Ok");
                          //           }),
                          SizedBox(width: h1),
                          Checkbox(
                            value: usePhone,
                            onChanged: (value) {
                              
                              setState(() {
                                usePhone = value;
                              });
                            },
                            //  activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.grey[800],
                            checkColor: Colors.greenAccent,
                          ),
                        ],
                      ),
                      showPhone(),

                      Row(children: [
                        Text("I have read and agree to the "),
                        GestureDetector(
                            child: Text(
                              "disclaimer",
                              style: TextStyle(color: Colors.lightBlueAccent),
                            ),
                            onTap: () {
                              //Navigator.pushNamed(context, '/disclaimer');
                              launch('https://www.watchmyrisk.com/disclaimer');
                              FocusScope.of(context).unfocus();
                            }),
                        Checkbox(
                          value: agreed,
                          onChanged: (value) {
                            setState(() {
                              agreed = value;
                            });
                          },
                          //  activeTrackColor: Colors.lightGreenAccent,
                          activeColor: Colors.grey[800],
                          checkColor: Colors.greenAccent,
                        ),
                      ]),
                      SizedBox(height: 2.0),
                      showRegister(),
                      //SizedBox(height: h1),

                      // Find the Scaffold in the widget tree and use
                      // it to show a SnackBar.
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
