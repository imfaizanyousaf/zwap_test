import 'package:flutter/material.dart';
import 'package:zwap_test/res/colors/colors.dart';

class PrimaryLarge extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color? color;
  final bool loading;
  PrimaryLarge(
      {required this.text,
      required this.onPressed,
      this.color,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: loading ? AppColor.primaryDisabled : AppColor.primary,
        padding: EdgeInsets.symmetric(vertical: 18.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45.0),
        ),
      ),
      child: Container(
        width: double.infinity,
        child: Center(
          child: loading
              ? SizedBox(
                  width: 24.0, // Set the desired width
                  height: 24.0, // Set the desired height
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3.0, // Set the desired stroke width
                  ))
              : Text(
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
