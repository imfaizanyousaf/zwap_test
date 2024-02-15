import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/components/bottom_nav.dart';
import 'package:zwap_test/view/components/post_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.background,
          elevation: 1,
          title: Center(
            child: SvgPicture.asset(
              'assets/zwap.svg',
              height: 26.0,
              width: 150.0,
            ),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
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
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Text('Side Menu Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Menu Item 1'),
                onTap: () {
                  // Handle menu item 1 tap
                },
              ),
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  // Handle menu item 2 tap
                },
              ),
            ],
          ),
        ),
        body: InfiniteScroll(),
        bottomNavigationBar: BottomNav());
  }
}

class InfiniteScroll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return PostCard();
      },
    );
  }
}
