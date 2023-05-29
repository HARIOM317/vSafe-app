import 'package:flutter/cupertino.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:v_safe/widgets/drawer_widgets/screen_drawer.dart';

class MainSplashScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/images/icon/intro_logo.png',
      nextScreen: DrawerScreen(),
      splashTransition: SplashTransition.scaleTransition,
      backgroundColor: Colors.deepPurple.shade500,
      splashIconSize: 200,
      duration: 2500,
    );
  }
}