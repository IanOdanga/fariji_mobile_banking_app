import 'dart:async';
import 'dart:convert';
import 'package:fariji_flutter_mobile_app/Services/storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../success_screen.dart';

class FosatoOther extends StatefulWidget{
  static const String idScreen = "fosatoother";
  _FosatoOtherState createState() => _FosatoOtherState();
}
class _FosatoOtherState extends State<FosatoOther>{

  TextEditingController accountController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();

  final SecureStorage storage = SecureStorage();
  final _storage = const FlutterSecureStorage();

  int amount = 0;
  String account = '';

  bool isLoading = false;

  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void init() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String? destAcc;
  late String message;
  bool? error;
  var data;

  @override
  void initState() {
    _getStateList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:const Text("FOSA to OTHER Acc Transfer",
            style: TextStyle(
              color: Colors.black87,
              fontFamily: "Brand Bold",
            ),
          ),
          //backgroundColor: Colors.redAccent,
        ),
        body:Container(
          padding:const EdgeInsets.all(30),
          child: Column(
              children:<Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              value: _myState,
                              iconSize: 30,
                              icon: (null),
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                              hint: const Text('Select Source Account', style: TextStyle(fontFamily: "Brand-Regular"),),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _myState = newValue!;
                                  _getStateList();
                                  print(_myState);
                                });
                              },
                              items: statesList?.map((item) {
                                return DropdownMenuItem(
                                  child: Text(item['Account_Type']),
                                  value: item['AccountNumber'].toString(),
                                );
                              }).toList() ??
                                  [],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30,),
                TextField(
                  controller: accountController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    account = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Enter Account to send to',
                    labelStyle: TextStyle(
                        fontSize: 16.0,
                        fontFamily: "Brand-Regular"
                    ),
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 10.0,
                    ),
                  ),
                  style: const TextStyle(fontSize: 16.0),
                ),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    amount = int.parse(value);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(
                        fontSize: 16.0,
                        fontFamily: "Brand-Regular"
                    ),
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 10.0,
                    ),
                  ),
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 30.0,),
                RaisedButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    child: Container(
                      height: 50,
                      child: const Center(
                        child: Text(
                          "Transfer Money",
                          style: TextStyle(fontSize: 16.0, fontFamily: "Brand Bold"),
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    onPressed: (){
                      showAlertDialog(context);
                    }
                )
              ]
          ),
        )
    );
  }

  List? statesList;
  String? _myState;

  String fosaAccsUrl = 'https://suresms.co.ke:4242/mobileapi/api/GetSourceAccounts';
  Future<String> _getStateList() async {
    final prefs = await SharedPreferences.getInstance();
    final mobileNo = prefs.getString('telephone') ?? '';
    final token = prefs.getString('Token') ?? '';

    Map data = {
      "mobile_no": mobileNo
    };
    await http.post(Uri.parse(fosaAccsUrl),
      headers: {
        "Accept": "application/json",
        "Token": token
      },
      body: json.encode(data),
    ).then((response) {
      var data = json.decode(response.body);

      print(data);
      setState(() {
        statesList = data['accounts'];
      });
    });

    return data.toString();
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel", style: TextStyle(fontFamily: "Brand Bold"),),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Yes", style: TextStyle(fontFamily: "Brand Bold"),),
      onPressed: () {
        transferFunds();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text(
        "AlertDialog", style: TextStyle(fontFamily: "Brand Bold"),),
      content: Text(
        "Are you sure you want to transfer Ksh. ${amountController.text} from ${_myState.toString()} to ${accountController.text}?",
        style: const TextStyle(fontFamily: "Brand Bold"),),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  transferFunds() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('Token') ?? '';
    final mobileNo = prefs.getString('telephone') ?? '';
    Map data = {
      "mobile_no": mobileNo,
      "accFrom": _myState.toString(),
      "acc_to": accountController.text,
      "amount": int.parse(amountController.text)
    };

    print(data);
    final response= await http.post(
      Uri.parse("https://suresms.co.ke:4242/mobileapi/api/FosatoFosaTransfer"),
      headers: {
        "Accept": "application/json",
        "Token": token
      },
      body: json.encode(data),
    );

    setState(() {
      isLoading=false;
    });
    print(response.body);
    if (response.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Success()));

    } else {
      showCodeDialog(context);
    }
  }

  showCodeDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("Ok", style: TextStyle(fontFamily: "Brand Bold"),),
      onPressed:  () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Failed", style: TextStyle(fontFamily: "Brand Bold"),),
      content: const Text("Incorrect OTP provided!", style: TextStyle(fontFamily: "Brand Bold"),),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}


