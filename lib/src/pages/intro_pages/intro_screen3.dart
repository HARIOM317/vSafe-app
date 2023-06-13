import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:v_safe/src/utils/constants.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xffcd9cf2), Color(0xfff6f3ff),]
          )
      ),
      child: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,

            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10,  bottom: 10),
                child: Column(
                  children: [
                    Center(
                      child: Lottie.asset("assets/animations/intro_app_animations/shake_phone.json", animate: true, width: 200),
                    ),

                    introTextDesign1("Shake mobile to send alert message"),
                  ],
                ),
              ),


              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 50),
                child: Column(
                  children: [
                    Center(
                      child: Lottie.asset("assets/animations/intro_app_animations/women_voice_activation.json", animate: true, width: 200),
                    ),

                    Center(
                      child: Lottie.asset("assets/animations/intro_app_animations/voice_visualization.json", animate: true, width: 200),
                    ),

                    introTextDesign1("Give voice command to activate alert sos message"),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
