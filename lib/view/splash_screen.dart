import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zwap_test/global/commons/toast.dart';
import 'package:zwap_test/model/user.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/utils/connection.dart';
import 'package:zwap_test/view/home.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;

  const SplashScreen({Key? key, this.child}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int session = 0;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    checkSession();
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
            Text(
              'Aa rha hu bhai. Bas nikal aya',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Add any additional widgets, such as a loading indicator
          ],
        ),
      ),
    );
  }

  void checkSession() async {
    bool connected = await isConnected();
    if (connected) {
      api _api = api();
      int statusCode = await _api.checkSession();
      setState(() {
        session = statusCode;
      });

      if (statusCode == 200) {
        // Session is valid, get current user
        try {
          User user = await _api.getUser(null);
          User userFull = await _api.getUser(user.id);
          setState(() {
            _currentUser = userFull;
          });
          // Navigate to HomeScreen with the current user
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(currentUser: _currentUser!)),
            (route) => false,
          );
        } catch (e) {
          print('Error fetching user: $e');
          // Handle error fetching user data
        }
      } else {
        // Session is not valid, navigate to the specified child widget
        if (widget.child != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => widget.child!),
            (route) => false,
          );
        }
      }
    } else {
      showToast(message: 'No internet connection');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => widget.child!),
        (route) => false,
      );
    }
  }
}
