import 'package:flutter/material.dart';
import 'package:zwap_test/model/locations.dart';
import 'package:zwap_test/utils/api.dart';

class LocationsList extends StatefulWidget {
  @override
  _LocationsListState createState() => _LocationsListState();
}

class _LocationsListState extends State<LocationsList> {
  late Future<List<Locations>> _locationsFuture;
  List<Locations> selectedItems = [];

  @override
  void initState() {
    super.initState();
    _locationsFuture = api().getLocations();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Locations>>(
      future: _locationsFuture,
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
                    title: Text(category.name),
                    children: [
                      for (var childCategory in snapshot.data!)
                        if (childCategory.parentId == category.id)
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(childCategory.name),
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
                    title: Text(category.name),
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

  // Helper function to check if a location has children
  bool _hasChildren(Locations location, List<Locations> locations) {
    return locations.any((child) => child.parentId == location.id);
  }
}
