import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_safe/components/custom_textfield.dart';
import 'package:v_safe/components/primary_button.dart';
import 'package:v_safe/utils/constants.dart';

class ForgotPasswodPage extends StatefulWidget{
  @override
  State<ForgotPasswodPage> createState() => _ForgotPasswodPageState();
}

class _ForgotPasswodPageState extends State<ForgotPasswodPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async{
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      showAlertDialogueBox(context, "Password reset link sent! Check your email");
    } on FirebaseAuthException catch (e) {
      showAlertDialogueBox(context, e.message.toString());
    }
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
        
        child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // app icon
                    Padding(
                      padding: const EdgeInsets.only(top: 60, bottom: 20),
                      child: Image.asset(
                        "assets/images/icon/logo.png",
                        width: 120,
                      ),
                    ),

                    // login text
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Enter your email and we will send you a password reset link",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Dosis-Regular',
                            color: Color(0xff401693),
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LoginTextField(
                        controller: _emailController,
                        hintText: "Email",
                        textInputAction: TextInputAction.next,
                        keyboardType:
                        TextInputType.emailAddress,
                        prefix: Icon(Icons.email_rounded),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                          onPressed: () {
                            passwordReset();
                          },
                        child: Text("Reset Password"),
                        color: primaryColor,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.deepPurpleAccent)
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}