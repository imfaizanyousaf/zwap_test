import 'package:flutter/material.dart';
import 'package:zwap_test/model/categories.dart';
import 'package:zwap_test/utils/api.dart';

class CategoriesList extends StatefulWidget {
  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  late Future<List<Categories>> _categoriesFuture;
  List<Categories> selectedItems = [];

  @override
  void initState() {
    super.initState();
    _categoriesFuture = api().getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Categories>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          return Column(
            children: [
              for (var category in snapshot.data!)
                if (category.parentId == null &&
                    _hasChildren(category, snapshot.data!))
                  ExpansionTile(
                    title: Text(category.name!),
                    children: [
                      for (var childCategory in snapshot.data!)
                        if (childCategory.parentId == category.id)
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(childCategory.name!),
                            value: selectedItems.contains(childCategory),
                            onChanged: (value) {
                              setState(() {
                                if (value != null && value) {
                                  selectedItems.add(childCategory);
                                } else {
                                  selectedItems.remove(childCategory);
                                }
                              });
                            },
                          ),
                    ],
                  )
                else
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(category.name!),
                    value: selectedItems.contains(category),
                    onChanged: (value) {
                      setState(() {
                        if (value != null && value) {
                          selectedItems.add(category);
                        } else {
                          selectedItems.remove(category);
                        }
                      });
                    },
                  ),
            ],
          );
        }
      },
    );
  }

  // Helper function to check if a category has children
  bool _hasChildren(Categories category, List<Categories> categories) {
    return categories.any((child) => child.parentId == category.id);
  }
}
