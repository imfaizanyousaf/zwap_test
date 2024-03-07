import 'package:flutter/material.dart';

class CustomList extends StatefulWidget {
  final List<String> items;

  CustomList({required this.items});

  @override
  _CheckboxListState createState() => _CheckboxListState();
}

class _CheckboxListState extends State<CustomList> {
  List<String> selectedItems = [];
  bool listStatus = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          childrenPadding: EdgeInsets.only(left: 16),
          title: CheckboxListTile(
            contentPadding: EdgeInsets.all(0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(widget.items[0]),
            value: (selectedItems.length > 0 &&
                    selectedItems.length < widget.items.length)
                ? null
                : selectedItems.contains(widget.items[0]),
            tristate: true,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  for (String item in widget.items) {
                    selectedItems.add(item);
                  }
                } else {
                  selectedItems.clear();
                }
              });
            },
          ),
          children: [
            for (String item in widget.items.sublist(1))
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(item),
                value: selectedItems.contains(item),
                onChanged: (value) {
                  setState(() {
                    if (value != null && value) {
                      selectedItems.add(item);
                    } else {
                      selectedItems.remove(item);
                    }
                  });
                },
              ),
          ],
        ),
      ],
    );
  }
}
