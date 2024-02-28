import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/res/health.dart';
import 'package:zwap_test/view/components/buttons/primaryLarge.dart';
import 'package:zwap_test/view/components/health_badge.dart';
import 'package:zwap_test/view/filters/categories.dart';
import 'package:zwap_test/view/filters/item_condition.dart';
import 'package:zwap_test/view/filters/location.dart';

class SortFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sort & Filter'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.restart_alt,
                color: AppColor.secondary,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Clear Filters'),
                      content:
                          Text('Are you sure you want to clear all filters?'),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Confirm'),
                          onPressed: () {
                            // Add your logic here
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
              child: Text(
                "Categories",
                style: GoogleFonts.manrope(fontSize: 14, color: Colors.black54),
              ),
            ),
            ListTile(
              title: Text('Electronics and 2 more',
                  style:
                      GoogleFonts.manrope(fontSize: 16, color: Colors.black)),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoriesPage()),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
              child: Text(
                "Location",
                style: GoogleFonts.manrope(fontSize: 14, color: Colors.black54),
              ),
            ),
            ListTile(
              leading: Icon(Icons.location_on_outlined),
              title: Text('Rawalpindi, Pakistan',
                  style:
                      GoogleFonts.manrope(fontSize: 16, color: Colors.black)),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LocationPage()),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
              child: Text(
                "Item Condition",
                style: GoogleFonts.manrope(fontSize: 14, color: Colors.black54),
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: HealthBadge(
                        condition: Health.GOOD,
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: HealthBadge(
                        condition: Health.FAIR,
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: HealthBadge(
                        condition: Health.NEW,
                      )),
                ],
              ),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ItemCondition()),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
              child: Text(
                "Sort by",
                style: GoogleFonts.manrope(fontSize: 14, color: Colors.black54),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Wrap(
                spacing: 8,
                children: <Widget>[
                  FilterChip(
                    side: BorderSide(
                      color: Color(0xff5c5c5c),
                    ),
                    label: Text(
                      'Most Recent',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        color: Color(0xff5c5c5c),
                      ),
                    ),
                    onSelected: (isSelected) {},
                  ),
                  FilterChip(
                    side: BorderSide(
                      color: Color(0xff5c5c5c),
                    ),
                    label: Text(
                      'Most Relevant',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        color: Color(0xff5c5c5c),
                      ),
                    ),
                    onSelected: (isSelected) {},
                  ),
                ],
              ),
            )
          ],
        ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: PrimaryLarge(
              text: 'Apply Filters',
              onPressed: () {
                // Add your logic here
              },
            ),
          ),
        ]);
  }
}
