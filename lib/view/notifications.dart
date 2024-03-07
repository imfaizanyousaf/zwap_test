import 'package:flutter/material.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/components/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        surfaceTintColor: AppColor.background,
        backgroundColor: AppColor.background,
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with your actual number of notifications
        itemBuilder: (context, index) {
          return NotificationCard(
            title: 'Notification Title ${index + 1}',
            message: 'This is a sample notification message.',
            time: '2hrs', // Replace with actual time
          );
        },
      ),
    );
  }
}
