import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatementsPage extends StatefulWidget {
  static const String idScreen = "statements";
  StatementsPage({Key? key}) : super(key: key);

  @override
  _StatementsPageState createState() => _StatementsPageState();
}

class _StatementsPageState extends State<StatementsPage> {

  final formKey = GlobalKey<FormState>();

  final RefreshController refreshController =
  RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Text('Statements',
          style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              )
      ),
      backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
          future: getStatements(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            Map<String, dynamic> map = json.decode(snapshot.data);
            final data = map['statementlist'];

            List accounts = [];
            data.forEach((element) {
              accounts.add(data);
            });
            return Container(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final account = accounts[index];

                  return ListTile(
                    title: Text(accounts[index][index]['Description'], style: const TextStyle(fontFamily: "Brand Bold")),
                    subtitle: Text(accounts[index][index]['posting_date'], style: const TextStyle(fontFamily: "Brand-Regular")),
                    trailing: Text(
                      accounts[index][index]['amount'].toString(), style: const TextStyle(color: Colors.green, fontFamily: "Brand Bold"),),
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

  String miniStmtUrl = 'https://suresms.co.ke:4242/mobileapi/api/MiniStatements';
  getStatements({bool isRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final mobileNo = prefs.getString('telephone') ?? '';
    final token = prefs.getString('Token') ?? '';

    Map data = {
      "mobile_no": mobileNo
    };
    final response = await http.post(Uri.parse(miniStmtUrl),
      headers: {
        "Accept": "application/json",
        "Token": token
      },
      body: json.encode(data),
    );
    print(response.body);
    if (response.statusCode == 200) {

      //final data = jsonDecode(response.body);

      //Map<String,dynamic>res=jsonDecode(response.body);

      return response.body;

    }
    else {
      Map<String,dynamic>res=jsonDecode(response.body);
      Fluttertoast.showToast(msg: "${res['Description']}");
    }

    return response.body;
  }
}