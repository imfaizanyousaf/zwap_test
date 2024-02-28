import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/res/health.dart';

class HealthBadge extends StatelessWidget {
  final Health condition;

  HealthBadge({required this.condition});

  @override
  Widget build(BuildContext context) {
    String conditionText = '';
    Color badgeColor = Colors.transparent;

    switch (condition) {
      case Health.NEW:
        conditionText = 'NEW';
        badgeColor =
            Color.fromARGB(255, 158, 241, 193); // Set your color for NEW
        break;
      case Health.LIKE_NEW:
        conditionText = 'LIKE NEW';
        badgeColor =
            Color.fromARGB(255, 171, 240, 255); // Set your color for LIKE NEW
        break;
      case Health.GOOD:
        conditionText = 'GOOD';
        badgeColor =
            Color.fromARGB(255, 228, 213, 248); // Set your color for GOOD
        break;
      case Health.FAIR:
        conditionText = 'FAIR';
        badgeColor =
            Color.fromARGB(255, 254, 227, 186); // Set your color for FAIR
        break;
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
