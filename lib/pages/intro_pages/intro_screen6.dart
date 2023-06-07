import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:v_safe/utils/constants.dart';

class IntroPage6 extends StatelessWidget {
  const IntroPage6({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [const Color(0xffd5dee7).withOpacity(0.2), const Color(0xffffafbd).withOpacity(0.4), const Color(0xffc9ffbf).withOpacity(0.6),]
      )
      ),
      child: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Center(
                  child: Lottie.asset("assets/animations/intro_app_animations/object_detection.json", animate: true, width: 200),
                ),
              ),

              introTextDesign1("It will automatically detect the pattern of harassment and capture the image around you which it will automatically send along with your trusted contact list for your safety"),


              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Center(
                  child: Lottie.asset("assets/animations/intro_app_animations/image_capture.json", animate: true, width: 200),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
