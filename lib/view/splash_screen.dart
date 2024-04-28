import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Move time-consuming operations to post-frame callback
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      precacheImage(AssetImage("assets/onboarding-1.png"), context);

      Timer(
        Duration(seconds: 0),
        () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => widget.child!),
          (route) => false,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your logo here
            SvgPicture.asset(
              'assets/icon.svg',
              height: 80.0,
              width: 80.0,
            ),

            SizedBox(height: 16),
            // Add any additional widgets, such as a loading indicator
          ],
        ),
      ),
    );
  }
}
