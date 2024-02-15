import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://placekitten.com/200/200'), // Replace with your image URL
                        ),
                        SizedBox(width: 8.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Username'),
                            Text(
                              'Location Name',
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    onPressed: () {
                      // Handle more options button press
                    },
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                'https://placekitten.com/640/360', // Replace with your image URL
                fit: BoxFit.cover,
              ),
            ),
            Chip(
              label: Text('Like New'),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Text(
                'Sonic Black Headset',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Icon(Icons.autorenew),
                SizedBox(width: 8.0),
                Text('Office Desk, Desk Frame, Office Chair'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
