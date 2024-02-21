import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/filters/sort_filter.dart';

class SearchBox extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          AppColor.background, // You can set the background color here
      elevation: 0, // No shadow
      title: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Color.fromARGB(
                65, 0, 0, 0), // You can set the border color here
            width: 1.6, // You can set the border width here
          ),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search Items',
            hintStyle: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.0,
              letterSpacing: 0.25,
              color: Color(0xff5c5c5c),
            ),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
            suffixIcon: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SortFilter()));
              },
              child: Icon(Icons.tune_rounded),
            ),
          ),
        ),
      ),
    );
  }
}
