import 'dart:convert';
import 'package:fariji_flutter_mobile_app/Screens/main_screen.dart';
import 'package:fariji_flutter_mobile_app/Sub%20Screens/ChangePin/pinreset_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fariji_flutter_mobile_app/Model/token_model.dart';
import 'package:fariji_flutter_mobile_app/Sub Screens/Login/components/background.dart';
import 'package:fariji_flutter_mobile_app/Screens/pin_verification_screen.dart';
import 'package:fariji_flutter_mobile_app/Services/settings.dart';
import 'package:fariji_flutter_mobile_app/Services/storage.dart';
import 'package:fariji_flutter_mobile_app/Sub Screens/Others/components/already_have_an_account_acheck.dart';
import 'package:fariji_flutter_mobile_app/Sub Screens/Others/components/rounded_button.dart';
import 'package:fariji_flutter_mobile_app/Sub Screens/Others/components/rounded_input_field.dart';
import 'package:fariji_flutter_mobile_app/Sub Screens/Others/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  TextEditingController telephoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String? errorMessage;
  bool isLoading=false;
  final _formKey = GlobalKey<FormState>();

  late String telephone;
  late String password;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Brand Bold"),
            ),
            SizedBox(height: size.height * 0.03),
            Image.asset(
              "assets/icons/signup.png",
              height: size.height * 0.35,
              //color: Constants.kPrimaryLightColor,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              controller: telephoneController,
              keyboardType: TextInputType.number,
              hintText: "Your Phone Number",
              hintStyle: TextStyle(fontFamily: "Brand-Regular"),
              onChanged: (value) {
                telephone = value;
                print(telephone);
                telephoneController.text = telephone;
              },
            ),
            RoundedPasswordField(
              controller: passwordController,
              obscureText: true,
              keyboardType: TextInputType.number,
              validator: (value) {
              RegExp regex = RegExp(r'^.{4,}$');
              if (value.isEmpty) {
                return ("Pin is required for login");
              }
              if (!regex.hasMatch(value)) {
                return ("Enter Valid Pin(Min. 4 Character)");
                }
              },
              hintText: "M-Banking Pin",
              hintStyle: const TextStyle(fontFamily: "Brand Bold"),
              onChanged: (value) {
                password = value;
                passwordController.text = password;
              },
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                if (telephoneController.text.isEmpty){
                  showPhoneDialog(context);
                }
                else if (passwordController.text.isEmpty){
                  showPassDialog(context);
                }
                else if (telephoneController.text.isEmpty && passwordController.text.isEmpty){
                  showAlertDialog(context);
                }
                else {
                  if (telephoneController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                    showProgress(context);
                    //getToken();
                  }
                  //getToken();
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ChangePinScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showProgress(BuildContext context) async {
    var result = await showDialog(
      context: context,
      builder: (context) =>
          FutureProgressDialog(getToken(), message: const Text('Verifying Sacco Membership...', style: TextStyle(fontFamily: "Brand Bold"))),
    );
    //showResultDialog(context, result);
  }

  void showResultDialog(BuildContext context, String result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(result),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  displayToastMessage(String errorMessage, BuildContext context){
    Fluttertoast.showToast(msg: errorMessage);
  }

  showPhoneDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("Ok", style: TextStyle(fontFamily: "Brand Bold"),),
      onPressed:  () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Failed", style: TextStyle(fontFamily: "Brand Bold"),),
      content: const Text("Phone Number cannot be Empty!", style: TextStyle(fontFamily: "Brand Bold"),),
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

  showPassDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("Ok", style: TextStyle(fontFamily: "Brand Bold"),),
      onPressed:  () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Failed", style: TextStyle(fontFamily: "Brand Bold"),),
      content: const Text("M-banking Pin cannot be Empty!", style: TextStyle(fontFamily: "Brand Bold"),),
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

  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("Ok", style: TextStyle(fontFamily: "Brand Bold"),),
      onPressed:  () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Failed", style: TextStyle(fontFamily: "Brand Bold"),),
      content: const Text("Phone Number or Pin cannot be Empty!", style: TextStyle(fontFamily: "Brand Bold"),),
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

  String tokenUrl = "https://suresms.co.ke:4242/mobileapi/api/GetToken";
  getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String username = apiDetails.username;
    String password = apiDetails.password;

    prefs.setString('Username', username);
    prefs.setString('Password', password);

    final response= await http.get(
        Uri.parse(tokenUrl),
        headers: {
          "Username": username,
          "Password": password,
          "Accept": "application/json"
        }
    );
    print(response.body);
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty)
      {
        Map<String, dynamic>res = jsonDecode(response.body);
        //print(response.body);
        print(res['Token']);
        String? authToken = res['Token'];
        final SecureStorage secureStorage = SecureStorage();
        secureStorage.writeSecureToken('Token', authToken!);

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('Token', res['Token']);
        //prefs.setString('telephone', telephoneController.text);

        var tokenTime = res['Expiry'];
        prefs.setString('tokenTime', tokenTime);

        sendVerificationCode(telephoneController.text, passwordController.text);
        /*Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => MenuDashboardPage()),
              );*/


      } else {
        Map<String, dynamic>res = jsonDecode(response.body);
        Fluttertoast.showToast(msg: "${res['Description']}");
      }
    } else if (response.persistentConnection == true) {
      Fluttertoast.showToast(msg: "Kindly Check your Internet Connection!");
    }

    else{
      Fluttertoast.showToast(msg: "Please try again later!");
    }
    //return response.body;
  }

  sendVerificationCode(mobileNo, pinNo) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('Token') ?? '';
    print(token);
    Map data = {
      "mobile_no": mobileNo
    };
    //print(data.toString());
    print(data);
    final response= await http.post(
      Uri.parse("https://suresms.co.ke:4242/mobileapi/api/SendVerificationCode"),
      headers: {
        "Accept": "application/json",
        "Token": token
      },
      body: json.encode(data),
      //encoding: Encoding.getByName("utf-8")
    );
    prefs.setString('telephone', mobileNo);
    prefs.setString('Password', pinNo);

    final SecureStorage secureStorage = SecureStorage();
    secureStorage.writeSecureToken('Telephone', mobileNo);
    secureStorage.writeSecureToken('Password', pinNo);

    setState(() {
      isLoading=false;
    });
    print(response.body);
    if (response.statusCode == 200) {
      Map<String,dynamic>res=jsonDecode(response.body);
      print(response.body);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => PinCodeVerificationScreen(mobileNo)),
            );

    } else {
      Map<String,dynamic>res=jsonDecode(response.body);
      Fluttertoast.showToast(msg: "${res['Description']}");
    }
  }
}