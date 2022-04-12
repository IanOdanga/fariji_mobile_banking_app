import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreditCard extends StatefulWidget {
  final String color;
  final String image;
  final String number;

  CreditCard({required this.color, required this.image, required this.number});

  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {

  late final String color;
  late final String image;
  String? number;

  String? memberName;
  @override
  void initState() {
    getName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
      child: Container(
        height: 180,
        width: 300,
        decoration: BoxDecoration(
            color: const Color(0xFF05522b),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade600,
                  offset: const Offset(3, 1),
                  blurRadius: 7,
                  spreadRadius: 2
              )
            ]
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.more_vert, color: Colors.white,),
                ),
              ],
            ),

            const SizedBox(height: 30,),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(text: TextSpan(children: [
                    TextSpan(text: "$memberName\n", style: const TextStyle(fontFamily: "Brand Bold", color: Colors.white, fontSize: 18)),

                    TextSpan(text: "$number\n"),
                  ],style: TextStyle(fontSize: 22))),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<String>getName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('Name') ?? '';

    setState(() {
      memberName = name;
    });
    return name;
  }
}