import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fariji_flutter_mobile_app/Model/token_model.dart';
import 'package:fariji_flutter_mobile_app/Services/storage.dart';

getToken() async {
  final prefs = await SharedPreferences.getInstance();

  final username = prefs.getString('Username') ?? '';
  final password = prefs.getString('Password') ?? '';
  final response= await http.get(
      Uri.parse("https://suresms.co.ke:4242/mobileapi/api/GetToken"),
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

      final mobileNo = prefs.getString('telephone') ?? '';
      sendVerificationCode(mobileNo);

    } else {
      Map<String, dynamic>res = jsonDecode(response.body);
      Fluttertoast.showToast(msg: "${res['Description']}");
    }
  } else {
    Fluttertoast.showToast(msg: "Please try again!");
  }
  return TokenModelResponse.fromJson(json.decode(response.body));
}

sendVerificationCode(mobileNo) async {
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

  final SecureStorage secureStorage = SecureStorage();
  secureStorage.writeSecureToken('Telephone', mobileNo);

  print(response.body);
  if (response.statusCode == 200) {
    Map<String,dynamic>res=jsonDecode(response.body);
    print(response.body);
    //Navigator.push(context, PageTransition(type: PageTransitionType.rotate, alignment: Alignment.bottomCenter, duration: Duration(seconds: 1), child: PinCodeVerificationScreen(mobileNo)));

    //Fluttertoast.showToast(msg: "Others Successful");

  } else {
    Map<String,dynamic>res=jsonDecode(response.body);
    Fluttertoast.showToast(msg: "${res['Description']}");
  }
}