import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

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
    // Add any initialization code here

    // Example: Navigate to the home screen after 2 seconds
    Timer(
      Duration(seconds: 2),
      () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => widget.child!),
          (route) => false),
    );
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
