import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/home.dart';
import 'package:zwap_test/view/onboarding.dart';
import 'package:zwap_test/view/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:zwap_test/view_model/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.manrope().fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Zwap',
      // home: HomeScreen(),
      home: SplashScreen(
        child: OnboardingScreen(),
      ), // Set SplashScreen as the initial screen
    );
  }
}
