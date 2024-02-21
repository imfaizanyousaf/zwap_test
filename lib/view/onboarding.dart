import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/components/buttons/primaryLarge.dart';
import 'package:zwap_test/view/user_auth/signup.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColor.primary,
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              child: Image.asset(
                'assets/onboarding-1.jpg',
                fit: BoxFit.fill,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Meet New People',
                        style: GoogleFonts.manrope(
                            textStyle: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                          letterSpacing: 0.150000006,
                          color: Colors.white,
                        ))),
                    SizedBox(height: 16),
                    Text('Lorem ipsum dolor sit amet consectetur.',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.4285714286,
                          letterSpacing: 0.25,
                          color: Colors.white70,
                        )),
                    SizedBox(height: 32),
                    PrimaryLarge(
                      color: Colors.white,
                      text: "Continue",
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
