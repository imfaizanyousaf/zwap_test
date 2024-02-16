import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Perform search action
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Perform filter action
            },
          ),
        ],
      ),
      body: Center(
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Enter search query',
          ),
        ),
      ),
    );
  }
}
