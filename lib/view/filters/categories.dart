import 'package:flutter/material.dart';
import 'package:zwap_test/model/categories.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/view/components/categories_list.dart';

class CategoriesPage extends StatelessWidget {
  final Future<List<Categories>> categories = api().getCategories();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          backgroundColor: AppColor.background,
          title: Text('Categories'),
        ),
        body: SingleChildScrollView(child: CategoriesList()));
  }
}
