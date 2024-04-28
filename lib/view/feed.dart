import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zwap_test/model/post.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/view/components/post_card.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/notifications.dart';
import 'package:zwap_test/view/profile.dart';
import 'package:zwap_test/view_model/user.dart';

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
              surfaceTintColor: AppColor.background,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationsScreen()),
                    );
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
  api userViewModel = api();

  CardList({required this.tabTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.background,
      child: FutureBuilder<List<Post>>(
        future: userViewModel.getPostsForYou(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    CircularProgressIndicator()); // Display a loading indicator while waiting for data
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    "Error: ${snapshot.error}")); // Display an error message if data fetching fails
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return PostCard(post: snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }
}
