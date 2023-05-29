import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_safe/utils/constants.dart';
import 'package:v_safe/widgets/drawer_widgets/screen_drawer.dart';

class ChatScreen extends StatefulWidget{
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
              child: Text("Chat Page")
          ),
        ),
      ),
    );
  }
}