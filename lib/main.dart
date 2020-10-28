import 'package:WMR/local_database/app_preferences.dart';
import 'package:WMR/screens/accounts/brokers/robinhood.dart';
import 'package:WMR/screens/accounts/brokers/alpaca.dart';
import 'package:WMR/screens/authenticate/sign_in.dart';
import 'package:WMR/screens/authenticate/sign_in_demo.dart';
import 'package:WMR/screens/authenticate/register.dart';
import 'package:WMR/screens/home/home.dart';
import 'package:WMR/screens/home/intro.dart';
import 'package:WMR/screens/home/expired.dart';

//import 'package:WMR/screens/home/sandbox.dart';
//import 'package:WMR/screens/welcome.dart';
//import 'package:WMR/screens/home/linked_accounts.dart';
import 'package:WMR/screens/home/new_user.dart';

//import 'package:WMR/screens/home/manual_accounts.dart';
import 'package:WMR/screens/accounts/detailed_transactions.dart';
import 'package:WMR/screens/accounts/activity_logs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//import 'package:WMR/screens/home/sandbox.dart';
import 'package:flutter/material.dart';
import 'package:WMR/screens/rules/rules.dart';

//import 'package:WMR/screens/rules/edit_rule.dart';
import 'package:WMR/screens/home/wrapper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//import 'package:WMR/screens/wrapper.dart';
//import 'package:WMR/services/auth.dart';
//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'package:WMR/models/user.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

// Drawer
import 'package:WMR/screens/home/drawer/about.dart';
import 'package:WMR/screens/home/drawer/how_tos.dart';
import 'package:WMR/screens/home/drawer/disclaimer.dart';
import 'package:WMR/screens/home/drawer/rules_description.dart';
import 'package:WMR/screens/home/drawer/contact.dart';
import 'package:WMR/screens/home/drawer/invite.dart';
import 'package:notifier/notifier_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(NotifierProvider(
    // child:MyApp(),
    child: new MaterialApp(
        debugShowCheckedModeBanner: false, home: MyApplication()),
    //),
  ));
}

class MyApplication extends StatefulWidget {
  @override
  MyApplicationState createState() => MyApplicationState();
}

class MyApplicationState extends State<MyApplication> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  AppPreferences appPreferences = AppPreferences();
  String firebaseToken = "";
  String _message = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _firebaseMessaging.getToken().then((token) => _setToken(token));

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    getMessage();
  }

  void _setToken(token) {
    print("FCM Token::==" + token);
    appPreferences.setFirebaseToken(token: token);
    firebaseToken = token;
  }

  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
      // _notifier.notify('action', message);
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    GetPage(name: '/expired', page: () => Expired());
    return GetMaterialApp(
        // StreamProvider<AuthUser>.value(
        //   value: AuthService().user,
        //   child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        //theme: ThemeData.light(),

        // theme: ThemeData(
        //     primaryColor: Colors.grey[900],
        //     //primaryColor: Colors.purple[800],
        //     accentColor: Colors.amber,
        //     accentColorBrightness: Brightness.dark
        //     ),
        //initialRoute: '/',

        initialRoute: '/wrapper',
        //initialRoute: '/sign_in',

        routes: {
          //'/': (context) => Wrapper(),
          '/sign_on': (context) => Register(),
          '/sign_in': (context) => SignIn(),
          '/sign_in_demo': (context) => SignInDemo(),
          '/home': (context) => Home(),
          '/intro': (context) => Intro(),
          '/wrapper': (context) => Wrapper(),
          //'/add_portfolio': (context) => AddPortfolio(),
          '/rules': (context) => Rules(),
          //'/edit_rule': (context) => EditRuleForm(),
          //'/linked_accounts': (context) => LinkedAccounts(),
          //'/manual_accounts': (context) => ManualAccounts(),
          '/robinhood': (context) => RobinhoodForm(),
          '/alpaca': (context) => AlpacaForm(),
          '/detailed_transactions': (context) => DetailedTransactions(),
          '/activity_logs': (context) => ActivityLogs(),
          // Drawer
          '/about': (context) => About(),
          '/how_tos': (context) => HowTos(),
          '/disclaimer': (context) => Disclaimer(),
          '/rules_description': (context) => RulesDescription(),
          '/contact': (context) => Contact(),
          '/invite': (context) => Invite(),
          '/new_user': (context) => NewUser(),
          '/expired': (context) => Expired(),

          //'/sandbox': (context) => MyHomePage(),
          //}),
        });
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
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    GetPage(name: '/expired', page: () => Expired());
    return GetMaterialApp(
        // StreamProvider<AuthUser>.value(
        //   value: AuthService().user,
        //   child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        //theme: ThemeData.light(),

        // theme: ThemeData(
        //     primaryColor: Colors.grey[900],
        //     //primaryColor: Colors.purple[800],
        //     accentColor: Colors.amber,
        //     accentColorBrightness: Brightness.dark
        //     ),
        //initialRoute: '/',

        initialRoute: '/wrapper',
        //initialRoute: '/sign_in',

        routes: {
          //'/': (context) => Wrapper(),
          '/sign_on': (context) => Register(),
          '/sign_in': (context) => SignIn(),
          '/sign_in_demo': (context) => SignInDemo(),
          '/home': (context) => Home(),
          '/intro': (context) => Intro(),
          '/wrapper': (context) => Wrapper(),
          //'/add_portfolio': (context) => AddPortfolio(),
          '/rules': (context) => Rules(),
          //'/edit_rule': (context) => EditRuleForm(),
          //'/linked_accounts': (context) => LinkedAccounts(),
          //'/manual_accounts': (context) => ManualAccounts(),
          '/robinhood': (context) => RobinhoodForm(),
          '/alpaca': (context) => AlpacaForm(),
          '/detailed_transactions': (context) => DetailedTransactions(),
          '/activity_logs': (context) => ActivityLogs(),
          // Drawer
          '/about': (context) => About(),
          '/how_tos': (context) => HowTos(),
          '/disclaimer': (context) => Disclaimer(),
          '/rules_description': (context) => RulesDescription(),
          '/contact': (context) => Contact(),
          '/invite': (context) => Invite(),
          '/new_user': (context) => NewUser(),
          '/expired': (context) => Expired(),

          //'/sandbox': (context) => MyHomePage(),
          //}),
        });
  }
}
