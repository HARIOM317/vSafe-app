import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:v_safe/components/primary_button.dart';
import 'package:v_safe/user/update_user_profile.dart';
import 'package:v_safe/utils/constants.dart';
import 'package:v_safe/widgets/drawer_widgets/screen_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final key = GlobalKey<FormState>();
  String? id;
  String? profilePic;
  bool isSaving = false;

  Future<bool> _onPop() async {
    goTo(context, const DrawerScreen());
    return true;
  }

  // function to reload to profile page on pull down
  Future<void> _handleRefresh () async{
    // reloading takes some time
    getData();
    getName();
    getEmail();
    getContact();
    return await Future.delayed(const Duration(seconds: 2));
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  // function to get user name from database
  getName() async {
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

  // function to get user email from database
  getEmail() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      emailController.text = value.docs.first['email'];
      id = value.docs.first.id;
    });
  }

  // function to get user contact from database
  getContact() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      contactController.text = value.docs.first['phone'];
      id = value.docs.first.id;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getName();
      getEmail();
      getContact();
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onPop,
      child: Scaffold(
        backgroundColor: Color(0xfff9d2cf).withOpacity(0.5),
        body: isSaving == true
            ? Center(child: CircularProgressIndicator())
            : LiquidPullToRefresh(
              onRefresh: _handleRefresh,
              color: Colors.deepPurpleAccent,
              backgroundColor: Color(0xfff9d2cf).withOpacity(0.7),
              height: 300,
              animSpeedFactor: 3,
              showChildOpacityTransition: true,

              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Form(
                        key: key,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              child: Text(
                                "WELCOME",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'NovaSlim-Regular',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                goTo(context, UpdateUserProfile());
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 3, color: Colors.white)),
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
                                            backgroundImage:
                                                NetworkImage(profilePic!),
                                          )
                                        : CircleAvatar(
                                            radius: 75,
                                            backgroundImage:
                                                FileImage(File(profilePic!)),
                                          ),
                              ),
                            ),
                            TextFormField(
                              enabled: false,
                              controller: nameController,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "User Name";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: nameController.text,
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'PTSans-Regular',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.deepPurple),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 30, bottom: 5),
                              child: TextFormField(
                                enabled: false,
                                controller: emailController,
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return "Email ID";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  label: Text("Registered Email"),
                                  hintText: emailController.text,
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(fontFamily: 'PTSans-Regular'),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5),
                              child: TextFormField(
                                enabled: false,
                                controller: contactController,
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return "Contact Number";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  label: Text("Registered Phone"),
                                  hintText: contactController.text,
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(fontFamily: 'PTSans-Regular'),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 30),
                              child: PrimaryButton(
                                  title: "EDIT PROFILE",
                                  onPressed: () async {
                                    goTo(context, UpdateUserProfile());
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
