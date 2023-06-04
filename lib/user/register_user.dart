import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_safe/components/custom_textfield.dart';
import 'package:v_safe/components/primary_button.dart';
import 'package:v_safe/components/secondary_button.dart';
import 'package:v_safe/model/user_model.dart';
import 'package:v_safe/user/login_screen.dart';
import 'package:v_safe/utils/constants.dart';

class RegisterUser extends StatefulWidget {
  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  bool isPasswordHide = true;
  bool isConfirmPasswordHide = true;
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool isLoading = false;

  // function to disable back button
  Future<bool> _onPop() async {
    return false;
  }

  // final _auth = FirebaseAuth.instance;
  //
  // Future<void> sendEmailVerification() async{
  //   try{
  //     _auth.currentUser!.sendEmailVerification();
  //   } on FirebaseAuthException catch(e){
  //     showAlertDialogueBox(context, e.message.toString());
  //   } catch(e){
  //     showAlertDialogueBox(context, "Something went wrong!");
  //   }
  // }

  // on submit function
  _onSubmit() async {
    _formKey.currentState!.save();

    // checking both password are equal or not
    if (_formData['password'] != _formData['confirm_password']) {
      showAlertDialogueBox(
          context, "Passwords do not match! \nPlease try again.");
    } else {
      progressIndicator(context);
      try {
        setState(() {
          isLoading = true;
        });
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _formData['email'].toString(),
                password: _formData['password'].toString());

        if (userCredential.user != null) {
          setState(() {
            isLoading = true;
          });

          final value = userCredential.user!.uid;

          DocumentReference<Map<String, dynamic>> db =
              FirebaseFirestore.instance.collection('users').doc(value);

          final user = UserModel(
              id: value,
              email: _formData['email'].toString(),
              name: _formData['name'].toString(),
              phone: _formData['phone'].toString(),
              type: 'user');

          final jsonData = user.toJson();

          await db.set(jsonData).whenComplete(() {
            goTo(context, LoginScreen());
            setState(() {
              isLoading = false;
            });
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        if (e.code == 'weak-password') {
          showAlertDialogueBox(context, "The password provided is too weak.");
        } else if (e.code == 'email-already-in-use') {
          showAlertDialogueBox(
              context, "The account already exists for that email.");
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        showAlertDialogueBox(context, "Something went wrong!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onPop,

      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0xffdad4ec).withOpacity(0.75),
            Color(0xffdad4ec).withOpacity(0.5),
            Color(0xfff3e7e9).withOpacity(0.75)
          ])),
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
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "User Registration",
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
                                        padding: const EdgeInsets.only(
                                            top: 8, left: 8, right: 8, bottom: 5),
                                        child: CustomTextField(
                                          hintText: "Name",
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.name,
                                          prefix: Icon(Icons.person),
                                          onSave: (name) {
                                            _formData['name'] = name ?? "";
                                          },
                                          validate: (name) {
                                            if (name!.isEmpty ||
                                                name.length < 3) {
                                              return "Incorrect name";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, left: 8, right: 8, bottom: 5),
                                        child: CustomTextField(
                                          hintText: "Phone",
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.phone,
                                          prefix: Icon(Icons.phone),
                                          onSave: (phone) {
                                            _formData['phone'] = phone ?? "";
                                          },
                                          validate: (phone) {
                                            if (phone!.isEmpty ||
                                                phone.length != 10) {
                                              return "Incorrect mobile number";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, left: 8, right: 8, bottom: 5),
                                        child: CustomTextField(
                                          hintText: "Email",
                                          textInputAction: TextInputAction.next,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          prefix: Icon(Icons.email),
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
                                        padding: const EdgeInsets.only(
                                            top: 5, left: 8, right: 8, bottom: 5),
                                        child: CustomTextField(
                                          hintText: "Password",
                                          textInputAction: TextInputAction.next,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          prefix: Icon(Icons.lock_rounded),
                                          onSave: (password) {
                                            _formData['password'] =
                                                password ?? "";
                                          },
                                          validate: (password) {
                                            if (password!.isEmpty ||
                                                password.length < 8 ||
                                                password.contains(" ")) {
                                              return "Password length should be more than 8 characters";
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

                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, left: 8, right: 8, bottom: 8),
                                        child: CustomTextField(
                                          hintText: "Confirm Password",
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          prefix: Icon(Icons.lock_rounded),
                                          onSave: (password) {
                                            _formData['confirm_password'] =
                                                password ?? "";
                                          },
                                          validate: (Confirm_password) {
                                            if (Confirm_password!.isEmpty ||
                                                Confirm_password.length < 8 ||
                                                Confirm_password.contains(" ")) {
                                              return "Password length should be more than 8 characters";
                                            } else {
                                              return null;
                                            }
                                          },
                                          isPassword: isConfirmPasswordHide,
                                          suffix: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isConfirmPasswordHide =
                                                    !isConfirmPasswordHide;
                                              });
                                            },
                                            icon: isConfirmPasswordHide
                                                ? Icon(Icons.visibility_off)
                                                : Icon(Icons.visibility),
                                          ),
                                        ),
                                      ),

                                      // login button
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: PrimaryButton(
                                          title: "Register",
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Already have an account?",
                                        style: TextStyle(
                                            fontFamily: 'PTSans-Regular'),
                                      ),
                                      SecondaryButton(
                                          title: "Sign in",
                                          onPressed: () {
                                            goTo(context, LoginScreen());
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
      ),
    );
  }
}
