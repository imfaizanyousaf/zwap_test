import 'package:flutter/material.dart';
import 'package:zwap_test/view/components/buttons/primaryLarge.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            CircleAvatar(
                radius: 50, backgroundImage: AssetImage("assets/avatar.jpg")),

            TextField(
              decoration: InputDecoration(
                labelText: 'Full Name',
              ),
            ),

            // Email TextField
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
          ]),
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PrimaryLarge(text: "Save", onPressed: () {}),
        ),
      ],
    );
  }
}
