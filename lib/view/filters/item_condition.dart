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
          itemCount: health.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              title: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: HealthBadge(condition: health[index]),
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
            );
          },
        ),
      ),
    );
  }
}

List<Health> health = [
  Health.NEW,
  Health.LIKE_NEW,
  Health.GOOD,
  Health.FAIR // Add more categories here
];
