// chat screen
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/profile.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        surfaceTintColor: AppColor.background,
        elevation: 1,
        title: Center(
          child: Text(
            'Chat',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 24,
            ),
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              child: Container(
                margin: EdgeInsets.all(12),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/avatar.jpg'),
                ),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              // Handle notification icon tap
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {},
                  child: ListTile(
                    tileColor: AppColor.background,
                    title: Text("Ahmed $index"),
                    subtitle: Text("Message $index"),
                    leading: CircleAvatar(
                      child: Text("U"),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
