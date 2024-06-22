import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/model/user.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/components/buttons/primaryLarge.dart';
import 'package:zwap_test/view/components/health_badge.dart';
import 'package:zwap_test/view/filters/categories.dart';
import 'package:zwap_test/view/filters/item_condition.dart';
import 'package:zwap_test/view/filters/locations.dart';

import '../../utils/api.dart';

class SortFilter extends StatefulWidget {
  var initialFilters;
  SortFilter({required this.initialFilters}); // Constructor

  @override
  State<SortFilter> createState() => _SortFilterState();
}

class _SortFilterState extends State<SortFilter> {
  bool isRecent = false;
  bool isRelevant = false;
  List<String> selectedCategories = [];
  List<String> selectedLocations = [];
  List<String> selectedConditions = [];

  initState() {
    super.initState();
    selectedCategories = (widget.initialFilters['categories'] as List)
        .map((category) => category.toString())
        .toList();
    selectedLocations = (widget.initialFilters['locations'] as List)
        .map((location) => location.toString())
        .toList();
    selectedConditions = (widget.initialFilters['conditions'] as List)
        .map((condition) => condition.toString())
        .toList();
    isRecent = widget.initialFilters['isRecent'] as bool;
    isRelevant = widget.initialFilters['isRelevant'] as bool;
  }

  Future<bool?> _showExitDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Exit'),
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
        appBar: AppBar(
          title: Text('Sort & Filter'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.restart_alt,
                color: AppColor.secondary,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Clear Filters'),
                      content:
                          Text('Are you sure you want to clear all filters?'),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Confirm'),
                          onPressed: () {
                            setState(() {
                              selectedCategories = [];
                              selectedLocations = [];
                              selectedConditions = [];
                              isRecent = false;
                              isRelevant = false;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) async {
            if (didPop) {
              return;
            }
            final bool shouldPop = await _showExitDialog() ?? false;
            if (context.mounted && shouldPop) {
              Navigator.pop(context, {
                'categories': selectedCategories,
                'locations': selectedLocations,
                'conditions': selectedConditions,
                'isRecent': isRecent,
                'isRelevant': isRelevant,
              });
            }
          },
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                child: Text(
                  "Categories",
                  style:
                      GoogleFonts.manrope(fontSize: 14, color: Colors.black54),
                ),
              ),
              ListTile(
                title: selectedCategories.isEmpty
                    ? Text('Select Category')
                    : Text(
                        selectedCategories
                            .toString()
                            .replaceAll('[', '')
                            .replaceAll(']', ''),
                        style: GoogleFonts.manrope(
                            fontSize: 16, color: Colors.black)),
                trailing: Icon(Icons.arrow_right),
                onTap: () async {
                  // Perform asynchronous work
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoriesPage(
                        initialSelectedItems: selectedCategories,
                      ),
                    ),
                  );

                  // Update the state after the asynchronous work is done
                  setState(() {
                    selectedCategories = result;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                child: Text(
                  "Location",
                  style:
                      GoogleFonts.manrope(fontSize: 14, color: Colors.black54),
                ),
              ),
              ListTile(
                leading: Icon(Icons.location_on_outlined),
                title: selectedLocations.isEmpty
                    ? Text('Select Location')
                    : Text(selectedLocations
                        .toString()
                        .replaceAll('[', '')
                        .replaceAll(']', '')),
                trailing: Icon(Icons.arrow_right),
                onTap: () async {
                  User currentUser = await api().getUser(null);
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocationsPage(
                        currentUser: currentUser,
                        initialSelectedItems: selectedLocations,
                      ),
                    ),
                  );

                  // Update the state after the asynchronous work is done
                  setState(() {
                    selectedLocations = result;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                child: Text(
                  "Item Condition",
                  style:
                      GoogleFonts.manrope(fontSize: 14, color: Colors.black54),
                ),
              ),
              ListTile(
                title: selectedConditions.isEmpty
                    ? Text('Select Condition')
                    : Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 4.0, // gap between adjacent items
                              runSpacing: 4.0, // gap between lines
                              children: selectedConditions.map((condition) {
                                return HealthBadge(condition: condition);
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                trailing: Icon(Icons.arrow_right),
                onTap: () async {
                  // Perform asynchronous work
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ItemCondition(
                              initialSelectedItems: selectedConditions,
                              showAsChecklist: true,
                            )),
                  );

                  // Update the state after the asynchronous work is done
                  setState(() {
                    selectedConditions = result;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                child: Text(
                  "Sort by",
                  style:
                      GoogleFonts.manrope(fontSize: 14, color: Colors.black54),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Wrap(
                  spacing: 8,
                  children: <Widget>[
                    FilterChip(
                      onSelected: (isSelected) {
                        setState(() {
                          isRecent = isSelected;
                        });
                      },
                      checkmarkColor: Colors.white,
                      selected: isRecent,
                      selectedColor: AppColor.secondary,
                      side: BorderSide(
                        color:
                            isRecent ? AppColor.secondary : Color(0xff5c5c5c),
                      ),
                      label: Text(
                        'Most Recent',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          color: isRecent ? Colors.white : Color(0xff5c5c5c),
                        ),
                      ),
                    ),
                    FilterChip(
                      onSelected: (isSelected) {
                        setState(() {
                          isRelevant = isSelected;
                        });
                      },
                      checkmarkColor: Colors.white,
                      selected: isRelevant,
                      selectedColor: AppColor.secondary,
                      side: BorderSide(
                        color:
                            isRelevant ? AppColor.secondary : Color(0xff5c5c5c),
                      ),
                      label: Text(
                        'Most Relevant',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          color: isRelevant ? Colors.white : Color(0xff5c5c5c),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: PrimaryLarge(
              text: 'Apply Filters',
              onPressed: () {
                Navigator.pop(context, {
                  'categories': selectedCategories,
                  'locations': selectedLocations,
                  'conditions': selectedConditions,
                  'isRecent': isRecent,
                  'isRelevant': isRelevant,
                });
              },
            ),
          ),
        ]);
  }
}
