import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as https;

gettoken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String? getToken = await preferences.getString("auth_token");
  return getToken;
}
Future<void> setUserLogin(String auth_token) async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString("auth_token", auth_token);
  pref.setBool("is_login", true);
}

Future<bool?> isUserLogin() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getBool("is_login");
}

Future<String?> whileUserLogin() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString("auth_token");
}

Future<void> logout() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.remove("Name");
  pref.remove("Token");
  pref.remove("telephone");
  pref.remove("tokentime");
  pref.remove("Password");
}

