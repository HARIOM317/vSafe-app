import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:v_safe/src/db/share_pref.dart';
import 'package:v_safe/src/pages/intro_pages/splash_screen.dart';
import 'package:v_safe/src/pages/required_pages/main_splash_screen.dart';
import 'package:v_safe/src/utils/constants.dart';
import 'package:v_safe/src/utils/flutter_background_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MySharedPreference.init();
  await initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // stop auto rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'vSafe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.aksharTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.deepPurple,
      ),

      // todo -----X----- STARTING POINT OF APP -----X-----
      home: FutureBuilder(
          future: MySharedPreference.getUserType(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == "") {
              return const SplashScreen();
            }
            if (snapshot.data == "user") {
              return const MainSplashScreen();
            }
            return progressIndicator(context);
          }),

    );
  }
}