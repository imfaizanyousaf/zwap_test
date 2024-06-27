import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/global/commons/toast.dart';
import 'package:zwap_test/model/post.dart';
import 'package:zwap_test/model/request.dart';
import 'package:zwap_test/model/user.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/utils/number_formater.dart';
import 'package:zwap_test/utils/token_manager.dart';
import 'package:zwap_test/view/add_interests.dart';
import 'package:zwap_test/view/add_locations.dart';
import 'package:zwap_test/view/components/buttons/primaryLarge.dart';
import 'package:zwap_test/view/components/post_card.dart';
import 'package:zwap_test/view/edit_new_post.dart';
import 'package:zwap_test/view/edit_profile.dart';
import 'package:zwap_test/view/filters/categories.dart';
import 'package:zwap_test/view/user_auth/signin.dart';

class ProfileScreen extends StatefulWidget {
  User currentUser;
  User? loggedInUser;
  List<User> follwedBy = [];
  List<User> following = [];
  List<User> loggedInUserFollowing = [];
  List<User> loggedInUserFollowedBy = [];
  int trades = 0;
  ProfileScreen({required this.currentUser});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Post> favPosts = [];
  bool isFollowing = false;
  List<Post> posts = [];

  Future<void> _fetchUserData() async {
    _showLoadingDialog();
    try {
      api _api = api();
      bool tempIsFollowing = false;
      User user = await _api.getUser(widget.currentUser.id);
      List<Request> requests = await _api.getReceivedRequests();
      List<Request> requestsSent = await _api.getSentRequests();

      // join requests and requestsSent to get all requests with status 'accepted'
      List<Request> acceptedRequests = requests
              .map((e) => e)
              .where((element) => element.status == 'accepted')
              .toList() +
          requestsSent
              .map((e) => e)
              .where((element) => element.status == 'accepted')
              .toList();

      List<Post> userPosts = await _api.getPostsByUser(user.id);
      User tempUser = await _api.getUser(null);
      List<Post> tempFavPosts = await _api.getFavPosts(widget.currentUser.id);
      posts = userPosts;
      print('USER POSTS: ' + jsonEncode(posts));
      List<User> tempFollowedBy =
          await _api.getFollowedBy(widget.currentUser.id);
      List<User> tempFollowing = await _api.getFollowing(widget.currentUser.id);

      List<User> tempLoggedInFollowing = await _api.getFollowing(tempUser.id);
      List<User> tempLoggedInFollowedBy = await _api.getFollowedBy(tempUser.id);

      List<int> tempLoggedInFollowingIds =
          tempLoggedInFollowing.map((e) => e.id).toList();

      if (tempLoggedInFollowingIds != [] &&
          tempLoggedInFollowingIds.contains(widget.currentUser.id)) {
        tempIsFollowing = true;
      } else {
        tempIsFollowing = false;
      }

      if (mounted) {
        setState(() {
          widget.currentUser = user;
          posts = userPosts;
          widget.loggedInUser = tempUser;
          favPosts = tempFavPosts;

          widget.follwedBy = tempFollowedBy;
          widget.following = tempFollowing;

          isFollowing = tempIsFollowing;

          widget.trades = acceptedRequests.length;
        });
      }
    } catch (e) {
      // Handle errors here, e.g., show an error message
      print("Error fetching user data: $e");
    } finally {
      // Ensure the loading dialog is closed
      Navigator.pop(context);
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            content: Container(
          height: 100,
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColor.primary,
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ));
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserData();
    });
  }

  int selectedIconIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              actions: [
                (widget.loggedInUser != null &&
                        widget.currentUser.id == widget.loggedInUser!.id)
                    ? InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: Container(
                                  child: Wrap(
                                    children: <Widget>[
                                      ListTile(
                                        leading:
                                            Icon(Icons.favorite_border_rounded),
                                        title: Text('Edit Interests'),
                                        onTap: () => {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddInterestsScreen(
                                                        previousScreen:
                                                            'ProfileScreen',
                                                      )))
                                        },
                                      ),
                                      ListTile(
                                        leading:
                                            Icon(Icons.location_on_outlined),
                                        title: Text('Edit Meeting Venues'),
                                        onTap: () => {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddLocationsScreen(
                                                        previousScreen:
                                                            'ProfileScreen',
                                                      )))
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(
                                          Icons.logout_outlined,
                                          color: Colors.red,
                                        ),
                                        title: Text(
                                          'Log Out',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onTap: () => {
                                          //Logout by calling the logout function in api.dart
                                          _logout()
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(Icons.more_horiz),
                        ),
                      )
                    : Container()
              ],
              backgroundColor: AppColor.background,
              surfaceTintColor: AppColor.background,
              title: Text('Profile'),
              pinned: true,
            ),
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: false,
              backgroundColor: AppColor.background,
              toolbarHeight: 190.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundImage: widget.loggedInUser != null
                                      ? NetworkImage(
                                          widget.currentUser.logo ??
                                              'https://avatar.iran.liara.run/username?username=${widget.currentUser!.firstName}+${widget.currentUser!.lastName}',
                                        )
                                      : NetworkImage(
                                          'https://avatar.iran.liara.run/username?username=${widget.currentUser.firstName}+${widget.currentUser.lastName}',
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          widget.currentUser.firstName +
                                              " " +
                                              widget.currentUser.lastName,
                                          style: GoogleFonts.getFont(
                                            "Manrope",
                                            textStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              height: 1.2,
                                              letterSpacing: 0.150000006,
                                              color: Color(0xff000000),
                                            ),
                                          )),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColor.lightBlue,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0.0, horizontal: 8),
                                          child: Row(
                                            children: [
                                              Icon(Icons.stars_rounded,
                                                  size: 12,
                                                  color: AppColor.primary),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text('Level 1',
                                                  style: GoogleFonts.getFont(
                                                    "Manrope",
                                                    textStyle: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1.6,
                                                      letterSpacing:
                                                          0.150000006,
                                                      color: Color.fromARGB(
                                                          255, 71, 71, 71),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            OutlinedButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          AppColor.primary)),
                              onPressed: () async {
                                if (widget.loggedInUser != null &&
                                    widget.currentUser.id ==
                                        widget.loggedInUser!.id) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfileScreen()),
                                  );
                                } else {
                                  api _api = api();
                                  List<int> followingIds = widget
                                      .loggedInUserFollowing
                                      .map((e) => e.id)
                                      .toList();

                                  List<int> followedIds = widget.follwedBy
                                      .map((e) => e.id)
                                      .toList();

                                  if (isFollowing) {
                                    followingIds.remove(widget.currentUser.id);
                                    widget.loggedInUserFollowing
                                        .remove(widget.currentUser);
                                    String response = '0';
                                    if (widget.loggedInUser != null) {
                                      response = await _api.addFollowing(
                                          widget.loggedInUser!.id,
                                          followingIds);
                                    }
                                    followedIds.remove(widget.loggedInUser!.id);
                                    String response2 = await _api.addFollowedBy(
                                        widget.currentUser.id, followedIds);
                                    if (response == '200' &&
                                        response2 == '200') {
                                      setState(() {
                                        widget.follwedBy
                                            .remove(widget.loggedInUser!);

                                        isFollowing = false;
                                      });
                                    }
                                  } else {
                                    followingIds.add(widget.currentUser.id);
                                    widget.loggedInUserFollowing
                                        .remove(widget.currentUser);
                                    String response = '0';
                                    if (widget.loggedInUser != null) {
                                      response = await _api.addFollowing(
                                          widget.loggedInUser!.id,
                                          followingIds);
                                    }
                                    followedIds.add(widget.loggedInUser!.id);
                                    String response2 = await _api.addFollowedBy(
                                        widget.currentUser.id, followedIds);
                                    if (response == '200' &&
                                        response2 == '200') {
                                      setState(() {
                                        widget.follwedBy
                                            .add(widget.loggedInUser!);
                                        isFollowing = true;
                                      });
                                    }
                                  }
                                }
                              },
                              child: (widget.loggedInUser != null)
                                  ? (widget.currentUser.id ==
                                          widget.loggedInUser!.id)
                                      ? Text(
                                          'Edit Profile',
                                        )
                                      : isFollowing
                                          ? Text(
                                              'Following',
                                            )
                                          : Text(
                                              'Follow',
                                            )
                                  : Text(''),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                    NumberFormatter.format(
                                        widget.follwedBy.length),
                                    style: GoogleFonts.manrope(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        height: 1.6,
                                        letterSpacing: 0.150000006,
                                        color: Color.fromARGB(255, 71, 71, 71),
                                      ),
                                    )),
                                Text('Followers',
                                    style: GoogleFonts.manrope(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        height: 1.6,
                                        letterSpacing: 0.150000006,
                                        color: Color.fromARGB(255, 71, 71, 71),
                                      ),
                                    )),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                    NumberFormatter.format(
                                        widget.following.length),
                                    style: GoogleFonts.manrope(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        height: 1.6,
                                        letterSpacing: 0.150000006,
                                        color: Color.fromARGB(255, 71, 71, 71),
                                      ),
                                    )),
                                Text('Following',
                                    style: GoogleFonts.manrope(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        height: 1.6,
                                        letterSpacing: 0.150000006,
                                        color: Color.fromARGB(255, 71, 71, 71),
                                      ),
                                    )),
                              ],
                            ),
                            Column(
                              children: [
                                Text(widget.trades.toString(),
                                    style: GoogleFonts.manrope(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        height: 1.6,
                                        letterSpacing: 0.150000006,
                                        color: Color.fromARGB(255, 71, 71, 71),
                                      ),
                                    )),
                                Text('Trades',
                                    style: GoogleFonts.manrope(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        height: 1.6,
                                        letterSpacing: 0.150000006,
                                        color: Color.fromARGB(255, 71, 71, 71),
                                      ),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              surfaceTintColor: AppColor.background,
              backgroundColor: AppColor.background,
              title: Container(
                decoration: BoxDecoration(
                  color: AppColor.background,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedIconIndex = 0;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: selectedIconIndex == 0
                                    ? AppColor.primary // Selected tab color
                                    : Colors.grey[200]!,
                                width: 2,
                              ),
                            ),
                          ),
                          // Make the entire Container tappable
                          child: Center(
                            child: Text(
                              'Posts',
                              style: GoogleFonts.manrope(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 1.6,
                                  letterSpacing: 0.15,
                                  color: selectedIconIndex == 0
                                      ? AppColor
                                          .primary // Selected tab text color
                                      : Color.fromARGB(255, 71, 71, 71),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    (widget.loggedInUser != null)
                        ? (widget.currentUser.id == widget.loggedInUser!.id)
                            ? Expanded(
                                child: InkWell(
                                  splashColor: Colors
                                      .grey, // Set the desired splash color
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      selectedIconIndex = 1;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: selectedIconIndex == 1
                                              ? AppColor
                                                  .primary // Selected tab color
                                              : Colors.grey[200]!,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    // Make the entire Container tappable
                                    child: Center(
                                      child: Text(
                                        'Favourites',
                                        style: GoogleFonts.manrope(
                                          textStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            height: 1.6,
                                            letterSpacing: 0.15,
                                            color: selectedIconIndex == 1
                                                ? AppColor
                                                    .primary // Selected tab text color
                                                : Color.fromARGB(
                                                    255, 71, 71, 71),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container()
                        : Container(),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (selectedIconIndex == 0) {
                    if (widget.currentUser.posts == null ||
                        widget.currentUser.posts!.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/empty-states/posts.svg',
                                width: 250,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Text(
                                  'Your posts will appear here',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (posts.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/empty-states/posts.svg',
                                width: 250,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Text(
                                  'No posts to display',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Container(
                                width: 200,
                                child: PrimaryLarge(
                                  color: Color.fromARGB(255, 232, 234, 246),
                                  text: 'Create Post',
                                  onPressed: () {
                                    // navigate to edit_new_post.dart
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditNewPostScreen(
                                            currentUser: widget.currentUser,
                                          ),
                                        ));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return PostCard(
                        post: posts[index],
                        currentUser: widget.currentUser,
                      );
                    }
                  } else if (selectedIconIndex == 1) {
                    if (favPosts.isEmpty || favPosts == []) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/empty-states/interests.svg',
                                width: 250,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Text(
                                  'No faviourate posts',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return PostCard(
                        post: favPosts[index],
                        currentUser: widget.currentUser,
                      );
                    }
                  } else {
                    // Handle other icons if needed
                    return Container();
                  }
                },
                childCount: selectedIconIndex == 0
                    ? (widget.currentUser.posts?.length ?? 1)
                    : (favPosts.length ?? 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout() async {
    api _api = api(); // Initialize the _api variable
    int statusCode = await _api.logout();
    if (statusCode == 200) {
      await TokenManager.removeToken();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
        (Route route) => false,
      );
    } else {
      showToast(message: 'Error logging out');
    }
  }
}
