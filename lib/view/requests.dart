import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/components/bottom_nav.dart';
import 'package:zwap_test/view/components/buttons/primaryLarge.dart';
import 'package:zwap_test/view/components/request_card.dart';
import 'package:zwap_test/view/new_post.dart';
import 'package:zwap_test/view/profile.dart';
import 'package:zwap_test/view/search.dart';

class RequestScreen extends StatefulWidget {
  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.background,
        elevation: 1,
        title: Center(
          child: Text(
            'Requests',
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
        bottom: TabBar(
          labelColor: AppColor.primary,
          indicatorColor: AppColor.primary,
          overlayColor:
              MaterialStateProperty.all<Color>(Color.fromARGB(20, 42, 56, 144)),
          tabs: [
            Tab(text: 'Received'),
            Tab(text: 'Sent'),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          CardList(tabTitle: 'Received'),
          CardList(tabTitle: 'Sent'),
        ],
      ),
    );
  }
}

class CardList extends StatelessWidget {
  final String tabTitle;

  CardList({required this.tabTitle});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tabTitle == 'Received' ? 3 : 1,
      itemBuilder: (BuildContext context, int index) {
        return RequestCard();
      },
    );
  }
}
