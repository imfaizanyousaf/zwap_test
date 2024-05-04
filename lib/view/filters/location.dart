import 'package:flutter/material.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/components/locations_list.dart';

class LocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: Text('Select Location'),
      ),
      body: SingleChildScrollView(child: LocationsList()),
    );
  }
}
