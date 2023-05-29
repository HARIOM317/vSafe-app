import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget{
  final String title;
  final Function onPressed;

  const SecondaryButton({super.key, required this.title, required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomRight,
      child: Container(
        height: 50,
        // width: double.infinity,
        child: TextButton(
          onPressed: () {
            onPressed();
          },
          child: Text(title, style: TextStyle(
            color: Colors.indigo,
            fontFamily: 'PTSans-Regular'
          ),
          ),
        ),
      ),
    );
  }
}