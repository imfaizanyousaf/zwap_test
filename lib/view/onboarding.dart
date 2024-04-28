import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/view/components/buttons/primaryLarge.dart';
import 'package:zwap_test/view/home.dart';
import 'package:zwap_test/view/user_auth/signin.dart';
import 'package:zwap_test/view/user_auth/signup.dart';
import 'package:zwap_test/view_model/user.dart';

class OnboardingScreen extends StatelessWidget {
  //create user view_model object
  final UserViewModel user = UserViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: AppColor.background,
          child: Column(
            children: [
              Image.asset(
                "assets/onboarding-1.png",
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Meet, Exchange and Save Money',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                            textStyle: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          letterSpacing: 0.150000006,
                          color: AppColor.primary,
                        ))),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColor.secondaryDark),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                    ),
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpScreen()),
                                        (route) => false,
                                      );
                                    },
                                    child: Text("Join Now")),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                    style: ButtonStyle(
                                        side: MaterialStateProperty.all(
                                            BorderSide(
                                                color: AppColor.secondaryDark)),
                                        elevation: MaterialStateProperty.all(0),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                AppColor.secondaryDark),
                                        surfaceTintColor:
                                            MaterialStateProperty.all(AppColor
                                                .secondaryDark
                                                .withOpacity(.5))),
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignInScreen()),
                                        (route) => false,
                                      );
                                    },
                                    child: Text("Login")),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: TextButton(
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColor.background),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              AppColor.primary),
                                    ),
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen()),
                                        (route) => false,
                                      );
                                    },
                                    child: Text("Guest Mode")),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
