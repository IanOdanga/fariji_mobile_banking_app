import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Sub/fosa_to_bosa_screen.dart';
import 'Sub/fosa_to_fosa_screen.dart';
import 'Sub/fosa_to_other.dart';

class FundsTransfer extends StatefulWidget {
  static const String idScreen = "transfer";
  @override
  _FundsTransferState createState() => _FundsTransferState();
}

class _FundsTransferState extends State<FundsTransfer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Funds Transfer',
          style: TextStyle(
            color: Colors.black87,
            fontFamily: "Brand Bold",
          ),
        ),
        backgroundColor: const Color(0xFF1cb1df),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 26.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FosatoBosa()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 100,
                        width: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              FontAwesomeIcons.exchangeAlt,
                              size: 45,
                              color: Colors.black,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "FOSA TO BOSA Transfer",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontFamily: "Brand Bold",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FosatoFosa()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 100,
                        width: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              FontAwesomeIcons.exchangeAlt,
                              size: 45,
                              color: Colors.black,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "FOSA TO FOSA Transfer",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontFamily: "Brand Bold",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FosatoOther()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 100,
                        width: 180,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              FontAwesomeIcons.exchangeAlt,
                              size: 45,
                              color: Colors.black,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "FOSA To OTHER ACC Transfer",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: "Brand Bold",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                /*Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        *//*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Statement()));*//*
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.pink.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 100,
                        width: 130,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.receipt_long,
                              size: 45,
                              color: Colors.pink.shade50,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Others",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: "Brand Bold",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),*/
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column serviceWidgetFB(String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FosatoBosa()));
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5,),
        Text(name, style: const TextStyle(
          fontFamily: 'avenir',
          fontSize: 14,
        ), textAlign: TextAlign.center,)
      ],
    );
  }

  Column serviceWidgetFF(String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FosatoFosa()));
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5,),
        Text(name, style: const TextStyle(
          fontFamily: 'avenir',
          fontSize: 14,
        ), textAlign: TextAlign.center,)
      ],
    );
  }
}