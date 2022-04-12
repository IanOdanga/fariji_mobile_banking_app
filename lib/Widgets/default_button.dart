import 'package:flutter/material.dart';

import '../constants.dart';

class DefaultButton extends StatelessWidget {
  final String btnText;
  final VoidCallback onPressed;
  const DefaultButton({
    Key? key, required this.btnText, required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: Constants.kDefaultPadding),
      padding: const EdgeInsets.symmetric(horizontal: Constants.kDefaultPadding),
      child: FlatButton(
        padding: const EdgeInsets.symmetric(vertical: Constants.kLessPadding),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.kShape)),
        color: Constants.kPrimaryColor,
        textColor: Constants.kPrimaryLightColor,
        highlightColor: Constants.kTransparent,
        onPressed: onPressed,
        child: Text(btnText.toUpperCase()),
      ),
    );
  }
}