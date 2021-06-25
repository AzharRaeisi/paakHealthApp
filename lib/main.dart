import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paakhealth/screens/home_screen.dart';
import 'package:paakhealth/screens/loading_screen.dart';
import 'package:paakhealth/screens/main_screen.dart';
import 'package:paakhealth/screens/pharmacy_screen.dart';
import 'package:paakhealth/screens/setup_profile_screen.dart';
import 'package:paakhealth/screens/welcome_back_screen.dart';
import 'package:paakhealth/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PaakHealth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryTextTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: LoadingScreen(),
    );
  }
}
