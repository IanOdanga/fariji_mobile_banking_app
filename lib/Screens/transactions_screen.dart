import 'package:flutter/material.dart';

class Transactions extends StatelessWidget{
  static const String idScreen = "transactions";

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