import 'package:flutter/material.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/components/interest_card.dart';
import 'package:zwap_test/view/components/search_box.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: SearchBox(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SingleChildScrollView(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  InterestCard(
                    icon: Text("🛏️"),
                    text: Text("Furniture"),
                  ),
                  SizedBox(width: 8),
                  InterestCard(
                    icon: Text("🧸"),
                    text: Text("Toys"),
                  ),
                  SizedBox(width: 8),
                  InterestCard(
                    icon: Text("⚡"),
                    text: Text("Electronics"),
                  ),
                  SizedBox(width: 8),
                  InterestCard(
                    icon: Text("🛏️"),
                    text: Text("Toys"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
