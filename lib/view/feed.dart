import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zwap_test/model/categories.dart';
import 'package:zwap_test/model/post.dart';
import 'package:zwap_test/model/user.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/utils/connection.dart';
import 'package:zwap_test/view/add_interests.dart';
import 'package:zwap_test/view/components/buttons/primaryLarge.dart';
import 'package:zwap_test/view/components/post_card.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/notifications.dart';
import 'package:zwap_test/view/profile.dart';

class Feed extends StatefulWidget {
  final User currentUser;

  final int selectedIndex;
  Feed({required this.selectedIndex, required this.currentUser});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
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
                            builder: (context) => ProfileScreen(
                                  currentUser: widget.currentUser,
                                )),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(12),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(widget.currentUser.logo ??
                            'https://avatar.iran.liara.run/username?username=${widget.currentUser.firstName}+${widget.currentUser.lastName}'),
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
              bottom: widget.selectedIndex == 0
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
              CardList(
                tabTitle: 'For You',
                currentUser: widget.currentUser,
              ),
              CardList(
                tabTitle: 'Following',
                currentUser: widget.currentUser,
              ),
            ],
          ) // You can customize this as needed
          ),
    );
  }
}

class CardList extends StatefulWidget {
  final String tabTitle;
  final User currentUser;

  CardList({required this.tabTitle, required this.currentUser});

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  final api userViewModel = api();
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
  }

  @override
  Widget build(BuildContext context) {
    return !_isConnected
        ? Scaffold(
            body: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/empty-states/no-connection.svg',
                      width: 250,
                    ),
                    Text('No Internet Connection'),
                    SizedBox(
                      height: 8,
                    ),
                    TextButton(onPressed: checkConnection, child: Text('Retry'))
                  ],
                ),
              ),
            ),
          )
        : Container(
            color: AppColor.background,
            child: FutureBuilder<List<Post>>(
              future: widget.tabTitle == "For You"
                  ? userViewModel.getPostsForYou(widget.currentUser.id)
                  : userViewModel.getFollowingFeed(widget.currentUser.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child:
                          CircularProgressIndicator()); // Display a loading indicator while waiting for data
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text(
                          "Error: ${snapshot.error}")); // Display an error message if data fetching fails
                } else if (snapshot.data!.isEmpty) {
                  bool hasInterests;
                  bool hasFollowing;

                  Future<List<User>> followingUsers =
                      userViewModel.getFollowing(widget.currentUser.id);
                  if (followingUsers != null || followingUsers != []) {
                    hasFollowing = true;
                  } else {
                    hasFollowing = false;
                  }
                  Future<List<Categories>> interests =
                      userViewModel.getUserIntersts(widget.currentUser.id);
                  if (interests != null || interests != []) {
                    hasInterests = true;
                  } else {
                    hasInterests = false;
                  }
                  if ((widget.tabTitle == "For You" && !hasInterests) ||
                      (widget.tabTitle == "Following" && !hasFollowing)) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          widget.tabTitle == "For You"
                              ? 'assets/empty-states/interests.svg'
                              : 'assets/empty-states/posts.svg',
                          width: 250,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16),
                          child: Text(
                            widget.tabTitle == "For You"
                                ? 'You have not set up any interests yet. Add some to see posts'
                                : "You have not followed anyone",
                            textAlign: TextAlign.center,
                            style: TextStyle(),
                          ),
                        ),
                        widget.tabTitle == "For You"
                            ? Container(
                                width: 200,
                                child: PrimaryLarge(
                                  color: AppColor.lightBlue,
                                  text: 'Add Interests',
                                  onPressed: () {
                                    // navigate to edit_new_post.dart
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddInterestsScreen(
                                            previousScreen: 'ProfileScreen',
                                          ),
                                        ));
                                  },
                                ),
                              )
                            : Container(),
                      ],
                    ));
                  }

                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/empty-states/posts.svg',
                        width: 250,
                      ),
                      Text('No Posts Available'),
                    ],
                  ));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return PostCard(
                        post: snapshot.data![index],
                        currentUser: widget.currentUser,
                      );
                    },
                  );
                }
              },
            ),
          );
  }
}
