import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:v_safe/pages/add_contacts.dart';

import 'package:v_safe/pages/chat_screen.dart';
import 'package:v_safe/pages/contact_screen.dart';
import 'package:v_safe/pages/home_screen.dart';
import 'package:v_safe/pages/network_screen.dart';
import 'package:v_safe/pages/profile_screen.dart';

class BottomNavBar extends StatefulWidget{
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;

  List<Widget> pages = [
    HomeScreen(),
    NetworkScreen(),
    AddContactsScreen(),
    ChatScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],

      bottomNavigationBar: CurvedNavigationBar(
        index: _page,
        backgroundColor: Color(0xfff9d2cf).withOpacity(0.5),
        buttonBackgroundColor: Color(0xff4b51a8),
        color: Colors.indigoAccent,
        animationDuration: Duration(milliseconds: 500),
        // height: 75,
        // animationCurve: Curves.linear,

        items: [
          CurvedNavigationBarItem(
              child: Icon(Icons.home_outlined, color: Colors.white,),
              label: 'Home',
              labelStyle: TextStyle(
                  color: Colors.white
              )
          ),
          CurvedNavigationBarItem(
            child: FaIcon(FontAwesomeIcons.networkWired, color: Colors.white, size: 20,),
            label: 'Network',
            labelStyle: TextStyle(
                color: Colors.white
            ),
          ),
          CurvedNavigationBarItem(
              child: Icon(Icons.contacts, color: Colors.white,),
              label: 'Contact',
              labelStyle: TextStyle(
                  color: Colors.white
              )
          ),
          CurvedNavigationBarItem(
              child: Icon(Icons.chat_bubble_outline, color: Colors.white),
              label: 'Chat',
              labelStyle: TextStyle(
                  color: Colors.white
              )
          ),
          CurvedNavigationBarItem(
              child: Icon(Icons.perm_identity, color: Colors.white),
              label: 'Profile',
              labelStyle: TextStyle(
                  color: Colors.white
              )
          ),
        ],

        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}