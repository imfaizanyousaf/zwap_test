import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/components/buttons/primaryLarge.dart';
import 'package:zwap_test/constants/colors.dart';
import 'package:zwap_test/user_auth/firebase_auth/firebaseauth_services.dart';
import 'package:zwap_test/user_auth/presentation/pages/signin.dart';
import 'package:zwap_test/user_auth/presentation/pages/verify.dart';
import '/components/textFields/outlined.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool isSigningUp = false;
  bool _validEmail = true;
  bool _validName = true;
  bool _validPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
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
                Text('Create an Account',
                    style: GoogleFonts.manrope(
                        textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      letterSpacing: 0.150000006,
                      color: Color(0xff000000),
                    ))),
                Text('Enter the following details',
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
                  label: "Full Name",
                  controller: _nameController,
                  onChanged: (_nameController) {
                    isNameValid();
                  },
                  valid: _validName,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFieldOutlined(
                  label: "Email",
                  controller: _emailController,
                  valid: _validEmail,
                  onChanged: (_emailController) {
                    isEmailValid();
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFieldOutlined(
                  label: "Password",
                  valid: _validPassword,
                  onChanged: (_passwordController) {
                    isPasswordValid();
                  },
                  obscureText: true,
                  controller: _passwordController,
                  suffixIcon: Icons.remove_red_eye,
                ),
                SizedBox(
                  height: 16,
                ),
                PrimaryLarge(
                    loading: isSigningUp,
                    text: 'Sign Up',
                    onPressed: !_validEmail || !_validName || !_validPassword
                        ? null
                        : () {
                            _signUp(context);
                          }),
                SizedBox(
                  height: 16,
                ),
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: Colors.black87,
                        )),
                    TextSpan(
                        text: 'Login',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VerifyScreen(),
                                ));
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

  void _signUp(BuildContext context) async {
    setState(() {
      isSigningUp = true;
    });

    isEmailValid();
    isPasswordValid();
    isNameValid();
    if (!_validEmail || !_validName || !_validPassword) {
      setState(() {
        isSigningUp = false;
      });
      return;
    }
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigningUp = false;
    });

    if (user != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => VerifyScreen()),
        (Route route) => false,
      );
    }
  }

  void isPasswordValid() {
    String password = _passwordController.text.trim();

    // Check if the password is empty
    if (password.isEmpty) {
      setState(() {
        _validPassword = false;
      });
      return;
    }

    // Check for the minimum password length (you can adjust the length as needed)
    const int minLength = 6;

    setState(() {
      _validPassword = password.length >= minLength;
    });
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

  void isNameValid() {
    String name = _nameController.text.trim();

    // Check if the name is empty
    if (name.isEmpty) {
      setState(() {
        _validName = false;
      });
      return;
    }

    // If the name is not empty, consider it valid
    setState(() {
      _validName = true;
    });
  }
}
