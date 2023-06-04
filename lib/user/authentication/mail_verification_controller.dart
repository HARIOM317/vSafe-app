import 'package:email_auth/email_auth.dart';
import 'package:get/get.dart';

class MailVerificationController extends GetxController{
  EmailAuth emailAuth = EmailAuth(sessionName: "vSafe - Women Safety App");
  
  var status = "".obs;

  Future<void> sendOTP(String email) async {
    var res = await emailAuth.sendOtp(recipientMail: email, otpLength: 6);
    if(res){
      status.value = "OTP sent successfully";
    } else {
      status.value = "Failed to sent OTP!";
    }
  }

  void validateOTP(String email, String otp){
    var res = emailAuth.validateOtp(recipientMail: email, userOtp: otp);
    if(res) {
      status.value = "OTP verification successful";
    } else {
      status.value = "Wrong OTP!";
    }
  }
}