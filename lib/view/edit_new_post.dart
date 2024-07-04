import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zwap_test/global/commons/toast.dart';
import 'package:zwap_test/model/categories.dart';
import 'package:zwap_test/model/conditions.dart';
import 'package:zwap_test/model/locations.dart';
import 'package:zwap_test/model/post.dart';
import 'package:zwap_test/model/user.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/view/components/buttons/primaryLarge.dart';
import 'package:zwap_test/view/components/health_badge.dart';
import 'package:zwap_test/view/filters/categories.dart';
import 'package:zwap_test/view/filters/item_condition.dart';
import 'package:zwap_test/view/filters/locations.dart';

class EditNewPostScreen extends StatefulWidget {
  final User currentUser;
  EditNewPostScreen({required this.currentUser});
  @override
  State<EditNewPostScreen> createState() => _EditNewPostScreenState();
}

class _EditNewPostScreenState extends State<EditNewPostScreen> {
  api _api = api();
  final List<String> images = [];
  List<File>? _images = [];
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.pickMultiImage();
    setState(() {
      if (pickedFile != null) {
        _images!.addAll(pickedFile.map((e) => File(e.path)).toList());
        images.addAll(pickedFile.map((e) => e.path).toList());
      } else {
        print('No image selected.');
      }
    });
  }

  List<Categories> selectedCategories = [];
  List<Locations> selectedLocations = [];
  List<Conditions> selectedConditions = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'New Post',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16),
          // row of horizontally scrollable images
          child: Column(
            children: [
              Container(
                height: 200.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images!.length +
                      1, // Add 1 for the "Add More Images" container
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      // Always display "Add More Images" container as the first item
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () {
                            // open image picker
                            getImage();
                          },
                          child: Container(
                            width: 100.0,
                            height: 200.0,
                            color: AppColor.lightBlue,
                            child: Center(
                              child: Icon(
                                Icons.add,
                                size: 40.0,
                                color: AppColor.primary,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      // Display images in a horizontal list with a delete button
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: AspectRatio(
                              aspectRatio:
                                  1.0, // Maintain a square aspect ratio
                              child: Image.file(
                                _images![index - 1],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _images!.removeAt(index - 1);
                                    images.removeAt(index - 1);
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(
                                    shadows: [
                                      Shadow(
                                          color: Colors.black, blurRadius: 20)
                                    ],
                                    Icons.delete_outline_outlined,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      maxLines:
                          null, // Set maxLines to null for unlimited lines
                      textInputAction: TextInputAction.newline,
                    ),
                    TextField(
                      inputFormatters: [LengthLimitingTextInputFormatter(200)],
                      maxLines: null,
                      controller: descController,
                      decoration: InputDecoration(
                        labelText: 'Exchange With',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        "Categories",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.manrope(
                            fontSize: 14, color: Colors.black54),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: selectedCategories.isEmpty
                          ? Text('Select Category')
                          : Text(
                              overflow: TextOverflow.fade,
                              selectedCategories.map((e) => e.name).join(', '),
                              style: GoogleFonts.manrope(
                                  fontSize: 16, color: Colors.black)),
                      trailing: Icon(Icons.arrow_right),
                      onTap: () async {
                        // Perform asynchronous work
                        List<Categories> result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoriesPage(
                              initialSelectedItems: selectedCategories.isEmpty
                                  ? []
                                  : selectedCategories
                                      .map((e) => e.name!)
                                      .toList(),
                              returnCategories: true,
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
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        "Meeting Venue",
                        style: GoogleFonts.manrope(
                            fontSize: 14, color: Colors.black54),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.location_on_outlined),
                      title: selectedLocations.isEmpty
                          ? Text('Select Location')
                          : Text(
                              overflow: TextOverflow.fade,
                              selectedLocations.map((e) => e.name).join(', '),
                              style: GoogleFonts.manrope(
                                  fontSize: 16, color: Colors.black)),
                      trailing: Icon(Icons.arrow_right),
                      onTap: () async {
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
                        User currentUser = await api().getUser(null);
                        Navigator.pop(context);
                        List<Locations>? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationsPage(
                              currentUser: currentUser,
                              initialSelectedItems: selectedLocations.isEmpty
                                  ? []
                                  : selectedLocations,
                              returnLocations: true,
                            ),
                          ),
                        );

                        // Update the state after the asynchronous work is done
                        if (result != null) {
                          setState(() {
                            selectedLocations = result;
                          });
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        "Item Condition",
                        style: GoogleFonts.manrope(
                            fontSize: 14, color: Colors.black54),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: selectedConditions.isEmpty
                          ? Text('Select Condition')
                          : Row(
                              children: [
                                Expanded(
                                  child: Wrap(
                                    spacing: 4.0, // gap between adjacent items
                                    runSpacing: 4.0, // gap between lines
                                    children:
                                        selectedConditions.map((condition) {
                                      return HealthBadge(
                                          condition: condition.name);
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
                                    initialSelectedItems:
                                        selectedConditions.isEmpty
                                            ? []
                                            : selectedConditions
                                                .map((e) => e.name)
                                                .toList(),
                                    returnConditions: true,
                                  )),
                        );

                        // Update the state after the asynchronous work is done
                        setState(() {
                          selectedConditions = result;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: PrimaryLarge(
            text: 'Post',
            onPressed: () async {
              if (titleController.text.isNotEmpty &&
                  descController.text.isNotEmpty &&
                  selectedCategories.isNotEmpty &&
                  selectedLocations.isNotEmpty &&
                  selectedConditions.isNotEmpty) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 16),
                            Text("Posting..."),
                          ],
                        ),
                      ),
                    );
                  },
                );
                Post newPost = Post(
                  title: titleController.text,
                  description: descController.text,
                  userId: widget.currentUser.id,
                  conditionId: selectedConditions[0].id,
                  publishedAt: DateTime.now(),
                  published: true,
                  user: widget.currentUser,
                  condition: selectedConditions[0],
                  locations: selectedLocations,
                  lat: selectedLocations[0].lat,
                  lng: selectedLocations[0].lng,
                  categories: selectedCategories,
                  images: images,
                );
                String response = await _api.addPost(newPost);
                Navigator.pop(context);
                if (response == '200') {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        icon: Icon(Icons.check_circle,
                            color: Colors.green, size: 48),
                        title: Column(
                          children: [
                            Text("Post Created!"),
                            Text(
                              "Shabash mery sher!",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showToast(message: 'Failed to create post $response');
                }
              } else {
                showToast(
                  message: "Please provide all the details",
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
