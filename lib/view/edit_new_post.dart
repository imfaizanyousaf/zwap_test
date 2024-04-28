// This screen is used to edit a new post

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/res/health.dart';
import 'package:zwap_test/view/components/buttons/primaryLarge.dart';
import 'package:zwap_test/view/components/health_badge.dart';
import 'package:zwap_test/view/filters/categories.dart';
import 'package:zwap_test/view/filters/item_condition.dart';
import 'package:zwap_test/view/filters/location.dart';

class EditNewPostScreen extends StatelessWidget {
  final List<String> images = [
    'https://picsum.photos/856/600',
    'https://picsum.photos/856/600',
    'https://picsum.photos/856/600',
    'https://picsum.photos/856/600',
    'https://picsum.photos/856/600',
  ];
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
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      maxLines:
                          null, // Set maxLines to null for unlimited lines
                      textInputAction: TextInputAction.newline,
                    ),
                    TextField(
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
                      title: Text('Electronics and 2 more',
                          style: GoogleFonts.manrope(
                              fontSize: 16, color: Colors.black)),
                      trailing: Icon(Icons.arrow_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoriesPage()),
                        );
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
                      title: Text('Rawalpindi, Pakistan',
                          style: GoogleFonts.manrope(
                              fontSize: 16, color: Colors.black)),
                      trailing: Icon(Icons.arrow_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LocationPage()),
                        );
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
                      title: Row(
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: HealthBadge(
                                condition: Health.GOOD,
                              )),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ItemCondition()),
                        );
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
            onPressed: () {
              // Add your logic here
            },
          ),
        ),
      ],
    );
  }
}
