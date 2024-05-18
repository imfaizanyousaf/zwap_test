import 'package:flutter/material.dart';
import 'package:zwap_test/model/locations.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/utils/api.dart';

class LocationsPage extends StatefulWidget {
  final List<String> initialSelectedItems; // New parameter

  LocationsPage({required this.initialSelectedItems}); // Constructor

  @override
  _LocationsPageState createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  late Future<List<Locations>> _locationsFuture;
  List<String> selectedItems = [];

  @override
  void initState() {
    super.initState();
    _locationsFuture = api().getLocations();
    selectedItems = List.from(widget.initialSelectedItems);
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
              child: const Text('OK'),
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
        title: Text('Locations'),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            return;
          }
          final bool shouldPop = await _showExitDialog() ?? false;
          if (context.mounted && shouldPop) {
            Navigator.pop(context, selectedItems);
          }
        },
        child: FutureBuilder<List<Locations>>(
          future: _locationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    for (var location in snapshot.data!)
                      if (location.parentId == null &&
                          _hasChildren(location, snapshot.data!))
                        ExpansionTile(
                          title: Text(location.name!),
                          children: [
                            for (var childlocation in snapshot.data!)
                              if (childlocation.parentId == location.id)
                                CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(childlocation.name!),
                                  value: selectedItems
                                      .contains(childlocation.name),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value != null && value) {
                                        selectedItems.add(childlocation.name!);
                                      } else {
                                        selectedItems
                                            .remove(childlocation.name);
                                      }
                                    });
                                  },
                                ),
                          ],
                        )
                      else
                        CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(location.name!),
                          value: selectedItems.contains(location.name),
                          onChanged: (value) {
                            setState(() {
                              if (value != null && value) {
                                selectedItems.add(location.name!);
                              } else {
                                selectedItems.remove(location.name);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (selectedItems == null || selectedItems.isEmpty) {
            final bool? shouldPop = await _showExitDialog();
            if (shouldPop ?? false) {
              Navigator.of(context).pop(selectedItems);
            }
          } else {
            Navigator.pop(context, selectedItems);
          }
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Helper function to check if a location has children
  bool _hasChildren(Locations location, List<Locations> locations) {
    return locations.any((child) => child.parentId == location.id);
  }
}
