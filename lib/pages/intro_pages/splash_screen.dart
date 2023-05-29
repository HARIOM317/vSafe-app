import 'package:flutter/cupertino.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:v_safe/pages/intro_pages/onboarding_screen.dart';

class SplashScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: 'assets/images/icon/intro_logo.png',
        nextScreen: IntroScreen(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.deepPurple.shade500,
      splashIconSize: 180,
      duration: 2500,
    );
  }
}