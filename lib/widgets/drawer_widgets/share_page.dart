import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SharePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Share",
          style: TextStyle(
              fontFamily: 'Dosis-Regular',
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),

        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xff6416ff), Color(0xff5623a3)]),
          ),
        ),
      ),

      body: Center(
        child: Text("Share vSafe app now"),
      ),
    );
  }
}