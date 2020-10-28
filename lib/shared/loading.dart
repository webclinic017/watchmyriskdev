import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:WMR/services/auth.dart';


class Loading extends StatelessWidget {
  //final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {

    //Future.delayed(Duration(milliseconds: 10));
    // _auth.isUserLoggedIn().then((ret) {
    //     print("User: $ret");
    //     if (ret == false) {
    //        _auth.signOut();
    //        Navigator.pushNamed(context, '/sign_in');
    //     }
    // });
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
