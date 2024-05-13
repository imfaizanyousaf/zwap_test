import 'package:flutter/material.dart';
import 'package:zwap_test/res/colors/colors.dart';

class InterestCard extends StatelessWidget {
  final Text text;

  InterestCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: text,
      backgroundColor: AppColor.background,
      onSelected: (bool value) {},
    );
  }
}
