import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zwap_test/global/commons/toast.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _sendEmailVerification();

    // Start a periodic timer to check email verification status every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _checkVerificationStatus();
    });
  }

  Future<void> _sendEmailVerification() async {
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();

    // You can handle the result accordingly, for simplicity, just print the result
    print(
        "Email verification sent to: ${FirebaseAuth.instance.currentUser!.email}");
  }

  Future<void> _checkVerificationStatus() async {
    await FirebaseAuth.instance.currentUser!.reload();

    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      // Stop the timer if email is verified
      _timer.cancel();

      // Navigate to the next screen or perform further actions
      showToast(message: 'Email verified successfully!');
    } else {
      // Email not verified yet. Display a message if needed.

      showToast(message: 'Email not verified yet. Please check your email.');
    }
  }

  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'An verification link has been sent to:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              FirebaseAuth.instance.currentUser!
                  .email!, // Use FirebaseAuth.instance.currentUser! instead of widget.user
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Please check your email and verify your account.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
