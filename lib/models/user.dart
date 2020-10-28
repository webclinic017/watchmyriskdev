
//import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {

  //final FirebaseUser user;
  final String uid;
  //final String token;
  
  AuthUser({ this.uid});

//   String getUid() {
//     return this.uid;
//   }

// String getToken() {
//     return this.token;
//   }

}

class UserData {

  final String uid;
  final String name;
  final String sugars;
  final int strength;

  UserData({ this.uid, this.sugars, this.strength, this.name });

}