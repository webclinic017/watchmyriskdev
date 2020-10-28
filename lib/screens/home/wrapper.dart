//import 'package:WMR/models/user.dart';
//import 'package:WMR/screens/authenticate/authenticate.dart';
//import 'package:WMR/screens/home/home.dart';
import 'package:WMR/screens/home/intro.dart';
import 'package:WMR/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  
  final _st = FlutterSecureStorage();
  bool isNew = true;

  @override
  void initState() {
    _readAll();
    super.initState();
  }

  Future<Null> _readAll() async {
    String tt = await _st.read(key: 'z_new');
    print("TT: $tt");
    await _st.read(key: 'is_new').then((e) {
      setState(() {
        if (e != null) {
          isNew = false; 
        }    
    });
    });
  }

  Widget build(BuildContext context) {
    //final user = Provider.of<AuthUser>(context);
    

    // return either the Home or Authenticate widget
    print("IsNew: $isNew");
    if (isNew == false) {
      return SignIn();
    } else {
      return Intro();
    }
  }
}

// class Wrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<User>(context);

//     // return either the Home or Authenticate widget
//     if (user == null) {
//       //return Authenticate();
//       //print("Wrapper:")
//       return Welcome();
//     } else {
//       return Home();
//     }
//   }
// }
