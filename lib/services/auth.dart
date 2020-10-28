import 'package:WMR/models/user.dart';
//import 'package:WMR/models/token.dart';
//import 'package:WMR/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:WMR/screens/rules/providers.dart';
//import "package:shared_preferences/shared_preferences.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final _st = FlutterSecureStorage();

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  //final FirebaseAuth test = _auth.currentUser().getIdTokenResult(true);
  //final FirebaseAuth _token = FirebaseAuth.;

  // create user obj based on firebase user
  //User _userFromFirebaseUser(FirebaseUser user) {
  AuthUser _userFromFirebaseUser(User user) {
    return user != null ? AuthUser(uid: user.uid) : null;
  }

//   addTokenToSF(token) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   prefs.setString('token', token);
// } 

// removeTokenFromSF() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.remove('token');
//   return true;
// }

// Token _tokenFromFirebaseUser(Token token) {
//     return token != null ? Token(token: token.token) : null;
//   }

  // auth change user stream
  // Stream<AuthUser> get user {
  //   //return _auth.onAuthStateChanged
  //   return _auth.authStateChanges.map(AuthUser);
  //       //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        
  //       //.map(_userFromFirebaseUser);
  // }

// Stream<Token> get token {
//     return _auth.onAuthStateChanged
//         //.map((FirebaseUser user) => _userFromFirebaseUser(user));
//         .map(_tokenFromFirebaseUser);
//   }

  // sign in anon
  Future signInAnon() async {
    try {
      dynamic result = await _auth.signInAnonymously();
      //FirebaseUser user = result.user;
      User user = result.user;
      
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {

    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).user;
          

    // try {
    //   //AuthResult result = await _auth.signInWithEmailAndPassword(
    //   dynamic result = await _auth.signInWithEmailAndPassword(
    //       email: email, password: password);
    //   User user = result.user;
      //FirebaseUser user = result.user;
      // IdTokenResult _token =  await user.getIdToken();
      // String token = _token.token;
      //Provider.of<Token>(context, listen: false).saveToken(token);
      //print("Token: $token");

      //await addTokenToSF(token);

      //Token();
      
      //Token();
      //return user;
      //return _userFromFirebaseUser(user);
      //dynamic _token = await user.getIdToken();
      //dynamic _token = await user.getIdToken();

      //String token = _token;
      //print("Token: $_token");
      return user;
    } catch (error) {
      print("Sign in error: ${error.message}");
      return null;
    }
  }

  //register with email and password

//void _register() async {
Future registerWithEmailAndPassword(String email, String password) async {
    try {
    final User user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )).user;
        
    if (user != null) {
        return user.uid;
      }  
    } catch(error) {
        print("Register Error: ${error.message}");
        return "ERROR: ${error.message}";
 } 
  
}


  Future registerWithEmailAndPassword2(String email, String password) async {
    try {
      dynamic result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      AuthUser uid =  _userFromFirebaseUser(user);
      return uid.uid;
    } catch (error) {
      return Errors.show(error.code);
    }



    
  }

// @override
// Future<String> signIn(String email, String password) async {
//     FirebaseUser user = await  _auth.signInWithEmailAndPassword(email: email, password:password);
//     if (user.isEmailVerified) return user.uid;
//     return null;
// }

//Password Reset
//@override
Future<String> resetPassword(String email) async {
  try {
    await _auth.sendPasswordResetEmail(email: email);
    return 'Good';
  } catch (error) {
      return Errors.show(error.code);
    }
}


// Future<FirebaseUser> getCurrentUser() async {
//     FirebaseUser user = await _auth.currentUser();
//     return user;
//   }

// Future isUserLoggedIn() async {
//   //await _auth.signOut();
//   if (await _auth.currentUser() != null) {
//     return true;
// } else {
//     return false;
// }
// }

  // sign out
Future signOut() async {
    await _st.delete(key:'token');
    
    try {
      //removeTokenFromSF();
      return await _auth.signOut();
    } catch (error) {
      print("Signout Error: ${error.message}");
      //return null;
    }
  }
}

class Errors {
   static String show(error) {
      return "ERROR: ${error.message}";
   }
}


class Errors2 {
   static String show(String errorCode) {
     switch (errorCode) {
       case 'ERROR_EMAIL_ALREADY_IN_USE':
         return "ERROR: This e-mail address is already in use.";

       case 'ERROR_INVALID_EMAIL':
         return "ERROR: The email address is invalid";

      //  case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
      //    return "ERROR: The e-mail address in your Facebook account has been registered in the system before. Please login by trying other methods with this e-mail address.";

       case 'ERROR_WRONG_PASSWORD':
         return "ERROR: E-mail address or password is incorrect.";

       default:
         return "ERROR: An error has occurred";
     }
   }
}



