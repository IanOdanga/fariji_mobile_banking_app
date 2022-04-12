import 'dart:async';
import 'dart:convert';
import 'package:fariji_flutter_mobile_app/Model/accounts_model.dart';
import 'package:fariji_flutter_mobile_app/Services/storage.dart';
import 'package:fariji_flutter_mobile_app/Widgets/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'loan_appl_screen.dart';

class MobileLoan extends StatefulWidget{
  static const String idScreen = "cashwithdrawal";
  _MobileLoanState createState() => _MobileLoanState();
}
class _MobileLoanState extends State<MobileLoan> {

  TextEditingController amountController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController periodController = TextEditingController();

  final SecureStorage storage = SecureStorage();
  final _storage = const FlutterSecureStorage();

  String idNumber = '';
  String Amount = '';
  int period = 0;

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

  String? loanType;
  late String message;
  bool? error;
  List data = List<String>.empty();

  String? _mySelection;

  List<String> loanProds = ["Mobile Loan", "Salary Advance", "Cloud Loan"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Mobile Loans",
            style: TextStyle(
              color: Colors.black87,
              fontFamily: "Brand Bold",
            ),
          ),
          backgroundColor: const Color(0xFF1cb1df),
        ),
        body: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
              children: <Widget>[
                Container(
                  child: DropdownButton(
                    isExpanded: true,
                    value: loanType,
                    hint: const Text("Select Loan Type", style: TextStyle(fontFamily: "Brand-Regular"),),
                    items: loanProds.map((loanTypeOne) {
                      return DropdownMenuItem(
                        child: Text(loanTypeOne, style: const TextStyle(fontFamily: "Brand-Regular"),),
                        value: loanTypeOne,
                      );
                    }).toList(),
                    onChanged: (value) {
                      loanType = value as String;
                      //_getStateList();
                    },
                  ),
              ),
                const SizedBox(height: 10,),
                TextField(
                  controller: periodController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    period = value as int;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Period',
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
                          "Check Eligibility",
                          style: TextStyle(fontSize: 16.0, fontFamily: "Brand Bold"),
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    onPressed: (){
                      checkEligibility();
                    }
                )
              ]
          ),
        )
    );
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
        checkEligibility();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text(
        "AlertDialog", style: TextStyle(fontFamily: "Brand Bold"),),
      content: Text(
        "Are you sure you want to borrow ${loanType.toString()} of Ksh. ${amountController.text}?",
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

  checkEligibility() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('Token') ?? '';
    final mobileNo = prefs.getString('telephone') ?? '';
    Map data = {
      "mobile_no": mobileNo,
      "loan_type_code": loanType.toString(),
      "no_of_months": periodController.text
    };

    print(data);
    final response= await http.post(
      Uri.parse("https://suresms.co.ke:4242/mobileapi/api/MobileAdvanceEligibility"),
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

      Map<String,dynamic>res=jsonDecode(response.body);
      //snackBar("Transaction Successful!");

      Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => LoanAdvanced(loanType.toString(), periodController.text)),
      );
        Widget okButton = TextButton(
          child: const Text("Ok", style: TextStyle(fontFamily: "Brand Bold"),),
          onPressed:  () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => LoanAdvanced(loanType.toString(), periodController.text)),
                  );
          },
        );

        AlertDialog alert = AlertDialog(
          title: const Text("Qualification", style: TextStyle(fontFamily: "Brand Bold"),),
          content: Text("${res['Description']}", style: const TextStyle(fontFamily: "Brand Bold"),),
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
    } else if(response.statusCode != 200){
      Map<String,dynamic>res=jsonDecode(response.body);

      Widget okButton = TextButton(
        child: const Text("Ok", style: TextStyle(fontFamily: "Brand Bold"),),
        onPressed:  () {
          Navigator.pop(context);
        },
      );

      AlertDialog alert = AlertDialog(
        title: const Text("Qualification", style: TextStyle(fontFamily: "Brand Bold"),),
        content: Text("${res['Description']}", style: const TextStyle(fontFamily: "Brand Bold"),),
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
}


