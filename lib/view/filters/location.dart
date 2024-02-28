import 'package:flutter/material.dart';

class LocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(categories[index]),
            value: false,
            onChanged: (value) {},
            controlAffinity: ListTileControlAffinity.leading,
          );
        },
      ),
    );
  }
}

List<String> categories = [
  'Location 1',
  'Location 2',
  'Location 3',
  // Add more categories here
];
