import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:v_safe/db/share_pref.dart';
import 'package:v_safe/pages/intro_pages/splash_screen.dart';
import 'package:v_safe/pages/main_splash_screen.dart';
import 'package:v_safe/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MySharedPreference.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'vSafe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.aksharTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.deepPurple,
      ),

      home: FutureBuilder(
          future: MySharedPreference.getUserType(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == "") {
              return SplashScreen();
            }
            if (snapshot.data == "user") {
              return MainSplashScreen();
            }
            return progressIndicator(context);
          }),

    );
  }
}

// class CheckAuth extends StatelessWidget {
//   checkUserAuth() {
//     if(MySharedPreference.getUserType() == 'user'){

//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//     );
//   }
// }