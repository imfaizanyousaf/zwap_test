import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/view/components/interest_card.dart';
import 'package:zwap_test/view/components/search_box.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBox(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: InterestCard(
                        icon: Icon(Icons.bed),
                        text: Text("Furniture"),
                      )),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: InterestCard(
                              icon: Icon(Icons.toys), text: Text("Toys")))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: InterestCard(
                        icon: Icon(Icons.laptop),
                        text: Text("Electronics"),
                      )),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: InterestCard(
                              icon: Icon(Icons.toys), text: Text("Toys")))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
