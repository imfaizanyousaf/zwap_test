import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zwap_test/global/commons/toast.dart';
import 'package:zwap_test/model/post.dart';
import 'package:zwap_test/model/user.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/view/components/buttons/primaryLarge.dart';
import 'package:zwap_test/view/components/health_badge.dart';
import 'package:zwap_test/view/components/post_card.dart';

class ExchangeScreen extends StatefulWidget {
  @override
  _ExchangeScreenState createState() => _ExchangeScreenState();
  Post? exchangeWith;
  final Post requestedPost;

  ExchangeScreen({required this.requestedPost});

  api user = api();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  List<Post> posts = [];
  bool hasPosts = true;
  TextEditingController messageController = TextEditingController();
  void getUserPosts() async {
    User currentUser = await widget.user.getUser(null);
    List<Post> userPosts = await widget.user.getPostsByUser(currentUser.id);

    if (userPosts.isEmpty) {
      setState(() {
        hasPosts = false;
      });
    } else {
      setState(() {
        if (userPosts.isEmpty) {
          hasPosts = false;
        }
        posts = userPosts;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserPosts();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Items to Exchange'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                labelText: 'Write a message',
              ),
              onChanged: (value) {
                setState(() {
                  messageController.text = value;
                });
              },
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Select an item to exchange with:',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 8),
          posts.isEmpty
              ? Expanded(
                  child: Center(
                    child: hasPosts
                        ? CircularProgressIndicator()
                        : Text('No posts available'),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          tileColor: widget.exchangeWith == posts[index]
                              ? Colors.grey[200]
                              : null,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HealthBadge(
                                  condition: posts[index].condition!.name),
                              SizedBox(height: 8),
                              Text(posts[index].title),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/repeat.svg',
                              ),
                              SizedBox(width: 8),
                              Text(posts[index].description),
                            ],
                          ),
                          trailing: (widget.exchangeWith == posts[index])
                              ? Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                )
                              : null,
                          onTap: () {
                            setState(() {
                              widget.exchangeWith = posts[index];
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
      persistentFooterButtons: [
        PrimaryLarge(
            text: 'Send Offer',
            disabled:
                widget.exchangeWith == null || messageController.text.isEmpty,
            onPressed: () async {
              if (widget.exchangeWith != null &&
                  messageController.text.isNotEmpty) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 16),
                            Text("Sending Offer..."),
                          ],
                        ),
                      ),
                    );
                  },
                );
                if (widget.exchangeWith != null) {
                  api _api = api();
                  String response = await _api.addRequest(
                      widget.requestedPost.id!,
                      widget.exchangeWith!.id!,
                      messageController.text);
                  Navigator.pop(context);
                  if (response == '200') {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          icon: Icon(Icons.check_circle,
                              color: Colors.green, size: 48),
                          title: Column(
                            children: [
                              Text("Offer Sent!"),
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
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Failed to send offer!"),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
              }
            })
      ],
    );
  }
}
