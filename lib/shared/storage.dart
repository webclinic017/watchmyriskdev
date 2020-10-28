import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
//import 'package:shared_preferences/shared_preferences.dart';


final _storage = new FlutterSecureStorage();



class SS {
Future<String> read(String key) async{
  final val = await _storage.read(key: key);
  return json.decode(val);
}

Future<void> write (String key, value) async {
  //print("Storing $key : $value");
  await _storage.write(key: key, value: json.encode(value));
}

Future<void> delete(String key) async {
  await _storage.delete(key: key);
}

Future<void> deleteAll() async {
  await _storage.deleteAll();
}
}


// class SP {
//   read(String key) async {
//     final prefs = await SharedPreferences.getInstance();
//     return json.decode(prefs.getString(key));
//   }

//   save(String key, value) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString(key, json.encode(value));
//   }

//   remove(String key) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.remove(key);
//   }
// }

int castInt(s) {
  return int.parse(s);
}