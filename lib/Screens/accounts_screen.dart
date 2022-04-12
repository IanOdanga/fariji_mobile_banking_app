import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Accounts extends StatefulWidget {
  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {

  final RefreshController refreshController =
  RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Accounts',
          style: TextStyle(
            color: Colors.black87,
            fontFamily: "Brand Bold",
          ),
        ),
        backgroundColor: const Color(0xFF1cb1df),
      ),
      body: FutureBuilder(
        future: getAccounts(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          Map<String, dynamic> map = json.decode(snapshot.data);
          final data = map['accounts'];

          List accounts = [];
          data.forEach((element) {
            accounts.add(data);
          });
          return Container(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final account = accounts[index];

                return ListTile(
                  title: Text(accounts[index][index]['Account_Type']),
                  subtitle: Text(accounts[index][index]['AccountNumber']),
                  /*trailing: Text(
                    account.airline.name, style: const TextStyle(color: Colors.green
                  ),),*/
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: accounts.length,
            ),
          );
          }
      ),
    );
  }
  String accountsUrl = 'https://suresms.co.ke:4242/mobileapi/api/GetSourceAccounts';
  getAccounts({bool isRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final mobileNo = prefs.getString('telephone') ?? '';
    final token = prefs.getString('Token') ?? '';

    Map data = {
      "mobile_no": mobileNo
    };
    final response = await http.post(Uri.parse(accountsUrl),
      headers: {
        "Accept": "application/json",
        "Token": token
      },
      body: json.encode(data),
    );
    print(response.body);
    if (response.statusCode == 200) {
      //print(response.body);
      /*final data = jsonDecode(response.body);

      Map<String,dynamic>res=jsonDecode(response.body);
      print(res['Name']);
      prefs.setString('Name', res['Name']);*/
      return response.body;

    }
    else {
      Map<String,dynamic>res=jsonDecode(response.body);
      Fluttertoast.showToast(msg: "${res['Description']}");
    }

    return response.body;
  }
}