import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/model/request.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:zwap_test/model/user.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/utils/connection.dart';
import 'package:zwap_test/view/components/health_badge.dart';
import 'package:zwap_test/view/home.dart';
import 'package:zwap_test/view/requests.dart';

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

  void getRequestedToName() async {
    api _api = api();
    User requestedTo = await _api.getUser(widget.requests.requestedPost.userId);
    if (mounted) {
      setState(() {
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
                          child: Image.network(
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                                .toDouble()
                                        : null,
                                  ),
                                );
                              }
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.error),
                            'https://picsum.photos/1080/1080',
                            fit: BoxFit.cover,
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
                          child: Image.network(
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                                .toDouble()
                                        : null,
                                  ),
                                );
                              }
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.error),
                            'https://picsum.photos/1080/1080',
                            fit: BoxFit.cover,
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
                      widget.requests.status == 'accepted'
                          ? Expanded(
                              child: ElevatedButton(
                                onPressed: () async {},
                                child: Text('Chat'),
                                style: ButtonStyle(
                                    side: MaterialStateProperty.all(
                                      BorderSide(color: AppColor.primary),
                                    ),
                                    foregroundColor: MaterialStateProperty.all(
                                        AppColor.primary)),
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
                                            onPressed: () {
                                              // Close button logic
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
