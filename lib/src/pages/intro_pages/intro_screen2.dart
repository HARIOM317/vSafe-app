import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:v_safe/src/utils/constants.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [const Color(0xffddd6f3), const Color(0xfffaaca8).withOpacity(0.4), const Color(0xfff3e7e9),]
          )
      ),
      child: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,

            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Lottie.asset("assets/animations/intro_app_animations/security_shield.json", animate: true, width: 200),
                ),
              ),

              introTextDesign1("You can send SOS alert message in emergency situation using vSafe"),

              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 50),
                child: Center(
                  child: Lottie.asset("assets/animations/intro_app_animations/sos.json", animate: true, width: 200),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
