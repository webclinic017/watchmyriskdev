import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:WMR/services/auth.dart';


class Loading extends StatelessWidget {
  //final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.brown[200],
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.brown,
          size: 50.0,
        ),
      ),
    );
  }
}
