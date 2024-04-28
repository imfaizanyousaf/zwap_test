import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/components/post_card.dart';
import 'package:zwap_test/view/edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Track the selected icon index
  int selectedIconIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              actions: [
                InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Container(
                            child: Wrap(
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.favorite_border_rounded),
                                  title: Text('Add to favorites'),
                                  onTap: () => {},
                                ),
                                ListTile(
                                  leading: Icon(Icons.copy),
                                  title: Text('Copy Link'),
                                  onTap: () => {},
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.flag_outlined,
                                    color: Colors.red,
                                  ),
                                  title: Text(
                                    'Report',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onTap: () => {},
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
                                  backgroundImage:
                                      AssetImage('assets/avatar.jpg'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Faizan Yousaf',
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
                                      Text('@faizan.usuf',
                                          style: GoogleFonts.getFont(
                                            "Manrope",
                                            textStyle: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              height: 1.6,
                                              letterSpacing: 0.150000006,
                                              color: Color.fromARGB(
                                                  255, 71, 71, 71),
                                            ),
                                          )),
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditProfileScreen()),
                                );
                              },
                              child: Text(
                                'Follow',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text('Rawalpindi, Pakistan',
                              style: GoogleFonts.manrope(
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 1.6,
                                  letterSpacing: 0.150000006,
                                  color: Color.fromARGB(255, 71, 71, 71),
                                ),
                              )),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text('1.2k',
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
                                Text('1.2k',
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
                                Text('1.2k',
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
                    Expanded(
                      child: InkWell(
                        splashColor:
                            Colors.grey, // Set the desired splash color
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
                                    ? AppColor.primary // Selected tab color
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
                                      : Color.fromARGB(255, 71, 71, 71),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  // Conditionally display posts based on the selected icon
                  if (selectedIconIndex == 0) {
                    // Display 1 post for Dashboard
                    return Card();
                  } else if (selectedIconIndex == 1) {
                    // Display 2 posts for TV
                    return Column(
                      children: [
                        Card(),
                        Card(),
                      ],
                    );
                  } else {
                    // Handle other icons if needed
                    return Container();
                  }
                },
                childCount: 1, // Change the count based on your requirements
              ),
            ),
          ],
        ),
      ),
    );
  }
}
