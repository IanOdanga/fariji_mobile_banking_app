import 'package:flutter/cupertino.dart';

class ServiceWidgets extends StatelessWidget{
  late String name;
  late bool isSelected;
  @override
  Widget build(BuildContext context) {
    return navigatorTitle(name, isSelected);
  }
  Row navigatorTitle(String name, bool isSelected) {
    return Row(
      children: [
        (isSelected) ? Container(
          width: 5,
          height: 60,
          color: const Color(0xffffac30),
        ):
        Container(width: 5,
          height: 60,),
        const SizedBox(width: 10,height: 60,),
        Text(name, style: TextStyle(
            fontSize: 16,
            fontWeight: (isSelected) ? FontWeight.w700: FontWeight.w400
        ),)
      ],
    );
  }
}