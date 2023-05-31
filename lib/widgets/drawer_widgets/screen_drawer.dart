import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:v_safe/pages/profile_screen.dart';
import 'package:v_safe/user/login_screen.dart';
import 'package:v_safe/user/update_user_profile.dart';
import 'package:v_safe/utils/constants.dart';
import 'package:v_safe/widgets/bottom_nav_bar.dart';
import 'package:v_safe/widgets/drawer_widgets/feedback_page.dart';
import 'package:v_safe/widgets/drawer_widgets/help_page.dart';
import 'package:v_safe/widgets/drawer_widgets/history_page.dart';
import 'package:v_safe/widgets/drawer_widgets/notification_page.dart';
import 'package:v_safe/widgets/drawer_widgets/privacy_policy_page.dart';
import 'package:v_safe/widgets/drawer_widgets/setting_page.dart';
import 'package:v_safe/widgets/drawer_widgets/share_page.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

  final key = GlobalKey<FormState>();
  String? id;
  String? profilePic;
  String? downloadUrl;
  bool isSaving = false;

  TextEditingController nameController = TextEditingController();

  // function to get user name from database
  getUserName() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      nameController.text = value.docs.first['name'];
      id = value.docs.first.id;
    });
  }

  // function to get user image from database
  getData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        nameController.text = value.docs.first['name'];
        id = value.docs.first.id;
        profilePic = value.docs.first['profilePic'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserName();
    getData();
  }

  // final key = GlobalKey<FormState>();
  // String? id;
  // TextEditingController nameController = TextEditingController();
  //
  //
  // getName() async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .get()
  //       .then((value) {
  //     nameController.text = value.docs.first['name'];
  //     id = value.docs.first.id;
  //   });
  // }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   getName();
  //   // setState(() {
  //   //   getName();
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff4801FF).withOpacity(0.75),
              Color(0xff7010fb).withOpacity(0.70),
              Color(0xff7918F2).withOpacity(0.65)
            ],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),

      drawer: SafeArea(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: ListView(
            children: [
              // Container(
              //   margin: EdgeInsets.only(top: 10),
              //   decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: Colors.white,
              //       border: Border.all(
              //           width: 3, color: Colors.white)),
              //   child: profilePic == null
              //       ? CircleAvatar(
              //     child: Icon(
              //       Icons.person,
              //       size: 100,
              //     ),
              //     radius: 75,
              //   )
              //       : profilePic!.contains('http')
              //       ? CircleAvatar(
              //     radius: 75,
              //     backgroundImage:
              //     NetworkImage(profilePic!),
              //   )
              //       : CircleAvatar(
              //     radius: 75,
              //     backgroundImage:
              //     FileImage(File(profilePic!)),
              //   ),
              // ),

              // profile
              GestureDetector(
                onTap: (){
                  goTo(context, UpdateUserProfile());
                },
                child: Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    // bottom: 64.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: Colors.white)
                  ),
                  child: profilePic == null
                      ? CircleAvatar(
                          child: Icon(
                            Icons.person,
                            size: 100,
                          ),
                          radius: 75,
                        )
                      : profilePic!.contains('http')
                          ? CircleAvatar(
                              radius: 75,
                              backgroundImage: NetworkImage(profilePic!),
                            )
                          : CircleAvatar(
                              radius: 75,
                              backgroundImage: FileImage(File(profilePic!)),
                            ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 10, bottom: 35),
                child: Form(
                  key: key,
                  child: TextFormField(
                    enabled: false,
                    controller: nameController,
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Update your name";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: nameController.text,
                      border: InputBorder.none,
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
              ),

              // setting button
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AppSetting()));
                },
                leading: Icon(Icons.settings),
                title: Text('Setting'),
              ),

              // notification button
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NotificationPage()));
                },
                leading: Icon(Icons.notifications),
                title: Text('Notification'),
              ),

              // history button
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HistoryPage()));
                },
                leading: Icon(Icons.history),
                title: Text('History'),
              ),

              Divider(
                thickness: 1,
                color: Colors.white70,
              ),

              // share button
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SharePage()));
                },
                leading: Icon(Icons.share),
                title: Text('Share'),
              ),

              // help button
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HelpPage()));
                },
                leading: Icon(Icons.help),
                title: Text('Help'),
              ),

              // logout button
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                leading: Icon(Icons.logout),
                title: Text('Logout'),
              ),

              Divider(
                thickness: 1,
                color: Colors.white70,
              ),

              // feedback button
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => UserFeedback()));
                },
                leading: Icon(Icons.feedback),
                title: Text('Feedback'),
              ),

              // policy button
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PrivacyPolicy()));
                },
                leading: Icon(Icons.privacy_tip),
                title: Text('Privacy Policy'),
              ),
            ],
          ),
        ),
      ),

      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "vSafe",
            style: TextStyle(
                fontFamily: 'Dosis-Regular',
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0xff6416ff), Color(0xff5623a3)]),
            ),
          ),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
        ),
        body: BottomNavBar(),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}
