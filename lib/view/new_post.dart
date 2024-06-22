import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/model/user.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/components/buttons/primaryLarge.dart';
import 'package:zwap_test/view/edit_new_post.dart';

class NewPostScreen extends StatelessWidget {
  final User currentUser;

  NewPostScreen({required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text(
          'New Post',
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: 24,
          ),
        ),
        backgroundColor: AppColor.background,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
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
                    'Select atleast one image to continue',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  child: PrimaryLarge(
                    color: AppColor.lightBlue,
                    text: 'Create Post',
                    onPressed: () {
                      // navigate to edit_new_post.dart
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditNewPostScreen(
                              currentUser: currentUser,
                            ),
                          ));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
