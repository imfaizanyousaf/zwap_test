import 'package:flutter/material.dart';
import 'package:zwap_test/model/categories.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/utils/api.dart';

class CategoriesPage extends StatefulWidget {
  final List<String> initialSelectedItems;
  final bool returnCategories; // New parameter

  CategoriesPage({
    required this.initialSelectedItems,
    this.returnCategories = false, // Default value set to false
  });

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late Future<List<Categories>> _categoriesFuture;
  List<dynamic> selectedItems = []; // Changed to dynamic type

  @override
  void initState() {
    super.initState();
    _categoriesFuture = api().getCategories();

    if (widget.returnCategories) {
      setInitialCategories();
    } else {
      selectedItems = List.from(widget.initialSelectedItems);
    }
  }

  setInitialCategories() async {
    selectedItems = await _categoriesFuture.then(
      (value) => value
          .where(
              (category) => widget.initialSelectedItems.contains(category.name))
          .toList(),
    );
  }

  Future<bool?> _showExitDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Discard Selection?'),
          content: const Text(
              'Are you sure you want to exit without selecting any items?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes, Exit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: Text('Categories'),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            return;
          }
          bool shouldPop = true;
          if (selectedItems.isNotEmpty) {
            shouldPop = await _showExitDialog() ?? false;
          }
          if (context.mounted && shouldPop) {
            Navigator.pop(
              context,
              widget.returnCategories
                  ? (selectedItems.map((item) => item as Categories).toList())
                  : selectedItems.map((e) => e.toString()).toList(),
            );
          }
        },
        child: FutureBuilder<List<Categories>>(
          future: _categoriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              return SingleChildScrollView(
                child: Column(
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
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(childCategory.name!),
                                  value: selectedItems.contains(
                                    widget.returnCategories
                                        ? childCategory
                                        : childCategory.name,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value != null && value) {
                                        selectedItems.add(
                                          widget.returnCategories
                                              ? childCategory
                                              : childCategory.name!,
                                        );
                                      } else {
                                        selectedItems.remove(
                                          widget.returnCategories
                                              ? childCategory
                                              : childCategory.name,
                                        );
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
                          value: selectedItems.contains(
                            widget.returnCategories ? category : category.name,
                          ),
                          onChanged: (value) {
                            setState(() {
                              if (value != null && value) {
                                selectedItems.add(
                                  widget.returnCategories
                                      ? category
                                      : category.name!,
                                );
                              } else {
                                selectedItems.remove(
                                  widget.returnCategories
                                      ? category
                                      : category.name,
                                );
                              }
                            });
                          },
                        ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: selectedItems.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () async {
                // Adjusted the return value based on the returnCategories parameter
                Navigator.pop(
                  context,
                  widget.returnCategories
                      ? (selectedItems
                          .map((item) => item as Categories)
                          .toList())
                      : selectedItems.map((e) => e.toString()).toList(),
                );
              },
              child: Icon(Icons.check, color: AppColor.background),
              backgroundColor: AppColor.primary,
            ),
    );
  }

  bool _hasChildren(Categories category, List<Categories> categories) {
    return categories.any((child) => child.parentId == category.id);
  }
}
