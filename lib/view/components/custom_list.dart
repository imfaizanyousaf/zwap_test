import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomList extends StatelessWidget {
  final List<String> items;

  CustomList({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        Widget listItem = CheckboxListTile(
          title: Text(
            items[index],
            style: GoogleFonts.manrope(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500),
          ),
          value: false,
          onChanged: (value) {},
          controlAffinity: ListTileControlAffinity.leading,
        );

        // Check if it's the first item and there's more than one item
        if (index == 0 && items.length > 1) {
          // Add a horizontal divider after the first item
          return Column(
            children: [
              listItem,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  height: 0,
                  thickness: 1.6,
                  color: Color.fromARGB(65, 0, 0, 0),
                ),
              ),
            ],
          );
        } else {
          return listItem;
        }
      },
    );
  }
}
