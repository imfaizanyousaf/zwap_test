import 'package:flutter/material.dart';
import 'package:zwap_test/model/locations.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/utils/api.dart';

class LocationsPage extends StatefulWidget {
  final List<String> initialSelectedItems; // New parameter
  final bool returnLocations; // New parameter

  LocationsPage({
    required this.initialSelectedItems,
    this.returnLocations = false, // Default value set to false
  }); // Constructor

  @override
  _LocationsPageState createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  late Future<List<Locations>> _locationsFuture;
  List<dynamic> selectedItems = [];

  @override
  void initState() {
    super.initState();
    _locationsFuture = api().getLocations();
    if (widget.returnLocations) {
      setInitialLocations();
    } else {
      selectedItems = List.from(widget.initialSelectedItems);
    }
  }

  setInitialLocations() async {
    selectedItems = await _locationsFuture.then(
      (value) => value
          .where(
              (location) => widget.initialSelectedItems.contains(location.name))
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
          bool shouldPop = true;
          if (selectedItems.isNotEmpty) {
            shouldPop = await _showExitDialog() ?? false;
          }
          if (context.mounted && shouldPop) {
            Navigator.pop(
              context,
              widget.returnLocations
                  ? (selectedItems.map((item) => item as Locations).toList())
                  : selectedItems.map((e) => e.toString()).toList(),
            );
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
                      if (location.parentId == null)
                        _hasChildren(location, snapshot.data!)
                            ? ExpansionTile(
                                title: Text(location.name),
                                children: [
                                  for (var childLocation in snapshot.data!)
                                    if (childLocation.parentId == location.id)
                                      CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        title: Text(childLocation.name),
                                        value: selectedItems.contains(
                                          widget.returnLocations
                                              ? childLocation
                                              : childLocation.name,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            if (value != null && value) {
                                              selectedItems.add(
                                                widget.returnLocations
                                                    ? childLocation
                                                    : childLocation.name,
                                              );
                                            } else {
                                              selectedItems.remove(
                                                widget.returnLocations
                                                    ? childLocation
                                                    : childLocation.name,
                                              );
                                            }
                                          });
                                        },
                                      ),
                                ],
                              )
                            : CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text(location.name),
                                value: selectedItems.contains(
                                  widget.returnLocations
                                      ? location
                                      : location.name,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null && value) {
                                      selectedItems.add(
                                        widget.returnLocations
                                            ? location
                                            : location.name,
                                      );
                                    } else {
                                      selectedItems.remove(
                                        widget.returnLocations
                                            ? location
                                            : location.name,
                                      );
                                    }
                                  });
                                },
                              )
                      else if (!_hasParent(location, snapshot.data!))
                        CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(location.name),
                          value: selectedItems.contains(
                            widget.returnLocations ? location : location.name,
                          ),
                          onChanged: (value) {
                            setState(() {
                              if (value != null && value) {
                                selectedItems.add(
                                  widget.returnLocations
                                      ? location
                                      : location.name,
                                );
                              } else {
                                selectedItems.remove(
                                  widget.returnLocations
                                      ? location
                                      : location.name,
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
      floatingActionButton: selectedItems.isNotEmpty
          ? FloatingActionButton(
              onPressed: () async {
                Navigator.pop(
                  context,
                  widget.returnLocations
                      ? (selectedItems
                          .map((item) => item as Locations)
                          .toList())
                      : selectedItems.map((e) => e.toString()).toList(),
                );
              },
              child: Icon(Icons.check, color: AppColor.background),
              backgroundColor: AppColor.primary,
            )
          : null,
    );
  }

  // Helper function to check if a location has children

  bool _hasParent(location, List<Locations> allLocations) {
    return allLocations.any((loc) => loc.id == location.parentId);
  }

  bool _hasChildren(location, List<Locations> allLocations) {
    return allLocations.any((loc) => loc.parentId == location.id);
  }
}
