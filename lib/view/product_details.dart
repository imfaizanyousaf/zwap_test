import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/global/commons/toast.dart';
import 'package:zwap_test/model/post.dart';
import 'package:zwap_test/model/user.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/view/components/health_badge.dart';
import 'package:zwap_test/view/edit_profile.dart';
import 'package:zwap_test/view/exchange_screen.dart';
import 'package:zwap_test/view/new_post.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProductDetailsScreen extends StatefulWidget {
  final Post post;

  ProductDetailsScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final List<String> images = [
    'https://picsum.photos/986/600',
    'https://picsum.photos/986/600',
    'https://picsum.photos/986/600',
  ];
  bool isFav = false;
  User? currentUser;
  void _showLoadingDialog() {
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
  }

  Future<void> getCurrentUser() async {
    try {
      _showLoadingDialog();
      api _api = api();
      User temp = await _api.getUser(null);
      List<Post> favPosts = await _api.getFavPosts(
        temp.id,
      );
      for (Post post in favPosts) {
        if (post.id == widget.post.id) {
          if (mounted) {
            setState(() {
              isFav = true;
            });
          }
        }
      }
      if (mounted) {
        setState(() {
          currentUser = temp;
        });
      }
    } catch (e) {
      showToast(message: 'Failed to get user data');
    } finally {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentUser();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
            ),
            expandedHeight: MediaQuery.of(context).size.height * 0.5,
            backgroundColor: Colors.white,
            elevation: 0.0,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: widget.post.imageUrls != null
                  ? PageView.builder(
                      itemCount: widget.post.imageUrls!.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          widget.post.imageUrls![index],
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.network(
                      'https://picsum.photos/986/600',
                      fit: BoxFit.cover,
                    ),
              stretchModes: const [
                StretchMode.blurBackground,
                StretchMode.zoomBackground,
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    images.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        margin: const EdgeInsets.all(4.0),
                        width: 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == 0 ? Colors.black : Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Text(
                                timeago.format(widget.post.createdAt!),
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: () async {
                                  api user = api();
                                  List<Post> oldFavPosts =
                                      await user.getFavPosts(currentUser!.id);
                                  List<int> oldFavPostIds =
                                      oldFavPosts.map((e) => e.id!).toList();
                                  if (isFav) {
                                    oldFavPostIds.remove(widget.post.id);
                                  } else {
                                    oldFavPostIds.add(widget.post.id!);
                                  }
                                  String response = await user.addFavPost(
                                      currentUser!.id, oldFavPostIds);
                                  if (response == '200') {
                                    setState(() {
                                      isFav = !isFav;
                                    });
                                  }
                                },
                                child: isFav
                                    ? Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : Icon(
                                        Icons.favorite_border,
                                        color: AppColor.primary,
                                      ),
                              )
                            ],
                          ),
                        ),
                        Text(
                          widget.post.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[200],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  HealthBadge(
                                      condition: widget.post.condition!.name),
                                  SizedBox(height: 8),
                                  Text(
                                    widget.post.condition!.description,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColor.background,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Exchange With',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    widget.post.description,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColor.background,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Categories',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  widget.post.categories! != [] &&
                                          widget.post.categories!.isNotEmpty
                                      ? Row(
                                          children: widget.post.categories!
                                              .map((category) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: FilterChip(
                                                label: Text(
                                                  category.name!,
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.manrope(
                                                    fontSize: 14,
                                                    color: Color(0xff5c5c5c),
                                                  ),
                                                ),
                                                checkmarkColor: Colors.white,
                                                selectedColor:
                                                    AppColor.secondary,
                                                side: BorderSide(
                                                  color: Color(0xff5c5c5c),
                                                ),
                                                onSelected: (value) {},
                                              ),
                                            );
                                          }).toList(),
                                        )
                                      : Text(
                                          'Not Specified',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColor.background,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Meeting Venue',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  widget.post.locations! != [] &&
                                          widget.post.locations!.isNotEmpty
                                      ? Text(
                                          widget.post.locations!
                                              .map((e) => e.name)
                                              .join(', '),
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        )
                                      : Text(
                                          'Not Specified',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundImage:
                                        AssetImage('assets/avatar.jpg'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            widget.post.user!.firstName +
                                                ' ' +
                                                widget.post.user!.lastName,
                                            style: GoogleFonts.getFont(
                                              "Manrope",
                                              textStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                height: 1.2,
                                                letterSpacing: 0.150000006,
                                                color: Color(0xff000000),
                                              ),
                                            )),
                                        Text('@faizan.usuf',
                                            style: GoogleFonts.getFont(
                                              "Manrope",
                                              textStyle: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                height: 1.6,
                                                letterSpacing: 0.150000006,
                                                color: Color.fromARGB(
                                                    255, 71, 71, 71),
                                              ),
                                            )),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              OutlinedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            AppColor.primary)),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfileScreen()),
                                  );
                                },
                                child: (currentUser != null &&
                                        widget.post.userId != currentUser!.id)
                                    ? Text('Follow')
                                    : Text('Edit Profile'),
                                // child: Icon(Icons.message),
                              ),
                            ],
                          ),
                        ),
                        if (currentUser != null &&
                            widget.post.userId != currentUser!.id)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                backgroundColor:
                                    MaterialStateProperty.all(AppColor.primary),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                              ),
                              onPressed: () async {
                                api user = api();
                                User currentUser = await user.getUser(null);
                                List<Post> userPosts =
                                    await user.getPostsByUser(currentUser.id);
                                if (userPosts.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:
                                            Text("No Posts to Exchange With"),
                                        content: Text(
                                            "You don't have any posts to exchange with this post."),
                                        actions: [
                                          TextButton(
                                            style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(AppColor.primary),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Cancel"),
                                          ),
                                          TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(AppColor.primary),
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NewPostScreen(
                                                          currentUser:
                                                              currentUser,
                                                        )),
                                              );
                                            },
                                            child: Text("Create Post"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ExchangeScreen(
                                              requestedPost: widget.post,
                                            )),
                                  );
                                }
                              },
                              child: Center(
                                // Center the text inside the button
                                child: Text("Offer an Exchange"),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
