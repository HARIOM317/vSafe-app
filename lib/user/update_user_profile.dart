import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:v_safe/components/primary_button.dart';
import 'package:v_safe/utils/constants.dart';
import 'package:v_safe/widgets/drawer_widgets/screen_drawer.dart';

class UpdateUserProfile extends StatefulWidget {
  @override
  State<UpdateUserProfile> createState() => _UpdateUserProfile();
}

class _UpdateUserProfile extends State<UpdateUserProfile> {
  final key = GlobalKey<FormState>();
  String? id;
  String? profilePic;
  String? downloadUrl;
  bool isSaving = false;

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
    getName();
    getEmail();
    getContact();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Update Your Profile",
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
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xfff9d2cf).withOpacity(0.5),
        ),
        child: SafeArea(
          child: isSaving == true
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Form(
                      key: key,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              child: Text(
                                "USER PROFILE",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'NovaSlim-Regular',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),

                            Stack(
                              children: [
                                Container(
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

                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () async {
                                        final XFile? pickImage = await ImagePicker()
                                            .pickImage(
                                            source: ImageSource.gallery,
                                            imageQuality: 50);

                                        if (pickImage != null) {
                                          setState(() {
                                            profilePic = pickImage.path;
                                          });
                                        }

                                        // update image on firebase
                                        if (key.currentState!.validate()) {
                                          // close keyboard if open
                                          SystemChannels.textInput
                                              .invokeMethod('TextInput.hide');

                                          profilePic == null
                                              ? Fluttertoast.showToast(
                                              msg:
                                              "Please select an profile picture!")
                                              : update();
                                        }

                                      },

                                      child: Container(
                                        height: 55,
                                        width: 55,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 3, color: Colors.white),
                                            gradient: LinearGradient(colors: [
                                              Color(0xff6416ff),
                                              Color(0xff5623a3)
                                            ])),
                                        child: Icon(
                                          Icons.camera_alt_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 50, bottom: 5),
                              child: TextFormField(
                                enabled: true,
                                controller: nameController,
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return "User Name";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  suffixIcon: Icon(Icons.edit),
                                  hintText: nameController.text,
                                  border: InputBorder.none,
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          style: BorderStyle.solid,
                                          color: Color(0xff5720c6),
                                          width: 1.5)),
                                ),
                                style: TextStyle(
                                    fontSize: 16, fontFamily: 'PTSans-Regular'),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: TextFormField(
                                enabled: true,
                                controller: contactController,
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return "Contact Number";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.phone),
                                  suffixIcon: Icon(Icons.edit),
                                  hintText: contactController.text,
                                  border: InputBorder.none,
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          style: BorderStyle.solid,
                                          color: Color(0xff5720c6),
                                          width: 1.5)),
                                ),
                                style: TextStyle(
                                    fontSize: 16, fontFamily: 'PTSans-Regular'),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
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
                                    prefixIcon: Icon(
                                      CupertinoIcons.mail_solid,
                                      color: Colors.grey,
                                    ),
                                    hintText: emailController.text,
                                    border: InputBorder.none),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'PTSans-Regular',
                                    color: Colors.grey),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 50),
                              child: PrimaryButton(
                                  title: "UPDATE PROFILE",
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(id)
                                        .update({
                                      'name': nameController.text
                                    }).then((value) => Fluttertoast.showToast(
                                            msg: "Profile Updated"));

                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(id)
                                        .update({
                                      'phone': contactController.text
                                    }).then((value) => Fluttertoast.showToast(
                                            msg: "Successfully!"));
                                  }),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Future<String?> uploadImage(String filePath) async {
    try {
      final fileName = Uuid().v4();
      final Reference fbStorage =
          FirebaseStorage.instance.ref('profile').child(fileName);
      final UploadTask uploadTask = fbStorage.putFile(File(filePath));

      await uploadTask.then((p0) async {
        downloadUrl = await fbStorage.getDownloadURL();
      });
      return downloadUrl;
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong!");
    }
  }

  update() async {
    setState(() {
      isSaving = true;
    });

    uploadImage(profilePic!).then((value) {
      Map<String, dynamic> data = {
        'name': nameController.text,
        'profilePic': downloadUrl
      };
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data);
    });

    setState(() {
      isSaving = false;
    });
  }
}