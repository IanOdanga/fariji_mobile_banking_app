import 'package:fariji_flutter_mobile_app/Widgets/default_button.dart';
import 'package:fariji_flutter_mobile_app/constants.dart';
import 'package:fariji_flutter_mobile_app/Widgets/empty_section.dart';
import 'package:fariji_flutter_mobile_app/Widgets/subtitle.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'main_screen.dart';

class Success extends StatefulWidget {
  Success({Key? key}) : super(key: key);

  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const EmptySection(
            emptyImg: Constants.success,
            emptyMsg: 'Successful !!',
          ),
          const SubTitle(
            subTitleText: 'Your payment was done successfully',
          ),
          DefaultButton(
            btnText: 'Ok',
            onPressed: () =>
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (BuildContext context) => MenuDashboardPage()),
                    (Route route) => false,),
                ),
              ]
            ),
          );
  }
}