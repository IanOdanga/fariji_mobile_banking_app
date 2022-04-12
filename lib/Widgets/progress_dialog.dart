/*
import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget{
  late String message;
  ProgressDialog({required this.message});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        margin: const EdgeInsets.all(15.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              const SizedBox(width: 6.0,),
              const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1cb1df)),),
              const SizedBox(width: 26.0,),
              Text(
                message,
                style: const TextStyle(color: Colors.black, fontFamily: "Brand Bold"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}*/
