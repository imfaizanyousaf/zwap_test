import 'package:flutter/material.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/chat.dart';
import 'package:zwap_test/view/components/bottom_nav.dart';
import 'package:zwap_test/view/components/post_card.dart';
import 'package:zwap_test/view/feed.dart';
import 'package:zwap_test/view/new_post.dart';
import 'package:zwap_test/view/requests.dart';

import 'package:zwap_test/view/search.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Specify the number of tabs
      child: Scaffold(
        body: IndexedStack(
          children: <Widget>[
            Feed(
              selectedIndex: _selectedIndex,
            ),
            SearchScreen(),
            NewPostScreen(),
            RequestScreen(),
            ChatScreen(),
          ],
          index: _selectedIndex,
        ),
        bottomNavigationBar: BottomNav(
          onTabTapped: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class CardList extends StatelessWidget {
  final String tabTitle;

  CardList({required this.tabTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.background,
      child: ListView.builder(
        itemCount: tabTitle == 'For You' ? 3 : 1,
        itemBuilder: (BuildContext context, int index) {
          return Card();
        },
      ),
    );
  }
}
