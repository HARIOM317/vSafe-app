import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:v_safe/utils/constants.dart';

class IntroPage8 extends StatelessWidget {
  const IntroPage8({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xff0acffe).withOpacity(0.5), Color(0xff495aff).withOpacity(0.5),]
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
                  child: Lottie.asset("assets/animations/intro_app_animations/family.json", animate: true, width: 200),
                ),
              ),

              introTextDesign1("Always stay connected with your family and trusted friend through your trusted contact list"),

              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Center(
                  child: Lottie.asset("assets/animations/intro_app_animations/chat.json", animate: true, width: 200),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
