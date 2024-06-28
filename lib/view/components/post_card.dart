import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zwap_test/global/commons/toast.dart';
import 'package:zwap_test/model/post.dart';
import 'package:zwap_test/model/user.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/view/components/health_badge.dart';
import 'package:zwap_test/view/product_details.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:zwap_test/view/profile.dart';

class PostCard extends StatefulWidget {
  final User currentUser;
  final Post post;
  const PostCard({super.key, required this.post, required this.currentUser});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int image = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () {
                            if (widget.post.user != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                        currentUser: widget.post.user!)),
                              );
                            }
                          },
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
                                  widget.post.user!.logo ??
                                      'https://avatar.iran.liara.run/username?username=${widget.post.user!.firstName}+${widget.post.user!.lastName}',
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
                                    widget.post.user == null
                                        ? Text(widget.currentUser.firstName +
                                            ' ' +
                                            widget.currentUser.lastName)
                                        : Text(
                                            widget.post.user!.firstName +
                                                ' ' +
                                                widget.post.user!.lastName,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                    Text(
                                      timeago.format(widget.post.createdAt!),
                                      style: TextStyle(
                                        fontSize: 8,
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
                    IconButton(
                      icon: Icon(Icons.more_horiz),
                      onPressed: () async {
                        api user = api();
                        bool isFav = false;
                        List<Post> favPosts = await user.getFavPosts(
                          widget.currentUser.id,
                        );
                        for (Post post in favPosts) {
                          if (post.id == widget.post.id) {
                            setState(() {
                              isFav = true;
                            });
                          }
                        }

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Container(
                                child: Wrap(
                                  children: <Widget>[
                                    ListTile(
                                      leading: isFav
                                          ? Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : Icon(Icons.favorite_border_rounded),
                                      title: isFav
                                          ? Text('Remove from favorites')
                                          : Text('Add to favorites'),
                                      onTap: () async {
                                        api user = api();
                                        List<Post> oldFavPosts = await user
                                            .getFavPosts(widget.currentUser.id);
                                        List<int> oldFavPostIds = oldFavPosts
                                            .map((e) => e.id!)
                                            .toList();
                                        if (isFav) {
                                          oldFavPostIds.remove(widget.post.id);
                                        } else {
                                          oldFavPostIds.add(widget.post.id!);
                                        }
                                        String response = await user.addFavPost(
                                            widget.currentUser.id,
                                            oldFavPostIds);
                                        Navigator.pop(context);
                                        if (response == '200') {
                                          setState(() {
                                            isFav = !isFav;
                                          });
                                        }
                                      },
                                    ),
                                    widget.post.userId == widget.currentUser.id
                                        ? ListTile(
                                            leading: widget.post.userId ==
                                                    widget.currentUser.id
                                                ? Icon(
                                                    Icons.delete_outline,
                                                    color: const Color.fromRGBO(
                                                        244, 67, 54, 1),
                                                  )
                                                : Icon(
                                                    Icons.flag_outlined,
                                                    color: const Color.fromRGBO(
                                                        244, 67, 54, 1),
                                                  ),
                                            title: Text('Delete'),
                                            onTap: () async {
                                              api user = api();
                                              String response = await user
                                                  .deletePost(widget.post.id!);
                                              Navigator.pop(context);
                                              if (response == '200') {
                                                showToast(
                                                    message: "Post Deleted");
                                              }
                                            },
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Stack(alignment: Alignment.bottomCenter, children: [
                Container(
                  width: double.infinity,
                  height: 400,
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailsScreen(
                                              post: widget.post)));
                            },
                            child: PageView(
                              controller: _pageController,
                              onPageChanged: (e) => setState(() {
                                image = e;
                              }),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              scrollDirection: Axis.horizontal,
                              children: [
                                widget.post.imageUrls != null
                                    ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            (widget.post.imageUrls == null ||
                                                    widget.post.imageUrls!
                                                        .isEmpty ||
                                                    widget.post.imageUrls == [])
                                                ? 1
                                                : widget.post.imageUrls!.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            width: 400,
                                            height: 400,
                                            child: Image.network(
                                              (widget.post.imageUrls == null ||
                                                      widget.post.imageUrls!
                                                          .isEmpty ||
                                                      widget.post.imageUrls ==
                                                          [])
                                                  ? "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg"
                                                  : widget
                                                      .post.imageUrls![index],
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                } else {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }
                                              },
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Icon(Icons.error_outline),
                                            ),
                                          );
                                        },
                                      )
                                    : Text('no image')
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                widget.post.imageUrls != null
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            (widget.post.imageUrls == null ||
                                    widget.post.imageUrls!.isEmpty ||
                                    widget.post.imageUrls == [])
                                ? 1
                                : widget.post.imageUrls!.length,
                            (index) {
                              // this is the page indicator
                              return Container(
                                width: index == image ? 8 : 6,
                                height: index == image ? 8 : 6,
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index == image
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Container(),
              ]),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HealthBadge(
                      condition: widget.post.condition == null
                          ? 'New'
                          : widget.post.condition!.name),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        widget.post.locations != null
                            ? widget.post.locations![0].name
                            : '',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
                          child: SvgPicture.asset(
                            'assets/repeat.svg',
                          ),
                        ),
                        Text(
                          widget.post.description,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    )
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
