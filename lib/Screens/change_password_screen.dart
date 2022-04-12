import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget{
  static const String idScreen = "settings";
  SettingsState createState()=> SettingsState();
}
class SettingsState extends State<ChangePassword> {

  TextEditingController oldPasswordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();

  String oldPassword = '';
  String newPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password',
            style: TextStyle(
                  fontFamily: "Brand Bold",
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )
            ),
        backgroundColor: const Color.fromRGBO(15,175,231,1),
      ),
    body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0,),
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: oldPasswordController,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        RegExp regex = RegExp(r'^.{4,}$');
                        if (value!.isEmpty) {
                          return (" Old Password is required");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid Password(Min. 4 Character)");
                        }
                      },
                      onChanged: (value) {
                        oldPassword = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Old Password',
                        labelStyle: TextStyle(
                            fontSize: 16.0,
                            fontFamily: "Brand Bold"
                        ),
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 10.0,
                        ),
                      ),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 10.0,),
                    TextFormField(
                      controller: newPasswordController,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        RegExp regex = RegExp(r'^.{4,}$');
                        if (value!.isEmpty) {
                          return ("New Password is required to complete the process");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid Password(Min. 4 Character)");
                        }
                      },
                      onChanged: (value) {
                        newPassword = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'New Password',
                        labelStyle: TextStyle(
                            fontSize: 16.0,
                            fontFamily: "Brand Bold"
                        ),
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 10.0,
                        ),
                      ),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 20.0,),
                    RaisedButton(
                        color: Colors.black,
                        textColor: Colors.white,
                        child: Container(
                          height: 50,
                          child: const Center(
                            child: Text(
                              "Change Password",
                              style: TextStyle(fontSize: 16.0, fontFamily: "Brand Bold"),
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        onPressed: (){
                          changePassword(oldPasswordController.text, newPasswordController.text);
                        }
                    )
                  ],
                )
            ),
          ],
        ),
      ),
      )
    );
  }
  changePassword(oldPassword, newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final agentCode = prefs.getString('agentCode') ?? '';
    Map data = {
      "agent_code": agentCode
    };
    print(data);
    final  response= await http.post(
      Uri.parse("https://suresms.co.ke:45322/agency/api/ChangePassword"),
      headers: {
        "Accept": "application/json"
      },
      body: json.encode(data),
    );
    print(response.body);
    if (response.statusCode == 200) {
      Map<String,dynamic>res=jsonDecode(response.body);
      print(response.body);
      /*return AgentFloatResponse.fromJson(
          json.decode(response.body),
        );*/
      return response.body;
    } else {
      Fluttertoast.showToast(msg: "Please try again!");
    }
    return response.body;
  }
}