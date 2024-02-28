import 'package:flutter/material.dart';
import 'package:zwap_test/res/health.dart';
import 'package:zwap_test/view/components/health_badge.dart';

class ItemCondition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Item Condition'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color.fromARGB(
                      65,
                      0,
                      0,
                      0,
                    ), // You can set the border color here
                    width: 1.6, // You can set the border width here
                  ),
                ),
                child: CheckboxListTile(
                  title: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: HealthBadge(condition: categories[index]),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                        "lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor"),
                  ),
                  value: false,
                  onChanged: (value) {},
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

List<Health> categories = [
  Health.NEW,
  Health.LIKE_NEW,
  Health.GOOD,
  Health.FAIR // Add more categories here
];
