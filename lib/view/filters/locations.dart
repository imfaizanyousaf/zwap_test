import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zwap_test/global/commons/toast.dart';
import 'package:zwap_test/model/locations.dart';
import 'package:zwap_test/model/user.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:geocoding/geocoding.dart';
import 'package:zwap_test/view/location_picker.dart';

class LocationsPage extends StatefulWidget {
  final List<dynamic> initialSelectedItems; // New parameter
  final bool returnLocations; // New parameter
  final currentUser;

  LocationsPage({
    required this.initialSelectedItems,
    required this.currentUser,
    this.returnLocations = false, // Default value set to false
  }); // Constructor

  @override
  _LocationsPageState createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  late Future<List<Locations>> _locationsFuture;
  List<dynamic> selectedItems = [];
  dynamic selectedItem;
  Locations? selectedLocation;
  late Future<List<Locations>> _userLocations;
  void setInitialLocations() async {
    selectedItems = widget.initialSelectedItems;
    if (selectedItems.length > 0) {
      selectedLocation = selectedItems.firstOrNull;
      selectedItem = selectedLocation;
    }
    // selectedItems = await _locationsFuture.then(
    //   (value) => value
    //       .where(
    //           (location) => widget.initialSelectedItems.contains(location.name))
    //       .toList(),
    // );
  }

  @override
  void initState() {
    super.initState();
    _userLocations = api().getUserLocations(widget.currentUser.id);
    _locationsFuture = api().getLocations();
    if (widget.returnLocations) {
      setInitialLocations();
    } else {
      selectedItems = List.from(widget.initialSelectedItems);
    }
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
            Navigator.pop(context);
            // Navigator.pop(
            //   context,
            //   widget.returnLocations
            //       ? (selectedItems.map((item) => item as Locations).toList())
            //       : selectedItems.map((e) => e.toString()).toList(),
            // );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.map),
                  title: selectedItems == [] ||
                          selectedItems.isEmpty ||
                          selectedItems == null ||
                          selectedLocation == null
                      ? Text(
                          "Select on Map",
                        )
                      : Text(selectedLocation!.name),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () async {
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocationPickerScreen(
                          initialLocation: selectedLocation == null
                              ? null
                              : LatLng(double.parse(selectedLocation!.lat),
                                  double.parse(selectedLocation!.lng)),
                        ),
                      ),
                    );

