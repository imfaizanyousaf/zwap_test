import 'package:flutter/material.dart';
import 'package:zwap_test/res/colors/colors.dart';

class InterestCard extends StatelessWidget {
  final Text icon;
  final Text text;

  InterestCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: text,
      avatar: icon,
      backgroundColor: AppColor.background,
      onSelected: (bool value) {},
    );
  }
}
