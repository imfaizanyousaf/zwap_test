import 'package:flutter/material.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/components/custom_list.dart';

class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          backgroundColor: AppColor.background,
          title: Text('Categories'),
        ),
        body: CustomList(items: categories));
  }
}

List<String> categories = [
  'Electronics',
  'Mobile Phones',
  'Laptops',
  'Tablets',
  'Cameras',
  'Televisions',
  'Headphones',
  'Speakers',
  'Smart Watches',
  'Printers',
  'Accessories'
];