                    if (result != null) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              content: Container(
                            height: 100,
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: AppColor.primary,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          ));
                        },
                      );
                      List<Placemark> placemark =
                          await placemarkFromCoordinates(
                        result.latitude,
                        result.longitude,
                      );
                      if (placemark != null) {
                        api _api = api();

                        List<Locations> savedLocations = await _api
                            .searchLocation(placemark[3].name.toString());
                        if (savedLocations == [] ||
                            savedLocations.isEmpty ||
                            savedLocations == null) {
                          savedLocations = await _api
                              .searchLocation(placemark[3].locality.toString());
                          if (savedLocations == [] ||
                              savedLocations.isEmpty ||
                              savedLocations == null) {
                            savedLocations = await _api.searchLocation(
                                placemark[3].subAdministrativeArea.toString());
                            if (savedLocations == [] ||
                                savedLocations.isEmpty ||
                                savedLocations == null) {
                              savedLocations = await _api.searchLocation(
                                  placemark[3].administrativeArea.toString());
                            }
                          }
                        }
                        setState(() {
                          selectedItems = savedLocations;
                          if (savedLocations.length > 0) {
                            selectedLocation = savedLocations[0];
                          }
                        });
                        Navigator.pop(context);
                        showAboutDialog(
                          context: context,
                          applicationName: "Location",
                          applicationVersion: jsonEncode(savedLocations) +
                              "${selectedLocation.toString()}",
                        );
                      }
                    }
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(
                  "My Meeting Venues",
                  textAlign: TextAlign.left,
                  style:
                      GoogleFonts.manrope(fontSize: 14, color: Colors.black54),
                ),
              ),
              FutureBuilder<List<Locations>>(
                future: _userLocations,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (snapshot.data == [] ||
                      snapshot.data == null ||
                      snapshot.data!.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          "No Meeting Venues Set!",
                        ),
                      ),
                    );
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
                                        for (var childLocation
                                            in snapshot.data!)
                                          if (childLocation.parentId ==
                                              location.id)
                                            RadioListTile(
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              title: Text(childLocation.name),
                                              value: widget.returnLocations
                                                  ? childLocation
                                                  : childLocation.name,
                                              groupValue: selectedItem,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedItem = value;
                                                  selectedItems.clear();
                                                  selectedItems
                                                      .add(selectedItem);
                                                  selectedLocation =
                                                      selectedItem;
                                                });
                                              },
                                            ),
                                      ],
                                    )
                                  : RadioListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text(location.name),
                                      value: widget.returnLocations
                                          ? location
                                          : location.name,
                                      groupValue: selectedItem,
                                      onChanged: (value) {
                                        print('RADIO VALUE: $value');

                                        setState(() {
                                          selectedItem = value;
                                          selectedItems.clear();
                                          selectedItems.add(selectedItem);
                                          selectedLocation = selectedItem;
                                        });
                                      },
                                    )
                            else if (!_hasParent(location, snapshot.data!))
                              RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text(location.name),
                                value: widget.returnLocations
                                    ? location
                                    : location.name,
                                groupValue: selectedItem,
                                onChanged: (value) {
                                  setState(() {
                                    selectedItem = value;
                                    selectedItems.clear();
                                    selectedItems.add(selectedItem);
                                  });
                                },
                              ),
                        ],
                      ),
                    );
                  }
                },
              )

              // ALL LOCATIONS
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              //   child: Text(
              //     "All Locations",
              //     textAlign: TextAlign.left,
              //     style:
              //         GoogleFonts.manrope(fontSize: 14, color: Colors.black54),
              //   ),
              // ),
              // FutureBuilder<List<Locations>>(
              //   future: _locationsFuture,
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return Center(child: CircularProgressIndicator());
              //     } else if (snapshot.hasError) {
              //       return Center(child: Text("Error: ${snapshot.error}"));
              //     } else {
              //       return SingleChildScrollView(
              //         child: Column(
              //           children: [
              //             for (var location in snapshot.data!)
              //               if (location.parentId == null)
              //                 _hasChildren(location, snapshot.data!)
              //                     ? ExpansionTile(
              //                         title: Text(location.name),
              //                         children: [
              //                           for (var childLocation
              //                               in snapshot.data!)
              //                             if (childLocation.parentId ==
              //                                 location.id)
              //                               CheckboxListTile(
              //                                 controlAffinity:
              //                                     ListTileControlAffinity
              //                                         .leading,
              //                                 title: Text(childLocation.name),
              //                                 value: selectedItems.contains(
              //                                   widget.returnLocations
              //                                       ? childLocation
              //                                       : childLocation.name,
              //                                 ),
              //                                 onChanged: (value) {
              //                                   setState(() {
              //                                     if (value != null && value) {
              //                                       selectedItems.add(
              //                                         widget.returnLocations
              //                                             ? childLocation
              //                                             : childLocation.name,
              //                                       );
              //                                     } else {
              //                                       selectedItems.remove(
              //                                         widget.returnLocations
              //                                             ? childLocation
              //                                             : childLocation.name,
              //                                       );
              //                                     }
              //                                   });
              //                                 },
              //                               ),
              //                         ],
              //                       )
              //                     : CheckboxListTile(
              //                         controlAffinity:
              //                             ListTileControlAffinity.leading,
              //                         title: Text(location.name),
              //                         value: selectedItems.contains(
              //                           widget.returnLocations
              //                               ? location
              //                               : location.name,
              //                         ),
              //                         onChanged: (value) {
              //                           setState(() {
              //                             if (value != null && value) {
              //                               selectedItems.add(
              //                                 widget.returnLocations
              //                                     ? location
              //                                     : location.name,
              //                               );
              //                             } else {
              //                               selectedItems.remove(
              //                                 widget.returnLocations
              //                                     ? location
              //                                     : location.name,
              //                               );
              //                             }
              //                           });
              //                         },
              //                       )
              //               else if (!_hasParent(location, snapshot.data!))
              //                 CheckboxListTile(
              //                   controlAffinity:
              //                       ListTileControlAffinity.leading,
              //                   title: Text(location.name),
              //                   value: selectedItems.contains(
              //                     widget.returnLocations
              //                         ? location
              //                         : location.name,
              //                   ),
              //                   onChanged: (value) {
              //                     setState(() {
              //                       if (value != null && value) {
              //                         selectedItems.add(
              //                           widget.returnLocations
              //                               ? location
              //                               : location.name,
              //                         );
              //                       } else {
              //                         selectedItems.remove(
              //                           widget.returnLocations
              //                               ? location
              //                               : location.name,
              //                         );
              //                       }
              //                     });
              //                   },
              //                 ),
              //           ],
              //         ),
              //       );
              //     }
              //   },
              // ),
            ],
          ),
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
