import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/view/home.dart';
import 'package:zwap_test/view/onboarding.dart';
import 'package:zwap_test/view/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:zwap_test/view_model/user.dart';

void main() async {
  await dotenv.load(fileName: 'assets/.env');
  print(dotenv.env["API_KEY"].toString());
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   // Replace with actual values
  //   options: FirebaseOptions(
  //     apiKey: dotenv.env["API_KEY"].toString(),
  //     appId: dotenv.env["API_ID"].toString(),
  //     messagingSenderId: dotenv.env["MESSAGING_SENDER_ID"].toString(),
  //     projectId: dotenv.env["PROJECT_ID"].toString(),
  //   ),
  // );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: GoogleFonts.manrope().fontFamily),
      debugShowCheckedModeBanner: false,
      title: 'Zwap',
      // home: HomeScreen(),
      home: SplashScreen(
        child: OnboardingScreen(),
      ), // Set SplashScreen as the initial screen
    );
  }
}
