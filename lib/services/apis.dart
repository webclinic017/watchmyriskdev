import 'package:WMR/services/auth.dart';
//import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';

import 'package:finance_quote/finance_quote.dart';
//import 'package:flutter_secureSS/flutter_secure_storage.dart';
//import 'package:WMR/shared/storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
final _st = FlutterSecureStorage();



final AuthService _auth = AuthService();

//import 'package:WMR/shared/globals.dart' as globals;

//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:provider/provider.dart';
//import 'package:my_app/utils.dart';

//SS _storage = SS();

void signOut() async {
  //print("Signing Out");
  await _auth.signOut();
  await Get.toNamed('/sign_in');
}

Future sendUserSMS(countryCode, phoneNumber) async {
  final http.Response response =
      await http.post("https://www.watchmyrisk.com/api/v1/accounts",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "sms_user": "+$countryCode"+"$phoneNumber",
            "secret_key":
                "hDXEgUpMBjpwI1ixzkhbwHvuyNYeOVR2sSdk3FSBl0QYAzZxbclaCiUwi13ixpYv",
          }));
  //print("Status Code: ${response.statusCode} ");
  if (response.statusCode == 200) {
    Map ret = jsonDecode(response.body);
    return ret['code'];
  } else if (response.statusCode == 401) {
    return response.reasonPhrase;
  } else {
    return "Couldn't sms the user";
  }
  //return null;
}

Future getAccounts() async {
  //final token = await _storage.read('token');
  final token = await _st.read(key:'token');
  final fcmToken = await _st.read(key:'fcmToken');
  //print("FCM: $fcmToken");

  final response = await http.get(
    //'https://www.watchmyrisk.com/api/v1/accounts?account_id=1',
    'https://www.watchmyrisk.com/api/v1/accounts?ft=$fcmToken',
    headers: {HttpHeaders.authorizationHeader: token},
  );
    //print("Code:${response.statusCode}");
    if (response.statusCode == 401) {
      signOut();
      
    } else if (response.statusCode == 200) {
      //final data = json.decode(response.body);
      List<dynamic> data = json.decode(response.body);
      //final data = response.body;
      //print("Data: $data");
      return data;
    }
  
}



Future<String> addAlpacaAccount(String accountName, String endpoint,
    String apiKeyId, String secretKey) async {
  final token = await _st.read(key:'token');

  //String token = await getTokenFromSF();
  final http.Response response =
      await http.post("https://www.watchmyrisk.com/api/v1/accounts",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "broker": "alpaca",
            "AccessToken": token,
            "use_email": "False",
            //"test_only": true,
            "notify_only": true,
            "account_name": accountName,
            "credentials": jsonEncode(
              <String, String>{
                "endpoint": endpoint,
                "api_key_id": apiKeyId,
                "secret_key": secretKey,
              },
            )
          }));
  if (response.statusCode == 401) {
    //print("Token expired");
    signOut();
  }

  if (response.statusCode == 200) {
    //Map ret = jsonDecode(response.body);
    return "Success";
  } else if (response.statusCode == 401) {
    //Broker Account Already Exists
    //Broker Credentials Were Wrong
    return response.reasonPhrase;
  } else {
    return "Couldn't connect to the server";
  }
  //return null;
}

Future<String> addRobinhoodAccount(
    String accountName, String userName, String password, bool bySMS) async {
  final token = await _st.read(key:'token');

  //String token = await getTokenFromSF();
  final http.Response response =
      await http.post("https://www.watchmyrisk.com/api/v1/accounts",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "broker": "robinhood",
            "AccessToken": token,
            "use_email": "False",
            //"test_only": true,
            "notify_only": true,
            "account_name": accountName,
            "credentials": jsonEncode(
              <String, dynamic>{
                "username": userName,
                "password": password,
                "by_sms": bySMS,
                "challenge_code": null,
              },
            )
          }));
  
  if (response.statusCode == 200) {
    Map ret = jsonDecode(response.body);
    return ret["send_code"].toUpperCase();
  } else if (response.statusCode == 401) {
    //Broker Account Already Exists
    //Broker Credentials Were Wrong
    return response.reasonPhrase;
  } else {
    return "Couldn't connect to the server";
  }
  //return null;
}

Future<String> sendCodeToRobinhood(String smsCode, resend) async {
  //String token = await getTokenFromSF();

  final token = await _st.read(key:'token');

  final http.Response response =
      await http.post("https://www.watchmyrisk.com/api/v1/accounts",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "broker": "robinhood",
            "AccessToken": token,
            "use_email": "False",
            "test_only": false,
            "notify_only": true,
            "credentials": jsonEncode(
              <String, dynamic>{
                "challenge_code": smsCode,
                "resend": resend,
              },
            )
          }));
  
  if (response.statusCode == 200) {
    //Map ret = jsonDecode(response.body);
    return "Account Added Successfully!";
  } else if (response.statusCode == 401) {
    print("Token expired");

    //Wrong code
    //Max Reties Reache:w
    //print("401 status with reason ${response.reasonPhrase}");
    return response.reasonPhrase;
  } else {
    return "Couldn't add the account";
  }
  //return null;
}

