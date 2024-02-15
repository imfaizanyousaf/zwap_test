import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/view/components/buttons/primaryLarge.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/global/commons/toast.dart';
import 'package:zwap_test/view/home.dart';
import 'package:zwap_test/data/firebase_auth/firebaseauth_services.dart';
import 'package:zwap_test/view/user_auth/signup.dart';
import 'package:zwap_test/view/components/textFields/outlined.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isSigning = false;
  bool _validEmail = true;
  bool _validPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

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
                  valid: _validEmail,
                  errorMessage: "Invalid Email",
                  keyboard: TextInputType.emailAddress,
                  controller: _emailController,
                  onChanged: (_emailController) {
                    isEmailValid();
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFieldOutlined(
                  label: "Password",
                  errorMessage: "Invalid Password",
                  valid: _validPassword,
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
                  loading: isSigning,
                  onPressed: () {
                    _signIn(context);
                  },
                ),
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

  void _signIn(BuildContext context) async {
    setState(() {
      isSigning = true;
    });
    isEmailValid();
    if (!_validEmail) {
      setState(() {
        isSigning = false;
      });
      return;
    }
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.sigInWithEmailAndPassword(email, password);

    setState(() {
      isSigning = false;
    });
    if (user != null) {
      showToast(message: 'Login Successful');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route route) => false,
      );
    }
  }

  void isEmailValid() {
    String email = _emailController.text.trim();

    // Check if the email is empty
    if (email.isEmpty) {
      setState(() {
        _validEmail = false;
      });
      return;
    }
    // Regular expression for a basic email validation
    RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

    setState(() {
      _validEmail = emailRegex.hasMatch(email);
    });
  }
}
