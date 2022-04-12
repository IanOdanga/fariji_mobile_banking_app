import 'package:flutter/material.dart';
import 'package:fariji_flutter_mobile_app/Sub Screens/Others/components/text_field_container.dart';

import '../../../constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
    Key? key,
    required this.hintText,
    this.icon = Icons.phone,
    required this.onChanged, required TextEditingController controller, required TextInputType keyboardType, required TextStyle hintStyle,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: Constants.kPrimaryColor,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Constants.kPrimaryColor,
          ),
          hintText: hintText,
          hintStyle: TextStyle(fontFamily: "Brand-Regular"),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
