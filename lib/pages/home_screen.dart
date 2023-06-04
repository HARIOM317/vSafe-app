import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_safe/widgets/home_widgets/custom_carousel.dart';
import 'package:v_safe/widgets/home_widgets/emergency.dart';
import 'package:v_safe/widgets/home_widgets/nearby_map_service.dart';
import 'package:v_safe/widgets/home_widgets/situation.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // function to create section heading
  Widget sectionHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, top: 5.0),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Rajdhani-Regular',
            color: Colors.black54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackButtonPressed(context),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xfff9d2cf).withOpacity(0.5),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 5, right: 5),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(shrinkWrap: true, children: [
                      sectionHeading("Tips"),
                      CustomCarousel(),

                      sectionHeading("Explore Nearby"),
                      NearbyMapService(),

                      sectionHeading("Situation"),
                      Situation(),

                      sectionHeading("Emergency Helplines"),
                      Emergency(),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),

      ),
    );
  }

  Future<bool> _onBackButtonPressed(BuildContext context) async {
    bool? exitApp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to close the app?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("No")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    exit(0);
                  },
                  child: const Text("Yes"))
            ],
          );
        });

    return exitApp ?? false;
  }

}
