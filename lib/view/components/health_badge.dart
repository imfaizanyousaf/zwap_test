import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/model/conditions.dart';

class HealthBadge extends StatelessWidget {
  final String condition;

  HealthBadge({required this.condition});

  @override
  Widget build(BuildContext context) {
    String conditionText = '';
    Color badgeColor = Colors.transparent;

    if (condition == 'New') {
      conditionText = 'NEW';
      badgeColor = Color.fromARGB(255, 158, 241, 193); // Set your color for NEW
    } else if (condition == 'Like New') {
      conditionText = 'LIKE NEW';
      badgeColor =
          Color.fromARGB(255, 171, 240, 255); // Set your color for LIKE NEW
    } else if (condition == 'Good') {
      conditionText = 'GOOD';
      badgeColor =
          Color.fromARGB(255, 228, 213, 248); // Set your color for GOOD
    } else if (condition == 'Fair') {
      conditionText = 'FAIR';
      badgeColor =
          Color.fromARGB(255, 254, 227, 186); // Set your color for FAIR
    }

    double textWidth = conditionText.length * 8.0;
    return Container(
      width: textWidth + 8,
      height: 17,
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        conditionText,
        style: GoogleFonts.manrope(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
