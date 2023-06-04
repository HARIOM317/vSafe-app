import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_safe/components/custom_textfield.dart';
import 'package:v_safe/components/primary_button.dart';
import 'package:v_safe/user/authentication/mail_verification_controller.dart';

class EmailVerificationPage extends StatelessWidget{

  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  MailVerificationController mailVerificationController = Get.put(MailVerificationController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xffdad4ec).withOpacity(0.75),
              Color(0xffdad4ec).withOpacity(0.5),
              Color(0xfff3e7e9).withOpacity(0.75)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Email Authentication",
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LoginTextField(
                hintText: "Enter Email",
                controller: emailController,
                textInputAction: TextInputAction.next,
                keyboardType:
                TextInputType.emailAddress,
                prefix: Icon(Icons.email),
                suffix: TextButton(
                  onPressed: (){
                    mailVerificationController.sendOTP(emailController.text.trim());
                  },
                  child: Text("Send OTP"),
                ),

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
                hintText: "Enter OTP",
                controller: otpController,
                textInputAction: TextInputAction.next,
                prefix: Icon(Icons.password),
                keyboardType: TextInputType.emailAddress,

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

            PrimaryButton(
                title: "Verify OTP",
                onPressed: () {
                  mailVerificationController.validateOTP(emailController.text.trim(), otpController.text.trim());
                }
            ),

            Obx(() => Text(
                "Status: ${mailVerificationController.status.value}",
                style: TextStyle(fontSize: 18), textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}