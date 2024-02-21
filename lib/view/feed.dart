import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zwap_test/view/components/post_card.dart';
import 'package:zwap_test/res/colors/colors.dart';

class Feed extends StatelessWidget {
  final int selectedIndex;

  Feed({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
              bottom: selectedIndex == 0
                  ? TabBar(
                      overlayColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(20, 42, 56, 144)),
                      labelColor: AppColor.primary,
                      indicatorColor: AppColor.primary,
                      tabs: [
                        Tab(text: 'For You'),
                        Tab(text: 'Following'),
                      ],
                    )
                  : null),
          body: TabBarView(
            children: [
              CardList(tabTitle: 'For You'),
              CardList(tabTitle: 'Following'),
            ],
          ) // You can customize this as needed
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
          return PostCard();
        },
      ),
    );
  }
}