Future<http.Response> editAccount(account) async {
  final token = await _st.read(key:'token');

  final http.Response response =
      await http.put("https://www.watchmyrisk.com/api/v1/accounts",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "AccessToken": token,
            "use_email": "False",
            "account": jsonEncode(account),
          }));
  if (response.statusCode == 401) {
    signOut();
  }
  if (response.statusCode == 200) {
    //print("Response: $response");
    return response;
  }
  return null;
}

Future<http.Response> deleteAccount(account) async {
  final token = await _st.read(key:'token');

  final http.Response response =
      await http.put("https://www.watchmyrisk.com/api/v1/accounts",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "AccessToken": token,
            "use_email": "False",
            "action": "delete",
            "account": jsonEncode(account),
          }));
  if (response.statusCode == 401) {
    signOut();
  }
  if (response.statusCode == 200) {
    //print("Response: $response");
    return response;
  }
  return null;
}

Future<http.Response> addWatchlist(wlName) async {
  
  final token = await _st.read(key:'token');

  final http.Response response =
      await http.post("https://www.watchmyrisk.com/api/v1/watchlists",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "AccessToken": token,
            "use_email": "False",
            "action": "add",
            "account_name": wlName,
          }));
  if (response.statusCode == 401) {
    signOut();
  }
  //print("Response: $response");
  if (response.statusCode == 200) {
    //print("Response: $response");
    return response;
  }
  return null;
}



Future<http.Response> editWatchlist(watchlist) async {
  //print("Editting a watchlist");
  final token = await _st.read(key:'token');

  final http.Response response =
      await http.put("https://www.watchmyrisk.com/api/v1/watchlists",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "AccessToken": token,
            "use_email": "False",
            "action": "edit",
            "watchlist": jsonEncode(watchlist),
          }));
  if (response.statusCode == 401) {
    signOut();
  }
  if (response.statusCode == 200) {
    //print("Response: $response");
    return response;
  }
  return null;
}

Future<http.Response> deleteWatchlist(watchlist) async {
  final token = await _st.read(key:'token');

  final http.Response response =
      await http.put("https://www.watchmyrisk.com/api/v1/watchlists",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "AccessToken": token,
            "use_email": "False",
            "action": "delete",
            "watchlist": jsonEncode(watchlist),
          }));
  if (response.statusCode == 401) {
    signOut();
  }
  if (response.statusCode == 200) {
    //print("Response: $response");
    return response;
  }
  return null;
}

Future<http.Response> editWhitelist(account, rule, whitelist) async {
  //print("Editting a whitelist");
  final token = await _st.read(key:'token');

  int ruleId;
  if (rule != null) {
    ruleId = rule['rule_id'];
  } else {
    ruleId = null;
  }
  // The account has a field 'whitelist' that contains the list of symbols
  final http.Response response =
      await http.put("https://www.watchmyrisk.com/api/v1/whitelists",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "AccessToken": token,
            "use_email": "False",
            //"action":"edit",
            "account": jsonEncode(account),
            "rule_id": ruleId,
            "whitelist": whitelist,
          }));
  if (response.statusCode == 401) {
    signOut();
  }
  if (response.statusCode == 200) {
    //print("Response: $response");
    return response;
  }
  return null;
}

Future updateWatchlist(account) async {
  List watchlist = account['watchlist'];
  List <String>tickers = [];
  watchlist.forEach((h) {
    tickers.add(h[0]);
  });
  print("Tickers: $tickers");
  Map<String, Map<String, dynamic>> quoteRaw = {};
  Map<String, dynamic> quotes = {};
  quoteRaw = await FinanceQuote.getRawData(quoteProvider: QuoteProvider.yahoo, symbols: tickers); 
  if (quoteRaw.length == tickers.length) {
    tickers.forEach((ticker) {
      quotes[ticker] = quoteRaw[ticker]['regularMarketPrice'];
    });
    return quotes;
  
    } else {
      return {};
    }
}
  //quoteRaw.forEach((k,v) => print('$k: $v'));
  


//Future<void> getQuote(List<String> arguments) async {
Future<Map> getQuote(ticker) async {
  Map<String, Map<String, dynamic>> quoteRaw = {};
  try {
    quoteRaw = await FinanceQuote.getRawData(
        quoteProvider: QuoteProvider.yahoo, symbols: <String>[ticker]);
  } catch (e) {
    return null;
  }
  Map ret = quoteRaw[ticker];
  //ret.forEach((k,v) => print('${k}: ${v}'));
  if (ret == null) return null;
  Map resp = {};
  resp['symbol'] = ret['shortName'];
  resp['price'] = ret['regularMarketPrice'];
  //String name = ret['shortName'];
  //print("Short Name: $name");
  //return name;
  return resp;
  // print('Number of quotes retrieved: ${quoteRaw.keys.length}.');
  // print(
  //     'Number of attributes retrieved for KO: ${quoteRaw['KO'].keys.length}.');
  // print(
  //     'Current market price for KO: ${quoteRaw['GOOG']['regularMarketPrice']}.');
  // print(
  //     'Number of attributes retrieved for GOOG: ${quoteRaw['GOOG'].keys.length}.');
  // print(
  //     'Current market price for KO: ${quoteRaw['GOOG']['regularMarketPrice']}.');
}

