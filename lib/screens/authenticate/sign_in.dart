import 'dart:io';
import 'package:WMR/local_database/app_preferences.dart';
import 'package:WMR/services/auth.dart';
import 'package:WMR/shared/constants.dart';
import 'package:WMR/shared/loading2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:auto_size_text/auto_size_text.dart';
//import 'package:upgrader/upgrader.dart';

//import 'package:WMR/shared/globals.dart' as globals;
//import 'package:WMR/shared/size_config.dart';
import 'package:WMR/services/apis.dart';

//import 'package:WMR/screens/home/expired.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//import 'package:global_configuration/global_configuration.dart'

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier_provider.dart';

//SS _storage = SS();
class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //final _storage.SS = new FlutterSecureStorage();

  String error;
  bool loading = false;
  bool _saveEmail = false;
  bool _forgotPassword = false;
  int numAccounts;
  int numWatchlists;
  int initialTab = 0;
  int delay = 1500;
  String email;

  //bool _read = false;

  final _st = FlutterSecureStorage();

  String _message = '';
  String firebaseToken = "";

  AppPreferences appPreferences = AppPreferences();
  Notifier _notifier;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  /* GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );*/
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    loading = true;
    _readAll();
    super.initState();
    /*getMessage();
    if (Platform.isIOS) iosPermission();
    _firebaseMessaging.getToken().then((token) => _setToken(token));
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);*/
  }

  void iosPermission() {
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
        sound: true, badge: true, alert: true, provisional: false));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    // _firebaseMessaging.configure();
  }

  void _setToken(token) {
    //print("FCM Token::" + token);
    //appPreferences.setFirebaseToken(token: token);
    _st.write(key: 'fcmToken', value: token.toString());
    firebaseToken = token;
  }

  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
      _notifier.notify('action', message);
      showNotification(
          message['notification']['title'], message['notification']['body']);
      setState(() => _message = message["notification"]["title"]);
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() => _message = message["notification"]["title"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() => _message = message["notification"]["title"]);
    });
  }

  // @override
  // void initState() {
  //   loading = true;
  //   _readAll();
  //   super.initState();
  // }

  Future<Null> _readAll() async {
    await _st.delete(key: 'token');
    await _st.delete(key: 'user');
    //await _st.delete(key: 'is_new');
    await _st.read(key: 'email').then((e) {
      setState(() {
        if (e != null) {
          email = e.toString();
          _saveEmail = true;
        } else {
          email = '';
          _saveEmail = false;
        }
      });
      loading = false;
    });
  }

  // void _deleteAll() async {
  //   await _st.deleteAll();
  //   _readAll();
  // }

  // Future<String> loadSettingsFuture; // <-Add this

  // @override
  // void initState() {
  //   loadSettingsFuture = _deleteAll(); // <- Change This
  //   //accountIndex = _items['accountIndex'];

  //   super.initState();
  // }

  // Future<Null> _deleteAll() async {
  //   //await _storage.deleteAll();
  //   //sEmail = await _storage.read("email");
  //   sEmail = await _storage.read("token");
  //   await _storage.delete("token");
  // }

  // text field state
  // String email = 'demo@watchmyrisk.com';
  // String password = '*1Demo123';

  //String email = 'test22@watchmyrisk.com';
  //String password = 'tester';

  //String email = '';
  //Future<String> sEmail = _storage.read("email");
  //final storage = new FlutterSecureStorage();

