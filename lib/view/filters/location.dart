import 'package:flutter/material.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/components/custom_list.dart';

class LocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: Text('Select Location'),
      ),
      body: CustomList(items: locations),
    );
  }
}

List<String> locations = [
  'Location 1',
  'Location 2',
  'Location 3',
  // Add more categories here
];
