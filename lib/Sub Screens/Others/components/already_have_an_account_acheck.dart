import 'package:flutter/material.dart';

import '../../../constants.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final VoidCallback press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Forgot your M-Banking Pin ? " : "Forgot your M-Banking Pin ? ",
          style: const TextStyle(color: Constants.kPrimaryColor, fontFamily: "Brand-Regular"),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Reset" : "Reset",
            style: const TextStyle(
              color: Constants.kPrimaryColor,
              fontWeight: FontWeight.bold,
                fontFamily: "Brand Bold"
            ),
          ),
        )
      ],
    );
  }
}
