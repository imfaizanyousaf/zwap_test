import 'package:flutter/material.dart';
import 'package:zwap_test/global/commons/toast.dart';
import 'package:zwap_test/model/post.dart';
import 'package:zwap_test/model/request.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/view/components/buttons/primaryLarge.dart';

class ReviewScreen extends StatefulWidget {
  final Request request;

  const ReviewScreen({super.key, required this.request});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int rating = 0;

  TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave a Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Review on ${widget.request.requestedPost.title}'),
              SizedBox(height: 16),
              Text('Rating:'),
              SizedBox(height: 16),
              Container(
                height: 50, // Specify a height to avoid rendering errors
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          rating = index + 1;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(
                          Icons.star,
                          size: 36,
                          color: index < rating ? Colors.amber : Colors.grey,
                        ),
                      ),
                    );
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ),
              SizedBox(height: 16),
              Text('Review:'),
              TextField(
                controller: reviewController,
                maxLines: 3,
                maxLength: 50,
                decoration: InputDecoration(
                  hintText: 'Write a review',
                ),
              ),
              SizedBox(height: 16),
              PrimaryLarge(
                  text: 'Submit',
                  onPressed: () async {
                    if (rating == 0) {
                      showToast(message: 'Please provide a rating');
                      return;
                    }
                    api userApi = api();
                    String feedback = reviewController.text;
                    String response = await userApi.addFeedback(
                        rating.toString(),
                        widget.request.requestedPostId,
                        widget.request.requestedBy.id,
                        widget.request.requestedPost.userId,
                        feedback);

                    if (response == '200') {
                      String exchanged = await userApi
                          .exchanged(widget.request.exchangePostId);
                      if (exchanged == '200') {
                        if (widget.request.requestedPost.exchangedAt != null) {
                          String reviewStatus =
                              await userApi.reviewPost(widget.request.id);
                          if (reviewStatus == '200') {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  icon: Icon(Icons.check_circle,
                                      color: Colors.green, size: 48),
                                  title: Column(
                                    children: [
                                      Text("Review Ended & Exchange Closed!"),
                                      Text(
                                        "Both posts have been reviewed and exchange have been closed!",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        } else {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                icon: Icon(Icons.check_circle,
                                    color: Colors.green, size: 48),
                                title: Column(
                                  children: [
                                    Text("Review Added!"),
                                    Text(
                                      "Shabash mery sher!",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    } else {
                      showToast(message: 'Failed to add review');
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
