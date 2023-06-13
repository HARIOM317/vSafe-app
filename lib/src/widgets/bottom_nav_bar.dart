import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:v_safe/src/pages/navbar_pages/add_contacts.dart';
import 'package:v_safe/src/pages/navbar_pages/fake_call_screen.dart';
import 'package:v_safe/src/pages/navbar_pages/home_screen.dart';
import 'package:v_safe/src/pages/navbar_pages/network_screen.dart';
import 'package:v_safe/src/pages/navbar_pages/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}
 
class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  Icon homeIcon = const Icon(CupertinoIcons.house_fill, color: Colors.white);
  FaIcon networkIcon = const FaIcon(FontAwesomeIcons.networkWired, color: Colors.white, size: 22,);
  Icon contactIcon = const Icon(CupertinoIcons.rectangle_stack_person_crop, color: Colors.white);
  Icon chatIcon = const Icon(CupertinoIcons.phone, color: Colors.white,);
  Icon profileIcon = const Icon(CupertinoIcons.person, color: Colors.white);

  List<Widget> pages = [
    const HomeScreen(),
    const NetworkScreen(),
    const AddContactsScreen(),
    const FakeCallScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: CurvedNavigationBar(
        index: _page,
        backgroundColor: const Color(0xfff9d2cf).withOpacity(0.5),
        buttonBackgroundColor: const Color(0xff4b51a8),
        color: Colors.indigoAccent,
        animationDuration: const Duration(milliseconds: 500),
        height: 60,
        animationCurve: Curves.linear,

        items: [
          CurvedNavigationBarItem(
              child: homeIcon,
              label: 'Home',
              labelStyle: const TextStyle(color: Colors.white)),
          CurvedNavigationBarItem(
              child: networkIcon,
              label: 'Network',
              labelStyle: const TextStyle(
                  color: Colors.white
              ),
              ),
          CurvedNavigationBarItem(
              child: contactIcon,
              label: 'Contact',
              labelStyle: const TextStyle(color: Colors.white)),
          CurvedNavigationBarItem(
              child: chatIcon,
              label: 'Fake Call',
              labelStyle: const TextStyle(color: Colors.white)),
          CurvedNavigationBarItem(
              child: profileIcon,
              label: 'Profile',
              labelStyle: const TextStyle(color: Colors.white)),
        ],

        onTap: (index) {
          setState(() {
            _page = index;

            homeIcon = _page == 0 ? const Icon(CupertinoIcons.house_fill, color: Colors.white) : const Icon(CupertinoIcons.house, color: Colors.white);

            networkIcon = _page == 1 ? const FaIcon(FontAwesomeIcons.connectdevelop, color: Colors.white) : const FaIcon(FontAwesomeIcons.networkWired, color: Colors.white, size: 22,);

            contactIcon = _page == 2 ? const Icon(CupertinoIcons.rectangle_stack_person_crop_fill, color: Colors.white) : const Icon(CupertinoIcons.rectangle_stack_person_crop, color: Colors.white);

            chatIcon = _page == 3 ? const Icon(CupertinoIcons.phone_fill, color: Colors.white) : const Icon(CupertinoIcons.phone, color: Colors.white);

            profileIcon = _page == 4 ? const Icon(CupertinoIcons.person_fill, color: Colors.white) : const Icon(CupertinoIcons.person, color: Colors.white);
          });
        },
      ),
    );
  }
}
