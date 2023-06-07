import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:v_safe/pages/intro_pages/intro_screen1.dart';
import 'package:v_safe/pages/intro_pages/intro_screen10.dart';
import 'package:v_safe/pages/intro_pages/intro_screen2.dart';
import 'package:v_safe/pages/intro_pages/intro_screen3.dart';
import 'package:v_safe/pages/intro_pages/intro_screen4.dart';
import 'package:v_safe/pages/intro_pages/intro_screen5.dart';
import 'package:v_safe/pages/intro_pages/intro_screen6.dart';
import 'package:v_safe/pages/intro_pages/intro_screen7.dart';
import 'package:v_safe/pages/intro_pages/intro_screen8.dart';
import 'package:v_safe/pages/intro_pages/intro_screen9.dart';
import 'package:v_safe/user/login_welcome_splash_screen.dart';
import 'package:v_safe/utils/constants.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  // controller to keep track of which page we are on
  final PageController _controller = PageController();

  // keep track of if we are on the last page or not
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // page view
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 9);
              });
            },
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
              IntroPage4(),
              IntroPage5(),
              IntroPage6(),
              IntroPage7(),
              IntroPage8(),
              IntroPage9(),
              IntroPage10(),
            ],
          ),

          // dot indicator
          Container(
              alignment: const Alignment(0, 0.9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // skip button
                  GestureDetector(
                      onTap: () {
                        _controller.jumpToPage(10); // indexing start from 0
                      },
                      child: const Text('Skip', style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 18,
                        fontFamily: 'PTSans-Regular',
                        fontWeight: FontWeight.bold
                      ),
                      )
                  ),

                  SmoothPageIndicator(
                      controller: _controller,
                      count: 10,
                    axisDirection: Axis.horizontal,

                    effect: ExpandingDotsEffect(
                      activeDotColor: const Color(0xff1a237e),
                      dotColor: Colors.indigoAccent.withOpacity(0.4),
                      dotHeight: 8,
                      dotWidth: 8
                    ),
                  ),

                  // next button
                  onLastPage
                      ? GestureDetector(
                          onTap: () {
                            goTo(context, const LoginWelcomeSplashScreen());
                          },
                          child: const Text("Let's start", style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 18,
                              fontFamily: 'PTSans-Regular',
                              fontWeight: FontWeight.bold
                          ),
                          )
                  )
                      : GestureDetector(
                          onTap: () {
                            _controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn
                            );
                          },
                          child: const Text("Next", style: TextStyle(
                              color: Colors.indigoAccent,
                              fontSize: 18,
                              fontFamily: 'PTSans-Regular',
                              fontWeight: FontWeight.bold
                          ),
                          )
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
