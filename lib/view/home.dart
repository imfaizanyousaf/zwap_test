import 'package:flutter/material.dart';
import 'package:zwap_test/model/user.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/utils/connection.dart'; // Assuming this is where checkConnection is defined
import 'package:zwap_test/view/chat.dart';
import 'package:zwap_test/view/components/bottom_nav.dart';
import 'package:zwap_test/view/feed.dart';
import 'package:zwap_test/view/new_post.dart';
import 'package:zwap_test/view/requests.dart';
import 'package:zwap_test/view/search.dart';

class HomeScreen extends StatefulWidget {
  final User currentUser;

  HomeScreen({required this.currentUser});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  void checkConnection() async {
    bool connected =
        await isConnected(); // Assuming isConnected is defined in connection.dart
    setState(() {
      _isConnected = connected;
    });

    if (!_isConnected) {
      _showNoConnectionDialog();
    } else {
      Navigator.of(context, rootNavigator: true)
          .popUntil((route) => route.isFirst);
    }
  }

  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Internet Connection'),
          content: Text('Please check your internet connection.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                checkConnection();
              },
              child: Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Specify the number of tabs
      child: Scaffold(
        body: IndexedStack(
          children: <Widget>[
            Feed(
              currentUser: widget.currentUser,
              selectedIndex: _selectedIndex,
            ),
            SearchScreen(
              currentUser: widget.currentUser,
            ),
            NewPostScreen(
              currentUser: widget.currentUser,
            ),
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