////
// import 'package:apple_sign_in/apple_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthService {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   Stream<String> get onAuthStateChanged =>
//       _firebaseAuth.onAuthStateChanged.map(
//             (FirebaseUser user) => user?.uid,
//       );

//   // GET UID
//   Future<String> getCurrentUID() async {
//     return (await _firebaseAuth.currentUser()).uid;
//   }

//   // GET CURRENT USER
//   Future getCurrentUser() async {
//     return await _firebaseAuth.currentUser();
//   }

//   // Email & Password Sign Up
//   Future<String> createUserWithEmailAndPassword(String email, String password,
//       String name) async {
//     final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );

//     // Update the username
//     await updateUserName(name, authResult.user);
//     return authResult.user.uid;
//   }

//   Future updateUserName(String name, FirebaseUser currentUser) async {
//     var userUpdateInfo = UserUpdateInfo();
//     userUpdateInfo.displayName = name;
//     await currentUser.updateProfile(userUpdateInfo);
//     await currentUser.reload();
//   }

//   // Email & Password Sign In
//   Future<String> signInWithEmailAndPassword(String email,
//       String password) async {
//     return (await _firebaseAuth.signInWithEmailAndPassword(
//         email: email, password: password)).user.uid;
//   }

//   // Sign Out
//   signOut() {
//     return _firebaseAuth.signOut();
//   }

//   // Reset Password
//   Future sendPasswordResetEmail(String email) async {
//     return _firebaseAuth.sendPasswordResetEmail(email: email);
//   }

//   // Create Anonymous User
//   Future singInAnonymously() {
//     return _firebaseAuth.signInAnonymously();
//   }

//   Future convertUserWithEmail(String email, String password, String name) async {
//     final currentUser = await _firebaseAuth.currentUser();

//     final credential = EmailAuthProvider.getCredential(email: email, password: password);
//     await currentUser.linkWithCredential(credential);
//     await updateUserName(name, currentUser);
//   }

//   Future convertWithGoogle() async {
//     final currentUser = await _firebaseAuth.currentUser();
//     final GoogleSignInAccount account = await _googleSignIn.signIn();
//     final GoogleSignInAuthentication _googleAuth = await account.authentication;
//     final AuthCredential credential = GoogleAuthProvider.getCredential(
//       idToken: _googleAuth.idToken,
//       accessToken: _googleAuth.accessToken,
//     );
//     await currentUser.linkWithCredential(credential);
//     await updateUserName(_googleSignIn.currentUser.displayName, currentUser);
//   }

//   // GOOGLE
//   Future<String> signInWithGoogle() async {
//     final GoogleSignInAccount account = await _googleSignIn.signIn();
//     final GoogleSignInAuthentication _googleAuth = await account.authentication;
//     final AuthCredential credential = GoogleAuthProvider.getCredential(
//         idToken: _googleAuth.idToken,
//         accessToken: _googleAuth.accessToken,
//     );
//     return (await _firebaseAuth.signInWithCredential(credential)).user.uid;
//   }

//   // APPLE
//   Future signInWithApple() async {
//     final AuthorizationResult result = await AppleSignIn.performRequests([
//       AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
//     ]);

//     switch (result.status) {
//       case AuthorizationStatus.authorized:

//         final AppleIdCredential _auth = result.credential;
//         final OAuthProvider oAuthProvider = new OAuthProvider(providerId: "apple.com");

//         final AuthCredential credential = oAuthProvider.getCredential(
//             idToken: String.fromCharCodes(_auth.identityToken),
//             accessToken: String.fromCharCodes(_auth.authorizationCode),
//         );

//         await _firebaseAuth.signInWithCredential(credential);

//         // update the user information
//         if (_auth.fullName != null) {
//           _firebaseAuth.currentUser().then( (value) async {
//             UserUpdateInfo user = UserUpdateInfo();
//             user.displayName = "${_auth.fullName.givenName} ${_auth.fullName.familyName}";
//             await value.updateProfile(user);
//           });
//         }

//         break;

//       case AuthorizationStatus.error:
//         print("Sign In Failed ${result.error.localizedDescription}");
//         break;

//       case AuthorizationStatus.cancelled:
//         print("User Cancled");
//         break;
//     }
//   }

// }

// class NameValidator {
//   static String validate(String value) {
//     if (value.isEmpty) {
//       return "Name can't be empty";
//     }
//     if (value.length < 2) {
//       return "Name must be at least 2 characters long";
//     }
//     if (value.length > 50) {
//       return "Name must be less than 50 characters long";
//     }
//     return null;
//   }
// }

// class EmailValidator {
//   static String validate(String value) {
//     if (value.isEmpty) {
//       return "Email can't be empty";
//     }
//     return null;
//   }
// }

// class PasswordValidator {
//   static String validate(String value) {
//     if (value.isEmpty) {
//       return "Password can't be empty";
//     }
//     return null;
//   }
// }

///

