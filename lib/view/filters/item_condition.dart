import 'package:flutter/material.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/components/conditions_list.dart';

class ItemCondition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          backgroundColor: AppColor.background,
          title: Text('Categories'),
        ),
        body: SingleChildScrollView(child: ConditionsList()));
  }
}
