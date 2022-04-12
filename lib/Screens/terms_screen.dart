import 'package:flutter/material.dart';

class TermsandConditions extends StatelessWidget{
  static const String idScreen = "terms";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions',
        style: TextStyle(
          fontFamily: "Brand-Bold",
          ),
        ),
        backgroundColor: const Color.fromRGBO(15,175,231,1),
      ),
    );
  }
}