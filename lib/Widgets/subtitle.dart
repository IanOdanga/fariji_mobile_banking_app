import 'package:flutter/material.dart';

import '../constants.dart';

class SubTitle extends StatelessWidget {
  final String subTitleText;
  const SubTitle({
    Key? key,
    required this.subTitleText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.kDefaultPadding, vertical: Constants.kFixPadding),
      child: Text(
        subTitleText,
        textAlign: TextAlign.center,
        style: Constants.kSubTextStyle,
      ),
    );
  }
}