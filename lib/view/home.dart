import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/components/bottom_nav.dart';
import 'package:zwap_test/view/components/post_card.dart';
import 'package:zwap_test/view/search.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> pageList = [
    HomeScreen(),
    SearchScreen(),
    SearchScreen(),
    SearchScreen(),
    SearchScreen()
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Specify the number of tabs
      child: Scaffold(
        appBar: _selectedIndex == 0
            ? AppBar(
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
                bottom: _selectedIndex == 0
                    ? TabBar(
                        labelColor: AppColor.primary,
                        indicatorColor: AppColor.primary,
                        tabs: [
                          Tab(text: 'For You'),
                          Tab(text: 'Following'),
                        ],
                      )
                    : null)
            : null,
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
                  // Handle logout
                },
              ),
            ],
          ),
        ),
        body: _selectedIndex == 0
            ? TabBarView(
                children: [
                  CardList(tabTitle: 'For You'),
                  CardList(tabTitle: 'Following'),
                ],
              )
            : pageList.elementAt(_selectedIndex),
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
    return ListView.builder(
      itemCount: tabTitle == 'For You' ? 3 : 1,
      itemBuilder: (BuildContext context, int index) {
        return PostCard();
      },
    );
  }
}
