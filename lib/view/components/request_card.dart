import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/model/post.dart';
import 'package:zwap_test/model/request.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:zwap_test/model/user.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/utils/connection.dart';
import 'package:zwap_test/view/chat_room.dart';
import 'package:zwap_test/view/components/health_badge.dart';
import 'package:zwap_test/view/home.dart';
import 'package:zwap_test/view/product_details.dart';
import 'package:zwap_test/view/requests.dart';
import 'package:zwap_test/view/review.dart';

class RequestCard extends StatefulWidget {
  final Request requests;
  final User? currentUser;
  final VoidCallback onRequestUpdated;

  const RequestCard(
      {super.key,
      required this.requests,
      required this.currentUser,
      required this.onRequestUpdated});

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  final int image = 0;
  String requestedToName = "";
  String imageUrlRequested =
      'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg';
  String imageUrlExchanged =
      'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg';
  void getRequestedToName() async {
    api _api = api();
    User requestedTo = await _api.getUser(widget.requests.requestedPost.userId);
    if (mounted) {
      setState(() {
        if (widget.requests.requestedPost.imageUrls == [] ||
            widget.requests.requestedPost.imageUrls == null ||
            widget.requests.requestedPost.imageUrls!.isEmpty) {
        } else {
          imageUrlRequested = widget.requests.requestedPost.imageUrls![0];
        }
        if (widget.requests.exchangedPost.imageUrls == [] ||
            widget.requests.exchangedPost.imageUrls == null ||
            widget.requests.exchangedPost.imageUrls!.isEmpty) {
        } else {
          imageUrlExchanged = widget.requests.exchangedPost.imageUrls![0];
        }
        requestedToName = requestedTo.firstName + ' ' + requestedTo.lastName;
      });
    }
  }

