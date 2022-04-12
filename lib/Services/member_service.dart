import 'dart:convert';
import 'package:fariji_flutter_mobile_app/Model/accounts_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

AccountsResponseModel? accountModel;

@override
void initState() {
  //super.initState();
  accountModel = AccountsResponseModel();
}

getMemberInfo() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('Token') ?? '';
  final mobileNo = prefs.getString('telephone') ?? '';

  Map data = {
    "mobile_no": mobileNo
  };
  //print(data);
  final  response= await http.post(
    Uri.parse("https://suresms.co.ke:4242/mobileapi/api/GetmemberInfo"),
    headers: {
      "Accept": "application/json",
      "Token": token
    },
    body: json.encode(data),
  );
  final resp = jsonDecode(response.body);
  //print(response.body);
  if (response.statusCode == 200) {
    //print(response.body);

    Map<String,dynamic>res=jsonDecode(response.body);
    //print(res['Name']);
    prefs.setString('Name', res['Name']);
    prefs.setString('AccNo', res['AccountNumber']);
    prefs.setString('Account_Type', res['Account_Type']);
    prefs.setDouble('Account_Balance', res['Account_Balance']);

    final resp = json.decode(response.body);
    accountModel = AccountsResponseModel.fromJson(resp);
    print(accountModel!.memberNo);
    return AccountsResponseModel.fromJson(resp);

  } else if (response.statusCode == 401) {
    //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
  else {
    Map<String,dynamic>res=jsonDecode(response.body);
    Fluttertoast.showToast(msg: "${res['Description']}");
  }
  return response.body;
}