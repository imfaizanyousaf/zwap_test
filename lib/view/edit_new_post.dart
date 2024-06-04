// This screen is used to edit a new post

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/global/commons/toast.dart';
import 'package:zwap_test/model/categories.dart';
import 'package:zwap_test/model/conditions.dart';
import 'package:zwap_test/model/locations.dart';
import 'package:zwap_test/model/post.dart';
import 'package:zwap_test/model/user.dart';
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
  final List<String> images = [
    'https://picsum.photos/856/600',
    'https://picsum.photos/856/600',
    'https://picsum.photos/856/600',
    'https://picsum.photos/856/600',
    'https://picsum.photos/856/600',
  ];

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
                  itemCount: images.length +
                      1, // Add 1 for the "Add More Images" container
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      // Always display "Add More Images" container as the first item
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          width: 100.0,
                          height: 200.0,
                          color: Colors.grey[300],
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 40.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      );
                    } else {
                      // Display images in a horizontal list
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: AspectRatio(
                          aspectRatio: 1.0, // Maintain a square aspect ratio
                          child: Image.network(
                            images[index -
                                1], // Adjust index to account for the "Add More Images" container
                            fit: BoxFit.cover,
                          ),
                        ),
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
                        labelText: 'Description',
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
                        // Perform asynchronous work
                        List<Locations> result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationsPage(
                              initialSelectedItems: selectedLocations.isEmpty
                                  ? []
                                  : selectedLocations
                                      .map((e) => e.name!)
                                      .toList(),
                              returnLocations: true,
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
                    categories: selectedCategories);
                String response = await _api.addPost(newPost);
                if (response == '200') {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Post Created Successfully'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Done'),
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
                  message: "Please provide all the deatils",
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
