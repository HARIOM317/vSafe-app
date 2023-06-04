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

class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}
 
class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  Icon homeIcon = Icon(CupertinoIcons.house_fill, color: Colors.white);
  FaIcon networkIcon = FaIcon(FontAwesomeIcons.networkWired, color: Colors.white, size: 22,);
  Icon contactIcon = Icon(CupertinoIcons.rectangle_stack_person_crop, color: Colors.white);
  Icon chatIcon = Icon(CupertinoIcons.chat_bubble_text, color: Colors.white,);
  Icon profileIcon = Icon(CupertinoIcons.person, color: Colors.white);

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
        height: 65,
        animationCurve: Curves.linear,

        items: [
          CurvedNavigationBarItem(
              child: homeIcon,
              label: 'Home',
              labelStyle: TextStyle(color: Colors.white)),
          CurvedNavigationBarItem(
              child: networkIcon,
              label: 'Network',
              labelStyle: TextStyle(
                  color: Colors.white
              ),
              ),
          CurvedNavigationBarItem(
              child: contactIcon,
              label: 'Contact',
              labelStyle: TextStyle(color: Colors.white)),
          CurvedNavigationBarItem(
              child: chatIcon,
              label: 'Chat',
              labelStyle: TextStyle(color: Colors.white)),
          CurvedNavigationBarItem(
              child: profileIcon,
              label: 'Profile',
              labelStyle: TextStyle(color: Colors.white)),
        ],

        onTap: (index) {
          setState(() {
            _page = index;

            homeIcon = _page == 0 ? Icon(CupertinoIcons.house_fill, color: Colors.white) : Icon(CupertinoIcons.house, color: Colors.white);

            networkIcon = _page == 1 ? FaIcon(FontAwesomeIcons.connectdevelop, color: Colors.white) : FaIcon(FontAwesomeIcons.networkWired, color: Colors.white, size: 22,);

            contactIcon = _page == 2 ? Icon(CupertinoIcons.rectangle_stack_person_crop_fill, color: Colors.white) : Icon(CupertinoIcons.rectangle_stack_person_crop, color: Colors.white);

            chatIcon = _page == 3 ? Icon(CupertinoIcons.chat_bubble_text_fill, color: Colors.white) : Icon(CupertinoIcons.chat_bubble_text, color: Colors.white);

            profileIcon = _page == 4 ? Icon(CupertinoIcons.person_fill, color: Colors.white) : Icon(CupertinoIcons.person, color: Colors.white);
          });
        },
      ),
    );
  }
}
