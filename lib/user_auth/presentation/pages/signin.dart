import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/components/buttons/primaryLarge.dart';
import 'package:zwap_test/constants/colors.dart';
import 'package:zwap_test/home.dart';
import 'package:zwap_test/user_auth/presentation/pages/signup.dart';
import '/components/textFields/outlined.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 48,
                ),
                SvgPicture.asset(
                  'assets/zwap.svg',
                  height: 33.0,
                  width: 150.0,
                ),
                SizedBox(
                  height: 48,
                ),
                Text('Sign In',
                    style: GoogleFonts.manrope(
                        textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      letterSpacing: 0.150000006,
                      color: Color(0xff000000),
                    ))),
                Text('Enter the following details to continue',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.4285714286,
                      letterSpacing: 0.25,
                      color: Color(0xff5c5c5c),
                    )),
                SizedBox(
                  height: 48,
                ),
                TextFieldOutlined(
                  label: "Email",
                  controller: _emailController,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFieldOutlined(
                  label: "Password",
                  obscureText: true,
                  controller: _passwordController,
                  suffixIcon: Icons.remove_red_eye,
                ),
                SizedBox(
                  height: 16,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: RichText(
                    text: TextSpan(
                        text: 'Forgot Password?',
                        recognizer: TapGestureRecognizer()..onTap = () {},
                        style: GoogleFonts.manrope(
                            textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                          letterSpacing: 0.150000006,
                          color: AppColor.primary,
                        ))),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                PrimaryLarge(
                    text: 'Sign In',
                    onPressed: () => {
                          Navigator.pushAndRemoveUntil<void>(
                              context,
                              MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      HomeScreen()),
                              ModalRoute.withName('/'))
                        }),
                SizedBox(
                  height: 16,
                ),
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'Don\'t have an account? ',
                        style: TextStyle(
                          color: Colors.black87,
                        )),
                    TextSpan(
                        text: 'Create an Account',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushAndRemoveUntil<void>(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        SignUpScreen()),
                                ModalRoute.withName('/'));
                          },
                        style: TextStyle(
                          color: AppColor.primary,
                        ))
                  ])),
                ),
                SizedBox(
                  height: 16,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
