import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zwap_test/user_auth/presentation/pages/signup.dart';
import 'package:zwap_test/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: FirebaseOptions(
      apiKey: "AIzaSyDs8rOyyudjUqXDamZUUTeMIpEYC3qzRNk",
      appId: "1:220218679360:android:0eea04963133fb1af13fa5",
      messagingSenderId: "220218679360",
      projectId: "zwap-99cf8",
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

      home: SplashScreen(
        child: SignUpScreen(),
      ), // Set SplashScreen as the initial screen
    );
  }
}