Future sendMessage(category, text) async {
  final token = await _st.read(key:'token');

  final http.Response response =
      await http.post("https://www.watchmyrisk.com/api/v1/contact",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "AccessToken": token,
            "type": category,
            "message": text,
          }));
  //print("Status Code: ${response.statusCode} ");
  if (response.statusCode == 401) {
    signOut();
  }
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
  //return null;
}

Future sendInvite(text) async {
  final token = await _st.read(key:'token');

  final http.Response response =
      await http.post("https://www.watchmyrisk.com/api/v1/invite",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "AccessToken": token,
            "phone_numbers": text,
          }));
  //print("Status Code: ${response.statusCode} ");
  if (response.statusCode == 401) {
    signOut();
  }
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
  //return null;
}

Future getTransactions(count, accountId) async {
  final token = await _st.read(key:'token');

  //Timer(Duration(seconds: 1), () {

  //String token = await getTokenFromSF();
  if (accountId == null) {
    accountId = "None";
  }
   final response = await http.get(
    //'https://www.watchmyrisk.com/api/v1/accounts?account_id=1',
    'https://www.watchmyrisk.com/api/v1/transactions?account_id=$accountId&limit=$count',
    headers: {HttpHeaders.authorizationHeader: token},
  );
    //print("Code:${response.statusCode}");
    if (response.statusCode == 401) {
      signOut();
    } else if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    }
  
}



Future getActivities(count, accountId) async {
  final token = await _st.read(key:'token');
  final response =  await http.get(
    'https://www.watchmyrisk.com/api/v1/activities?account_id=$accountId&limit=$count',
    headers: {HttpHeaders.authorizationHeader: token},
  );
    //print("Code:${response.statusCode}");
    if (response.statusCode == 401) {
      signOut();
    } else if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    }
 
}

  

Future getHoldings(account) async {
  final token = await _st.read(key:'token');
  final broker = account['broker'];
  final accountId = account['account_id'];
  final response = await http.get(
    'https://www.watchmyrisk.com/api/v1/holdings?account_id=$accountId&broker=$broker',
    headers: {HttpHeaders.authorizationHeader: token},
  );
    //print("Code:${response.statusCode}");
    if (response.statusCode == 401) {
      signOut();
    } else if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    }
 
}



Future<String> addUserAccount(
    String userId, String name, String email, String countryCode, String phoneNumber) async {
  //String token = await _storage.read('token');

  //String token = await getTokenFromSF();
  final http.Response response =
      await http.post("https://www.watchmyrisk.com/api/v1/users",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "user_id": userId,
            "first_name": name,
            //"AccessToken": token,
            "email": email,
            //"test_only": true,
            "phone_number": phoneNumber,
            "country_code": countryCode,
          }));

  if (response.statusCode == 200) {
    //Map ret = jsonDecode(response.body);
    return "Success";
  } else if (response.statusCode == 401) {
    //Broker Account Already Exists
    //Broker Credentials Were Wrong
    return response.reasonPhrase;
  } else {
    return "Couldn't connect to the server";
  }
  //return null;
}

Future getRules(account) async {
  final token = await _st.read(key:'token');
  String accountId;
  if (account == 'Description') {
    accountId = account;
  } else {
  accountId = account['account_id'];
  }
  final response = await http.get(
    'https://www.watchmyrisk.com/api/v1/rules?account_id=$accountId',
    headers: {HttpHeaders.authorizationHeader: token},
  );
    //print("Code:${response.statusCode}");
    if (response.statusCode == 401) {
      signOut();
    } else if (response.statusCode == 200) {
      final data = json.decode(response.body);
      //print("Rules:$data");
      return data;
    }
  
}



Future<http.Response> updateRule(rule) async {
  final token = await _st.read(key:'token');

  //String token = await getTokenFromSF();
  // print("Min Val: $minVal");
  // print("Max Val: $maxVal");

  final http.Response response =
      await http.put("https://www.watchmyrisk.com/api/v1/rules",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "AccessToken": token,
            "use_email": "False",
            "rule": jsonEncode(rule),
          }));
  if (response.statusCode == 401) {
    signOut();
  } else if (response.statusCode == 200) {
    return response;
  }
  return null;
}

// Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
//   if (message.containsKey('data')) {
//     // Handle data message
//     final dynamic data = message['data'];
//   }

//   if (message.containsKey('notification')) {
//     // Handle notification message
//     final dynamic notification = message['notification'];
//   }

//   // Or do other work.
// }
