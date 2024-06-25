import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/global/commons/toast.dart';
import 'package:zwap_test/model/user.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/utils/connection.dart';
import 'package:zwap_test/view/add_interests.dart';
import 'package:zwap_test/view/components/buttons/primaryLarge.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/home.dart';
import 'package:zwap_test/view/user_auth/signin.dart';
import 'package:zwap_test/view/user_auth/verify.dart';
import 'package:zwap_test/view/components/textFields/outlined.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  api user = api();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isSigningUp = false;
  bool _validFirstName = true;
  bool _validLastName = true;
  bool _validEmail = true;
  bool _validPassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
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
                  height: 32,
                ),
                TextFieldOutlined(
                  label: "First Name",
                  errorMessage: "First name is required",
                  controller: _firstNameController,
                  onChanged: (_firstNameController) {
                    isFirstNameValid();
                  },
                  valid: _validFirstName,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFieldOutlined(
                  label: "Last Name",
                  errorMessage: "Last name is required",
                  controller: _lastNameController,
                  onChanged: (_lastNameController) {
                    isLastNameValid();
                  },
                  valid: _validLastName,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFieldOutlined(
                  label: "Email",
                  errorMessage: _emailController.text.isEmpty
                      ? "Email is required"
                      : "Invalid Email",
                  controller: _emailController,
                  valid: _validEmail,
                  keyboard: TextInputType.emailAddress,
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
                  errorMessage: _passwordController.text.isEmpty
                      ? "Password is required"
                      : "Minimum password length must be 8",
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
                    onPressed: !_validEmail ||
                            !_validFirstName ||
                            !_validLastName ||
                            !_validPassword
                        ? null
                        : () async {
                            if (await isConnected()) {
                              _signUp(context);
                            } else {
                              showToast(message: "No Internet Connection");
                            }
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
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()),
                              (Route route) => false,
                            );
                          },
                        style: TextStyle(
                          color: AppColor.primary,
                        ))
                  ])),
                ),
                SizedBox(
                  height: 32,
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
    isFirstNameValid();
    isLastNameValid();
    if (!_validEmail ||
        !_validFirstName ||
        !_validLastName ||
        !_validPassword) {
      setState(() {
        isSigningUp = false;
      });
      return;
    }
    // final response = '200';
    final response = await user.register(
        _firstNameController.text.toString(),
        _lastNameController.text.toString(),
        _emailController.text.toString(),
        _passwordController.text.toString());

    if (response == '200') {
      // User _currentUser = await user.getUser();
      // print(_currentUser.toJson());

      showToast(message: "User Registered Successfully");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => AddInterestsScreen(
                  previousScreen: 'SignUpScreen',
                )),
        (Route route) => false,
      );
    } else if (response == '302') {
      api user = api();
      User currentUser = await user.getUser(null);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(
                  currentUser: currentUser,
                )),
        (Route route) => false,
      );
    } else {
      showToast(message: "User Registration Failed: $response");
    }
    setState(() {
      isSigningUp = false;
    });

    // if (user != null) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => VerifyScreen()),
    //   );
    // }
  }

  void isPasswordValid() {
    String password = _passwordController.text.trim();

    if (password.isEmpty) {
      setState(() {
        _validPassword = false;
      });
      return;
    }

    const int minLength = 8;

    setState(() {
      _validPassword = password.length >= minLength;
    });
  }

  void isEmailValid() {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _validEmail = false;
      });
      return;
    }
    RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

    setState(() {
      _validEmail = emailRegex.hasMatch(email);
    });
  }

  void isFirstNameValid() {
    String firstName = _firstNameController.text.trim();

    if (firstName.isEmpty) {
      setState(() {
        _validFirstName = false;
      });
      return;
    }

    setState(() {
      _validFirstName = true;
    });
  }

  void isLastNameValid() {
    String lastName = _lastNameController.text.trim();

    if (lastName.isEmpty) {
      setState(() {
        _validLastName = false;
      });
      return;
    }

    setState(() {
      _validLastName = true;
    });
  }
}
