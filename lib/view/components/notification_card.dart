import 'package:flutter/material.dart';
import 'package:zwap_test/res/colors/colors.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String time;

  NotificationCard(
      {required this.title, required this.message, required this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(message),
        trailing: Text(
          time,
          style: TextStyle(color: Colors.grey),
        ),
        onTap: () {
          // Add your notification click handling logic here
        },
      ),
    );
  }
}
