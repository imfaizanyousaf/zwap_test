import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/global/commons/toast.dart';
import 'package:zwap_test/view/home.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  late Timer _timer;
  late Timer _resendTimer;
  bool isResendButtonDisabled = true;
  int countdown = 60;

  @override
  void initState() {
    super.initState();

    // Automatically send the email verification link the first time
    _sendEmailVerification();

    // Start a periodic timer to check email verification status every 3 seconds
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _checkVerificationStatus();
    });

    // Set a timer to enable the button after 60 seconds
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (isResendButtonDisabled && countdown > 0) {
          countdown--;
        } else {
          // Enable the button when the countdown reaches 0
          isResendButtonDisabled = false;
          _resendTimer.cancel();
        }
      });
    });
  }

  Future<void> _sendEmailVerification() async {
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
  }

  Future<void> _checkVerificationStatus() async {
    try {
      await FirebaseAuth.instance.currentUser!.reload();
    } on FirebaseAuthException catch (e) {
      print("${e.code}");
    }

    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      // Stop the timer if email is verified
      _timer.cancel();

      // Navigate to the next screen or perform further actions
      showToast(message: 'Email verified successfully!');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route route) => false,
      );
    }
  }

  void _handleResendButton() {
    if (!isResendButtonDisabled) {
      // Disable the button
      setState(() {
        isResendButtonDisabled = true;
      });

      // Reset the countdown timer
      setState(() {
        countdown = 60;
      });

      // Set a timer to enable the button after 60 seconds
      _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (countdown > 0) {
            countdown--;
          } else {
            // Enable the button when the countdown reaches 0
            isResendButtonDisabled = false;
            _resendTimer.cancel();
          }
        });
      });

      // Resend the email verification link
      _sendEmailVerification();
    }
  }

  @override
  void dispose() {
    // Cancel the timers to avoid memory leaks
    _timer.cancel();
    _resendTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/email-illustration.svg',
            ),
            Text('Verify your email address',
                style: GoogleFonts.manrope(
                    textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  letterSpacing: 0.150000006,
                  color: Color(0xff000000),
                ))),
            SizedBox(height: 16),
            Text('A verification link has been sent to:',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.4285714286,
                  letterSpacing: 0.25,
                  color: Color(0xff5c5c5c),
                )),
            SizedBox(height: 8),
            Text(
              FirebaseAuth.instance.currentUser!.email!,
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4285714286,
                letterSpacing: 0.25,
                color: Color.fromARGB(255, 32, 32, 32),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleResendButton,
              child: isResendButtonDisabled
                  ? Text("Resend Link in $countdown")
                  : Text('Resend Link'),
              // Disable the button based on the isResendButtonDisabled variable
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isResendButtonDisabled ? Colors.grey : AppColor.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
