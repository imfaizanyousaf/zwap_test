import 'package:flutter/material.dart';

class SortFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sort & Filter'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Sort by Name'),
            onTap: () {
              // Add your logic here
            },
          ),
        ],
      ),
    );
  }
}
