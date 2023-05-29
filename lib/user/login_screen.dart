import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_safe/components/custom_textfield.dart';
import 'package:v_safe/components/primary_button.dart';
import 'package:v_safe/components/secondary_button.dart';
import 'package:v_safe/db/share_pref.dart';
import 'package:v_safe/pages/main_splash_screen.dart';
import 'package:v_safe/user/forgot_password_page.dart';
import 'package:v_safe/user/register_user.dart';
import 'package:v_safe/utils/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordHide = true;
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool isLoading = false;

  // on submit function
  _onSubmit() async {
    _formKey.currentState!.save();

    try {
      setState(() {
        isLoading = true;
      });
      // progressIndicator(context);
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _formData['email'].toString(),
              password: _formData['password'].toString());

      if (userCredential.user != null) {
        setState(() {
          isLoading = false;
        });
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get()
            .then((value) {
          if (value['type'] == 'user') {
            MySharedPreference.saveUserType('user');
            goTo(context, MainSplashScreen());
          }
        });
        // MySharedPreference.saveUser();
        goTo(context, MainSplashScreen());
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });

      if (e.code == 'user-not-found') {
        showAlertDialogueBox(context, "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        showAlertDialogueBox(context, "Invalid username or password!");
      }
    }

    print("Email : ${_formData['email']}");
    print("Password : ${_formData['password']}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xffdad4ec).withOpacity(0.75),
          Color(0xffdad4ec).withOpacity(0.5),
          Color(0xfff3e7e9).withOpacity(0.75)
        ])
        ),
        child: Center(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  isLoading
                      ? progressIndicator(context)
                      : SingleChildScrollView(
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

                              // login text
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  "Welcome",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Dosis-Regular',
                                    color: Color(0xff401693),
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),

                              // form
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: LoginTextField(
                                        hintText: "Email",
                                        textInputAction: TextInputAction.next,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        prefix: Icon(Icons.person),
                                        onSave: (email) {
                                          _formData['email'] = email ?? "";
                                        },
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
                                      child: LoginTextField(
                                        hintText: "Password",
                                        keyboardType: TextInputType.visiblePassword,
                                        prefix: Icon(Icons.fingerprint),
                                        onSave: (password) {
                                          _formData['password'] =
                                              password ?? "";
                                        },
                                        validate: (password) {
                                          if (password!.isEmpty ||
                                              password.length < 8 ||
                                              password.contains(" ")) {
                                            return "Incorrect password";
                                          } else {
                                            return null;
                                          }
                                        },
                                        isPassword: isPasswordHide,
                                        suffix: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isPasswordHide = !isPasswordHide;
                                            });
                                          },
                                          icon: isPasswordHide
                                              ? Icon(Icons.visibility_off)
                                              : Icon(Icons.visibility),
                                        ),
                                      ),
                                    ),

                                    // forgot password button
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5,
                                          bottom: 10,
                                          left: 15,
                                          right: 15),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswodPage()));
                                          },
                                          child: Text(
                                            "Forgot Password?",
                                            style: TextStyle(
                                                fontFamily: 'PTSans-Regular',
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // login button
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: PrimaryButton(
                                        title: "Login",
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _onSubmit();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // create new account button
                              Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account?",
                                      style: TextStyle(
                                          fontFamily: 'PTSans-Regular'),
                                    ),
                                    SecondaryButton(
                                        title: "Create new account",
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RegisterUser()));
                                        }),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