  @override
  initState() {
    super.initState();
    getRequestedToName();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: const Color.fromARGB(
                224, 224, 224, 224), // Specify the border color here
            width: 1, // Specify the border width here
          ),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12, 10, 12, 12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () {},
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.network(
                                  widget.requests.requestedBy.logo ??
                                      'https://avatar.iran.liara.run/username?username=${widget.requests.requestedBy.firstName}+${widget.requests.requestedBy.lastName}',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.error),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (widget.currentUser != null)
                                          ? (widget.requests.requestedBy.id ==
                                                  widget.currentUser!.id)
                                              ? requestedToName
                                              : (widget.requests.requestedBy
                                                      .firstName +
                                                  ' ' +
                                                  widget.requests.requestedBy
                                                      .lastName)
                                          : "",
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
                          child: (widget.currentUser != null)
                              ? (widget.currentUser!.id ==
                                      widget.requests.requestedBy.id)
                                  ? Icon(
                                      Icons.call_made,
                                      color: AppColor.primary,
                                      size: 16,
                                    )
                                  : Icon(
                                      Icons.call_received,
                                      color: AppColor.primary,
                                      size: 16,
                                    )
                              : Container(),
                        ),
                        Text(
                          timeago.format(widget.requests.createdAt),
                          textAlign: TextAlign.end,
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              widget.requests.requestMessage != null ||
                      widget.requests.requestMessage == ""
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border(
                            left: BorderSide(
                              color: Colors
                                  .grey, // Specify the color of the left border
                              width: 3, // Specify the width of the left border
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: widget.requests != null
                                    ? Text(
                                        widget.requests.requestMessage ?? '',
                                        softWrap: true,
                                      )
                                    : Text('No request message found'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              Stack(alignment: Alignment.center, children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        borderRadius: BorderRadius.circular(8),
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: InkWell(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: AppColor.primary,
                                        ),
                                      ],
                                    ),
                                  ));
                                },
                              );
                              api _api = api();
                              Post post = await _api.getPostById(
                                  widget.requests.exchangedPost.id!);
                              Navigator.pop(context);
                              if (post != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailsScreen(
                                      post: post,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Failed to load post')));
                              }
                            },
                            child: Image.network(
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                                      .toDouble()
                                              : null,
                                    ),
                                  );
                                }
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.error),
                              imageUrlExchanged,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        borderRadius: BorderRadius.circular(8),
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: InkWell(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: AppColor.primary,
                                        ),
                                      ],
                                    ),
                                  ));
                                },
                              );
                              api _api = api();
                              Post post = await _api.getPostById(
                                  widget.requests.requestedPost.id!);
                              print("Requested Post" + post.toString());
                              Navigator.pop(context);
                              if (post != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailsScreen(
                                      post: post,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Failed to load post')));
                              }
                            },
                            child: Image.network(
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                                      .toDouble()
                                              : null,
                                    ),
                                  );
                                }
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.error),
                              imageUrlRequested,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SvgPicture.asset(
                      'assets/repeat.svg',
                    ),
                  ),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.requests.status == 'accepted' ||
                              widget.requests.status == 'reviewed'
                          ? Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  (widget.requests.status != 'reviewed')
                                      ? Expanded(
                                          child: ElevatedButton(
                                            onPressed: (widget
                                                            .requests
                                                            .exchangedPost
                                                            .exchangedAt ==
                                                        null ||
                                                    (widget
                                                                .requests
                                                                .exchangedPost
                                                                .exchangedAt !=
                                                            null &&
                                                        (widget.currentUser !=
                                                                null
                                                            ? widget.currentUser!
                                                                    .id ==
                                                                widget
                                                                    .requests
                                                                    .requestedPost
                                                                    .userId
                                                            : false) &&
                                                        widget
                                                                .requests
                                                                .requestedPost
                                                                .exchangedAt !=
                                                            null))
                                                ? () async {
                                                    //push to ChatRoom screen
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ReviewScreen(
                                                          request:
                                                              widget.requests,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                : () => {},
                                            child: Text((widget
                                                            .requests
                                                            .exchangedPost
                                                            .exchangedAt ==
                                                        null ||
                                                    (widget
                                                                .requests
                                                                .exchangedPost
                                                                .exchangedAt !=
                                                            null &&
                                                        (widget.currentUser !=
                                                                null
                                                            ? widget.currentUser!
                                                                    .id ==
                                                                widget
                                                                    .requests
                                                                    .requestedPost
                                                                    .userId
                                                            : false) &&
                                                        widget
                                                                .requests
                                                                .requestedPost
                                                                .exchangedAt !=
                                                            null))
                                                ? 'Leave a Review'
                                                : "Reviewed"),
                                            style: ButtonStyle(
                                                side: MaterialStateProperty.all(
                                                  BorderSide(
                                                    color: (widget.requests.exchangedPost
                                                                    .exchangedAt ==
                                                                null ||
                                                            (widget
                                                                        .requests
                                                                        .exchangedPost
                                                                        .exchangedAt !=
                                                                    null &&
                                                                (widget.currentUser !=
                                                                        null
                                                                    ? widget.currentUser!
                                                                            .id ==
                                                                        widget
                                                                            .requests
                                                                            .requestedPost
                                                                            .userId
                                                                    : false) &&
                                                                widget
                                                                        .requests
                                                                        .requestedPost
                                                                        .exchangedAt !=
                                                                    null))
                                                        ? AppColor.primary
                                                        : Colors.grey,
                                                  ),
                                                ),
                                                foregroundColor: (widget
                                                                .requests
                                                                .exchangedPost
                                                                .exchangedAt ==
                                                            null ||
                                                        (widget
                                                                    .requests
                                                                    .exchangedPost
                                                                    .exchangedAt !=
                                                                null &&
                                                            (widget.currentUser != null
                                                                ? widget.currentUser!.id ==
                                                                    widget
                                                                        .requests
                                                                        .requestedPost
                                                                        .userId
                                                                : false) &&
                                                            widget
                                                                    .requests
                                                                    .requestedPost
                                                                    .exchangedAt !=
                                                                null))
                                                    ? MaterialStateProperty.all(
                                                        AppColor.primary)
                                                    : MaterialStateProperty.all(
                                                        Colors.grey)),
                                          ),
                                        )
                                      : Container(),
                                  widget.requests.status != 'reviewed'
                                      ? SizedBox(width: 8)
                                      : Container(),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (widget.requests.status ==
                                            'reviewed') {
                                          return;
                                        }
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatRoom(
                                              sender: widget.currentUser!,
                                              receiver:
                                                  widget.requests.requestedBy,
                                            ),
                                          ),
                                        );
                                      },
                                      child:
                                          widget.requests.status == 'reviewed'
                                              ? Text('Reviewed')
                                              : Text('Chat'),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              widget.requests.status ==
                                                      'reviewed'
                                                  ? MaterialStateProperty.all(
                                                      Colors.grey)
                                                  : MaterialStateProperty.all(
                                                      AppColor.primary),
                                          foregroundColor: widget
                                                      .requests.status ==
                                                  'reviewed'
                                              ? MaterialStateProperty.all(
                                                  Colors.black26)
                                              : MaterialStateProperty.all(
                                                  Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : (widget.currentUser != null)
                              ? widget.requests.requestedBy.id ==
                                      widget.currentUser!.id
                                  ? Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (await isConnected()) {
                                            api _api = api();
                                            String response =
                                                await _api.cancelRequest(
                                                    widget.requests.id);
                                            if (response == '200') {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Request Cancelled')));

                                              widget.onRequestUpdated();
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Failed to Cancel $response')));
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content:
                                                        Text('No Internet')));
                                          }
                                        },
                                        child: Text('Cancel'),
                                        style: ButtonStyle(
                                            side: MaterialStateProperty.all(
                                              BorderSide(
                                                  color: AppColor.secondary),
                                            ),
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    AppColor.secondary)),
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: OutlinedButton(
                                            onPressed: () async {
                                              if (await isConnected()) {
                                                api _api = api();
                                                String response =
                                                    await _api.rejectRequest(
                                                        widget.requests.id);
                                                if (response == '200') {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Request Rejected')));
                                                  widget.onRequestUpdated();
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Failed to accept $response')));
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'No Internet')));
                                              }
                                            },
                                            child: Icon(Icons.close),
                                            style: ButtonStyle(
                                              side: MaterialStateProperty.all(
                                                BorderSide(
                                                    color: AppColor.secondary),
                                              ),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      AppColor.secondary),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (await isConnected()) {
                                              api _api = api();
                                              String response =
                                                  await _api.acceptRequest(
                                                      widget.requests.id);
                                              if (response == '200') {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'Request Accepted')));
                                                widget.onRequestUpdated();
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'Failed to accept $response')));
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content:
                                                          Text('No Internet')));
                                            }
                                          },
                                          child: Icon(Icons.check),
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      AppColor.primary),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white)),
                                        ),
                                      ],
                                    )
                              : Container()
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
