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
              title: Text('Profile'),
            ),
            SliverAppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: MediaQuery.of(context).size.height / 5,
              pinned: false,
              backgroundColor: AppColor.background,
              title: Padding(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Faizan Yousaf',
                                        style: GoogleFonts.manrope(
                                          textStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            height: 1.2,
                                            letterSpacing: 0.150000006,
                                            color: Color(0xff000000),
                                          ),
                                        )),
                                    Text('@faizan.usuf',
                                        style: GoogleFonts.manrope(
                                          textStyle: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            height: 1.6,
                                            letterSpacing: 0.150000006,
                                            color:
                                                Color.fromARGB(255, 71, 71, 71),
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
                                    builder: (context) => EditProfileScreen()),
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
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
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
            // Use SliverList instead of SliverAnimatedList for simplicity
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  // Conditionally display posts based on the selected icon
                  if (selectedIconIndex == 0) {
                    // Display 1 post for Dashboard
                    return PostCard();
                  } else if (selectedIconIndex == 1) {
                    // Display 2 posts for TV
                    return Column(
                      children: [
                        PostCard(),
                        PostCard(),
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

//   Widget _buildTab1Content() {
//     return Center(
//       child: Text('Tab 1 Content'),
//     );
//   }

//   Widget _buildTab2Content() {
//     return Center(
//       child: Text('Tab 2 Content'),
//     );
//   }
// }

// Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       CircleAvatar(
//                         radius: 28,
//                         backgroundImage: AssetImage('assets/avatar.jpg'),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Faizan Yousaf',
//                                 style: GoogleFonts.manrope(
//                                     textStyle: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                   height: 1.2,
//                                   letterSpacing: 0.150000006,
//                                   color: Color(0xff000000),
//                                 ))),
//                             Text('@faizan.usuf',
//                                 style: GoogleFonts.manrope(
//                                     textStyle: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w500,
//                                   height: 1.6,
//                                   letterSpacing: 0.150000006,
//                                   color: Color.fromARGB(255, 71, 71, 71),
//                                 ))),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Add your button logic here
//                     },
//                     child: Text('Follow'),
//                   ),
//                 ],
//               ),
//             ),
//             Row(
//               children: [
//                 Text('Rawalpindi, Pakistan',
//                     style: GoogleFonts.manrope(
//                         textStyle: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                       height: 1.6,
//                       letterSpacing: 0.150000006,
//                       color: Color.fromARGB(255, 71, 71, 71),
//                     ))),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Column(
//                     children: [
//                       Text(
//                         '1.2k',
//                       ),
//                       Text('Followers'),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       Text(
//                         '1.2k',
//                       ),
//                       Text('Following'),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       Text(
//                         '1.2k',
//                       ),
//                       Text('Trades'),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//             Expanded(
//               child: DefaultTabController(
//                 length: 2,
//                 child: Column(
//                   children: [
//                     TabBar(
//                       tabs: [
//                         Tab(text: 'Tab 1'),
//                         Tab(text: 'Tab 2'),
//                       ],
//                     ),
//                     Expanded(
//                       child: TabBarView(
//                         children: [
//                           _buildTab1Content(),
//                           _buildTab2Content(),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );

