import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_safe/components/custom_textfield.dart';
import 'package:v_safe/components/primary_button.dart';
import 'package:v_safe/components/secondary_button.dart';
import 'package:v_safe/pages/home_screen.dart';
import 'package:v_safe/user/register_user.dart';
import 'package:v_safe/utils/constants.dart';
import 'package:v_safe/widgets/bottom_nav_bar.dart';

import 'package:email_auth/email_auth.dart';

class VerifyUserEmail extends StatefulWidget {
  @override
  State<VerifyUserEmail> createState() => _VerifyUserEmail();
}

class _VerifyUserEmail extends State<VerifyUserEmail> {
  // bool isPasswordHide = true;
  // final _formKey = GlobalKey<FormState>();
  // final _formData = Map<String, Object>();
  // bool isLoading = false;

  // on submit function
  // _onSubmit() async {
  //   _formKey.currentState!.save();

  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     // progressIndicator(context);
  //     UserCredential userCredential = await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(
  //             email: _formData['email'].toString(),
  //             password: _formData['password'].toString());

  //     if (userCredential.user != null) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       goTo(context, BottomNavBar());
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });

  //     if (e.code == 'user-not-found') {
  //       showAlertDialogueBox(context, "No user found for that email.");
  //     } else if (e.code == 'wrong-password') {
  //       showAlertDialogueBox(context, "Wrong password provided for that user.");
  //     }
  //   }

  //   print("Email : ${_formData['email']}");
  //   print("Password : ${_formData['password']}");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xffdad4ec).withOpacity(0.5),
          Color(0xffdad4ec).withOpacity(0.5),
          Color(0xfff3e7e9).withOpacity(0.5)
        ])),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // app icon
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/icon/logo.png",
                          width: 120,
                        ),
                      ),

                      // Email Authentication Text
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Email Authentication",
                          style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'Roboto-Regular',
                              color: Colors.deepPurple),
                        ),
                      ),

                      // form
                      Form(
                        // key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomTextField(
                                hintText: "Email",
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                suffix: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Send OTP",
                                    style: TextStyle(
                                        fontFamily: 'PTSans-Regular',
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                    // textAlign: TextAlign.right,
                                  ),
                                ),

                                // onSave: (email) {
                                //   _formData['email'] = email ?? "";
                                // },
                                validate: (email) {
                                  if (email!.isEmpty ||
                                      email.length < 8 ||
                                      !email.contains("@") ||
                                      email.contains(" ")) {
                                    return "Invalid email address";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomTextField(
                                hintText: "Enter OTP",

                                onSave: (password) {
                                  // _formData['password'] =
                                  //     password ?? "";
                                },
                                validate: (password) {
                                  if (password!.isEmpty ||
                                      password.length < 8 ||
                                      password.contains(" ")) {
                                    return "Incorrect OTP";
                                  } else {
                                    return null;
                                  }
                                },
                                // isPassword: isPasswordHide,
                                // suffix: IconButton(
                                // onPressed: () {
                                //   setState(() {
                                //     isPasswordHide = !isPasswordHide;
                                //   });
                                // },
                                // icon: isPasswordHide
                                //     ? Icon(Icons.visibility_off)
                                //     : Icon(Icons.visibility),
                                // ),
                              ),
                            ),

                            // OTP Verification Button
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PrimaryButton(
                                  title: "Verify OTP",
                                  onPressed: () {
                                    // if (_formKey.currentState!
                                    //     .validate()) {
                                    //   _onSubmit();
                                  }
                                  // },
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
