import 'package:flutter/material.dart';
//import 'package:zwap_test/signin.dart';
import 'package:zwap_test/user_auth/presentation/pages/signup.dart';
import 'package:zwap_test/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zwap',

      home: SplashScreen(
        child: SignUpScreen(),
      ), // Set SplashScreen as the initial screen
    );
  }
}
