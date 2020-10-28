import 'package:flutter/material.dart';
import 'package:WMR/screens/authenticate/sign_in.dart';
import 'package:WMR/screens/home/home.dart';



class Expired extends StatefulWidget {
  final int delay;
  final String message;
  Expired({Key key, this.delay, this.message}) : super(key: key);
  @override
  _ExpiredState createState() => new _ExpiredState();
}

class _ExpiredState extends State<Expired> {
  int delay = 3;
  String message = 'Your session is expired.\n\n Please log in again.';
  
  @override
  void initState() {
    if (widget.delay != null ) {
      delay = widget.delay;
    }
    if (widget.message != null ) {
      message = widget.message;
    }
    super.initState();
    if (delay == 0) {
      Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()));     
    } else {
    new Future.delayed(
        Duration(seconds: delay),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignIn()),
            ));
  }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //backgroundColor: Colors.white,
      body: Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          
          Text(message),
          
        ]),
      ),
    );
  }
}