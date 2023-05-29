import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_safe/utils/constants.dart';
import 'package:v_safe/widgets/drawer_widgets/screen_drawer.dart';

class NetworkScreen extends StatefulWidget{
  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  Future<bool> _onPop() async {
    goTo(context, DrawerScreen());
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onPop,

      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xfff9d2cf).withOpacity(0.5),
          ),

          child: Center(
              child: Text("Network Page")
          ),
        ),
      ),
    );
  }
}