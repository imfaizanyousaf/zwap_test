import 'package:flutter/material.dart';
import 'package:zwap_test/model/post.dart';
import 'package:zwap_test/model/reviews.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/view/product_details.dart';

class ReviewCard extends StatelessWidget {
  final Reviews review;
  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {},
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.feedbackBy["first_name"] +
                        review.feedbackBy["last_name"],
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 30, // Specify a height to avoid rendering errors
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index2) {
                        return Icon(
                          Icons.star,
                          size: 20,
                          color: index2 < review.rating
                              ? Colors.amber
                              : Colors.grey,
                        );
                      },
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  Text(
                    review.comment,
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
              InkWell(
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          content: Container(
                        height: 100,
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: AppColor.primary,
                            ),
                          ],
                        ),
                      ));
                    },
                  );
                  Post post = await api().getPostById(review.feedbackOn);
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsScreen(post: post)));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      width: 1,
                      color: Colors.black54,
                    ),
                  ),
                  width: 50,
                  height: 50,
                  child: Image(
                    image: NetworkImage(review.post.imageUrls![0]),
                  ),
                ),
              )
            ],
          ),
        ),
        Divider()
      ],
    );
  }
}
