import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_safe/utils/constants.dart';

class PrimaryButton extends StatelessWidget{
  final String title;
  final Function onPressed;
  bool loading;

  PrimaryButton({required this.title, required this.onPressed, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        child: Text(title, style: TextStyle(
          fontFamily: 'PTSans-Regular',
          fontWeight: FontWeight.bold,
          fontSize: 18
        ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
        ),
      ),
    );
  }
}