// Read value

  String password = '';

  //String email = '';

  bool _validate() {
    final form = _formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      if (_saveEmail) {
        _st.write(key: 'email', value: email);
      } else {
        _st.delete(key: 'email');
      }
      return true;
    } else {
      _st.delete(key: 'email');
      return false;
    }
  }

  Widget showError() {
    //print(error);
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

  Future storeData() async {
    loading = true;
    List accounts = await getAccounts();
    // String accountNames = "";
    // accounts.forEach((account) {
    //   accountNames += account['name'] + ',';

    //  });
    //List watchLists = await getWatchlists();
    // print("Storing data. LA: ${accounts.length}");
    // print("Storing data. WL: ${watchLists.length}");
    //await _storage.write('numAccounts', accounts.length);
    //await _storage.write('accountNames', accountNames);
    //await _storage.write('numManualPortfolios', watchLists.length);
    //await _storage.write('tIndex', 0);

    // if (accounts.length > 0 ) {
    //     //await _storage.write('numLinkedAccounts', accounts.length);
    //     await _storage.write('tIndex', 1);
    //     await _storage.write('account', accounts[0]);
    //     await _storage.write('accountIndex', 0);
    //     await _storage.write('defaultAccount', accounts[0]);
    //}
    // if (watchLists.length > 0 )    {
    //     await _storage.write('watchlistIndex', 0);
    //     //await _storage.write('numManualPortfolios', watchLists.length);
    //     await _storage.write('watchlist', watchLists[0]);
    //     await _storage.write('defaultWatchlist', watchLists[0]);
    // }

    loading = false;
    return accounts.length;
  }

  Widget showMessage() {
    if (_forgotPassword) {
      return Text(
          "Please submit your email. You will receive an email, allowing you to change your password.");
    } else {
      return SizedBox(
        height: 0.0,
      );
    }
  }

  Widget showPassword() {
    return Visibility(
      child: Column(
        children: [
          TextFormField(
            initialValue: "",
            //initialValue: "tester",
            //initialValue: "*1Demo123",
            obscureText: true,
            decoration: InputDecoration(
              hintText: "password",
            ),
            // validator: (value) =>
            //     value.length < 6 ? 'Enter a password 6+ chars long' : null,
            onSaved: (value) => password = value,
            // onChanged: (val) {
            //   setState(() => password = val);
            // },
          ),
          SizedBox(height: h2),
        ],
      ),
      visible: !_forgotPassword,
    );
  }

  Widget showForgotText() {
    if (_forgotPassword) {
      return GestureDetector(
          child: Text(
            "Sign in",
            style: TextStyle(color: Colors.lightBlueAccent),
          ),
          onTap: () {
            //print("Changing password");
            setState(() => _forgotPassword = false);
          });
    } else {
      return Column(
        children: [
          GestureDetector(
              child: Text(
                "Forgot my password",
                style: TextStyle(color: Colors.lightBlueAccent),
              ),
              onTap: () {
                //print("Changing password");
                setState(() => _forgotPassword = true);
              }),
          SizedBox(
            height: 30,
          ),
          Text("Don't have an account yet?"),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
              child: Text(
                "Sign up here",
                style: TextStyle(color: Colors.lightBlueAccent),
              ),
              onTap: () {
                //print("Changing password");
                Navigator.of(context).pushReplacementNamed('/sign_on');
              }),
          SizedBox(
            height: 20,
          ),
          Text("Or", style: titleStyle()),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/sign_in_demo');
            }, // handle your image tap here
            child: Text("Check it out with our demo account",
                style: infoStyle().copyWith(fontSize: 12)),

            // Image.asset(
            //   'assets/WatchItLive.jpg',

            //   //fit: BoxFit.cover, // this is the solution for border
            // ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/intro');
            }, // handle your image tap here
            child: Text("See intro", style: infoStyle().copyWith(fontSize: 12)),

            // Image.asset(
            //   'assets/WatchItLive.jpg',

            //   //fit: BoxFit.cover, // this is the solution for border
            // ),
          ),
        ],
      );
    }
  }

  Widget showSubmit() {
    if (_forgotPassword) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: h3,
          ),
          RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                //side: BorderSide(color: Colors.red)
              ),
              color: Colors.grey[600],
              child: Text(
                'Submit',
                style: white_14(),
              ),
              onPressed: () async {
                if (_validate()) {
                  //setState(() => loading = true);
                  //setState(() => _forgotPassword = false);

                  //await _auth.signInWithEmailAndPassword(email, password);
                  dynamic result = await _auth.resetPassword(email);
                  //print("Result:$result");
                  if (!(result.startsWith("ERROR: "))) {
                    Flushbar(
                      //padding: EdgeInsets.fromLTRB(100, 0, 0, 0),
                      flushbarPosition: FlushbarPosition.TOP,
                      backgroundColor: Colors.lightBlue[700],
                      titleText: Center(
                          child: Text("Please check your email!",
                              style: white14Bold())),
                      messageText: Center(
                          child: Text(
                        "",
                        style: titleStyle(),
                      )),
                      duration: Duration(seconds: 5),
                    )..show(context);
                    Future.delayed(Duration(milliseconds: 3000), () async {
                      setState(() => _forgotPassword = false);

                      //await Navigator.of(context).pushReplacementNamed('/sign_in');
                    });
                  } else {
                    String _error = result.replaceAll('ERROR: ', '');
                    setState(() {
                      loading = false;
                      error = _error;
                    });
                  }
                }
              }),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Remember my email", style: white_10()),
          Checkbox(
            value: _saveEmail,
            onChanged: (value) {
              setState(() {
                _saveEmail = value;
              });
            },
            //  activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.grey[800],
            checkColor: Colors.greenAccent,
          ),
          SizedBox(width: w4),
          RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                //side: BorderSide(color: Colors.red)
              ),
              color: Colors.grey[600],
              child: Text(
                'Sign In',
                style: white_14(),
              ),
              onPressed: () async {
                if (_validate()) {
                  setState(() => loading = true);
                  dynamic result =
                      await _auth.signInWithEmailAndPassword(email, password);

                  if (result == null) {
                    //print("Bad credentials");
                    setState(() {
                      loading = false;
                      error =
                          'Could not sign in with those credentials. Please try again.';
                    });
                  } else {
                    String token = await result.getIdToken();
                    //IdTokenResult _token = await result.getIdToken();
                    //String token = _token.token;
                    _st.write(key: 'token', value: token.toString());
                    _st.write(key: 'user', value: null);
                    _st.write(key: 'is_new', value: 'No');

                    //List accounts = await getAccounts();
                    // if (accounts.length > 0 ){
                    await Navigator.of(context).pushReplacementNamed('/home');
                  }
                }
              }),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _notifier = NotifierProvider.of(context);
    print("Message:$_message");
    // Only call clearSavedSettings() during testing to reset internal values.
    //Upgrader().clearSavedSettings();
    // final appcastURL = 'https://www.watchmyrisk.com/upgrader/appcast.xml';
    // final cfg = AppcastConfiguration(url: appcastURL, supportedOS: ['android']);

    // final _width = MediaQuery.of(context).size.width;
    // final _height = MediaQuery.of(context).size.height;

    //final user_token = Provider.of<Token>(context);
    //return loading
    if (loading == true) {
      return Loading();
    } else {
      SizeConfig().init(context);
      //print("Email: $email, save:$_saveEmail");
      var children2 = <Widget>[
        Container(
          height: 80,
          width: 100,
          //color:Colors.blue,
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              image: AssetImage(
                //'assets/WMR_40x40.png',
                'assets/WMR.png',
              ),
              fit: BoxFit.contain,
            ),
            shape: BoxShape.rectangle,
          ),
        ),
        SizedBox(height: h1),
        Text(
          'Watch My Risk',
          style: white14Bold(),
        ),
        SizedBox(height: h2),

        showError(),
        showMessage(),
        //SizedBox(height: h2),
        // TextFormField(
        //   validator: NameValidator.validate,
        //   style: TextStyle(fontSize: 22.0),
        //   decoration: buildSignUpInputDecoration("Name"),
        //   onSaved: (value) => email = value,
        // ),

        // TextFormField(
        //   validator: EmailValidator.validate,
        //   style: TextStyle(fontSize: 22.0),
        //   //decoration: buildSignUpInputDecoration("Email"),
        //   onSaved: (value) => email = value,
        // ),

        TextFormField(
          //initialValue: "demo@watchmyrisk.com",
          //initialValue: "test22@watchmyrisk.com",
          initialValue: email,
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'email',
          ),
          validator: (val) => val.isEmpty ? 'Enter an email' : null,
          onSaved: (value) => email = value,
          // onChanged: (val) {
          //   setState(() => email = val);
          // },
        ),

        showPassword(),
        //SizedBox(height: h5),
        showSubmit(),
        SizedBox(
          height: h3,
        ),
        showSocialAuthentication(),
        SizedBox(
          height: h3,
        ),
        showForgotText(),
      ];
      return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          //child: ChangeNotifierProvider(
          //child: (
          //create: (context) => WmrProviders(),
          //create: (context) => Accounts(),
          child: Scaffold(
            //backgroundColor: Colors.brown[100],
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              centerTitle: true,
              // No Back Arrow
              titleSpacing: 0.0,
              automaticallyImplyLeading: false,
              //backgroundColor: Colors.lightBlueAccent[800],
              elevation: 0.0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton.icon(
                      icon: Icon(Icons.info),
                      label: Text('About'),
                      //onPressed: () => widget.toggleView(),
                      onPressed: () {
                        //Navigator.of(context).pushReplacementNamed('/about');
                        Navigator.of(context).pushReplacementNamed('/about');
                      }),
                  SizedBox(width: 20.0),
                  FlatButton.icon(
                      icon: Icon(Icons.person),
                      label: Text('Register'),
                      //onPressed: () => widget.toggleView(),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/sign_on');
                      }),
                ],
              ),

              // actions: <Widget>[
              //   FlatButton.icon(
              //       icon: Icon(Icons.person),
              //       label: Text('Register'),
              //       //onPressed: () => widget.toggleView(),
              //       onPressed: () {
              //         Navigator.of(context).pushReplacementNamed('/sign_on');
              //       }),
              // ],
            ),
            //body: UpgradeAlert(
            //appcastConfig: cfg,
            //child: Container(
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: children2,
                  ),
                ),
              ),
            ),
          ));
    }
  }

  void showNotification(String title, String body) async {
    await _demoNotification(title, body);
  }

  Future<void> _demoNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.Max,
        playSound: true,
        showProgress: true,
        priority: Priority.High,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'test');
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }

  showSocialAuthentication() {
    return GestureDetector(
        child: Image.asset(
          'assets/ic_google.png',
          width: 80,
          height: 80,
          fit: BoxFit.fill, // this is the solution for border
        ),
        onTap: () async {
          signInWithGoogle().whenComplete(() async {
            var user = FirebaseAuth.instance.currentUser;
            setState(() => loading = true);

            if (user == null) {
              print(user.uid);
              setState(() {
                loading = false;
                error =
                    'Could not sign in with those credentials. Please try again.';
              });
            } else {
              String token = await user.getIdToken();
              _st.write(key: 'token', value: token.toString());
              _st.write(key: 'user', value: null);
              _st.write(key: 'is_new', value: 'No');
              _st.write(key: 'user_type', value: 'google');
              await Navigator.of(context).pushReplacementNamed('/home');
            }
          });
          // UserCredential userCredential = await signInWithGoogle();
          // print("Token:::" + userCredential.credential.token.toString());
        });
  }

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    final UserCredential authResult =
        await auth.signInWithCredential(credential);
    final User user = authResult.user;

    print("Email::" + user.email);
    print("displayName::" + user.displayName);

    return user;
  }
}
