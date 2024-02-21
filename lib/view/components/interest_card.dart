import 'package:flutter/material.dart';

class InterestCard extends StatelessWidget {
  final Icon icon;
  final Text text;

  InterestCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Color.fromARGB(
                  65, 0, 0, 0), // You can set the border color here
              width: 1.0, // You can set the border width here
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                SizedBox(
                  width: 8,
                ),
                text,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
