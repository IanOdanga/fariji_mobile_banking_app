import 'dart:convert';
import 'package:fariji_flutter_mobile_app/Model/token_model.dart';
import 'package:fariji_flutter_mobile_app/Screens/login_screen.dart';
import 'package:fariji_flutter_mobile_app/Services/storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> purchaseAirtime(amount, otp) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('Token') ?? '';
  final mobileNo = prefs.getString('telephone') ?? '';
  Map data = {
    "mobile_no": mobileNo,
    "amount": amount,
    "otp": otp
  };

  print(data);
  final response= await http.post(
    Uri.parse("https://suresms.co.ke:4242/mobileapi/api/AirtimePurchase"),
    headers: {
      "Accept": "application/json",
      "Token": token
    },
    body: json.encode(data),
  );
  //print(response.body);
  print(response.body);
  if (response.statusCode == 200) {
    return true;
  }
  else {
    return false;
  }
}