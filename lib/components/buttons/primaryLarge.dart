import 'package:flutter/material.dart';
import 'package:zwap_test/constants/colors.dart';

class PrimaryLarge extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color? color;
  PrimaryLarge({
    required this.text,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        padding: EdgeInsets.symmetric(vertical: 18.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45.0),
        ),
      ),
      child: Container(
        width: double.infinity,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
              letterSpacing: 1.25,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
