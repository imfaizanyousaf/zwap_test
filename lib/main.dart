import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zwap_test/view/home.dart';
import 'package:zwap_test/view/user_auth/signup.dart';
import 'package:zwap_test/view/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: 'assets/.env');
  print(dotenv.env["API_KEY"].toString());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: FirebaseOptions(
      apiKey: dotenv.env["API_KEY"].toString(),
      appId: dotenv.env["API_ID"].toString(),
      messagingSenderId: dotenv.env["MESSAGING_SENDER_ID"].toString(),
      projectId: dotenv.env["PROJECT_ID"].toString(),
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zwap',
      home: HomeScreen(),
      // home: SplashScreen(
      //   child: SignUpScreen(),
      // ), // Set SplashScreen as the initial screen
    );
  }
}
