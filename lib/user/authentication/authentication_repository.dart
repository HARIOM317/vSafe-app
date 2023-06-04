import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:v_safe/pages/main_splash_screen.dart';
import 'package:v_safe/user/authentication/signup_email_password_failure.dart';
import 'package:v_safe/user/welcome_screen.dart';
import 'package:v_safe/utils/constants.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => const WelcomeScreen())
        : Get.offAll(() => MainSplashScreen());
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser.value != null ? Get.offAll(() => MainSplashScreen()) : Get.to(() => WelcomeScreen());
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (_) {}
  }

  Future<void> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
    } catch (_) {}
  }

  Future<void> logout() async => await _auth.signOut();
}
