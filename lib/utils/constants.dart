import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color primaryColor = Color(0xff471aa0);

Widget progressIndicator(BuildContext context) {
  return Center(
      child: CircularProgressIndicator(
          backgroundColor: Colors.indigo,
          color: Color(0xff2d3a82),
          strokeWidth: 4));
}

showAlertDialogueBox(BuildContext context, String msg) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.deepPurpleAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24))
            ),
            shadowColor: Colors.deepPurpleAccent.withOpacity(0.5),
            titlePadding: EdgeInsets.all(25),
            titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
              fontFamily: 'PTSans-Regular'
            ),
            title: Text(msg, textAlign: TextAlign.center,),
          )
  );
}

void goTo(BuildContext context, Widget nextScreen) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => nextScreen,
      ));
}

Widget introTextDesign1(String text, {double font_size = 20.0, TextAlign alignment = TextAlign.center}) {
  return Text(text,
    style: TextStyle(
      fontFamily: 'Acme-Regular',
      fontSize: font_size,
      color: Colors.black.withOpacity(0.5)
    ),
    textAlign: alignment,
  );
}
