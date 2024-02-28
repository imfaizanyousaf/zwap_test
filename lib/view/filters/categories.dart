import 'package:flutter/material.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/components/custom_list.dart';

class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.background,
          title: Text('Categories'),
        ),
        body: CustomList(items: categories));
  }
}

List<String> categories = [
  'Electronics',
  'Laptop',
  'Washing Machine',
  'Mobile',
  'Tablet',
  'Desktop',
  'Camera',
  // Add more categories here
];
