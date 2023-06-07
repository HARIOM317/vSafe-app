import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:v_safe/utils/constants.dart';

class IntroPage7 extends StatelessWidget {
  const IntroPage7({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xffFFFEFF), Color(0xffD7FFFE),]
          )
      ),
      child: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Center(
                  child: Lottie.asset("assets/animations/intro_app_animations/networkfriends.json", animate: true, width: 200),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: introTextDesign1("Establish your social network on vSafe app which will help to strong your community and helpful in emergency situation", fontSize: 20.0),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Center(
                  child: Lottie.asset("assets/animations/intro_app_animations/contact.json", animate: true, width: 200),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
