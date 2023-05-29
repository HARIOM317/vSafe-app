import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:v_safe/utils/constants.dart';

class IntroPage10 extends StatelessWidget {
  const IntroPage10({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xffc471f5).withOpacity(0.3), Color(0xfffa71cd).withOpacity(0.4),]
          )
      ),
      child: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                child: Center(
                  child: Lottie.asset("assets/animations/intro_app_animations/security.json", animate: true, width: 200),
                ),
              ),

              introTextDesign1("Keep stay with us and be safe with vSafe app"),


            ],
          ),
        ),
      ),
    );
  }
}
