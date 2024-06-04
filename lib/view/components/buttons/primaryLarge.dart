import 'package:flutter/material.dart';
import 'package:zwap_test/res/colors/colors.dart';

class PrimaryLarge extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color? color;
  final bool loading;
  final bool disabled;
  PrimaryLarge(
      {required this.text,
      required this.onPressed,
      this.color = AppColor.primary,
      this.loading = false,
      this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            (loading || disabled) ? AppColor.primaryDisabled : color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45.0),
        ),
      ),
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: loading
                ? SizedBox(
                    width: 24.0, // Set the desired width
                    height: 24.0, // Set the desired height
                    child: CircularProgressIndicator(
                      valueColor: color == AppColor.primary
                          ? AlwaysStoppedAnimation<Color>(Colors.white)
                          : AlwaysStoppedAnimation<Color>(AppColor.primary),
                      strokeWidth: 3.0, // Set the desired stroke width
                    ))
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 1.25,
                      color: (disabled)
                          ? const Color.fromARGB(86, 42, 42, 42)
                          : color == AppColor.primary
                              ? Colors.white
                              : AppColor.primary,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
