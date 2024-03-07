import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/res/health.dart';
import 'package:zwap_test/view/components/health_badge.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key});
  final int image = 0;
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
                                  'https://picsum.photos/seed/856/600',
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
                                      'Usman Ibrahim',
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Just Now',
                                      style: GoogleFonts.manrope(
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
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Container(
                                child: Wrap(
                                  children: <Widget>[
                                    ListTile(
                                      leading:
                                          Icon(Icons.favorite_border_rounded),
                                      title: Text('Add to favorites'),
                                      onTap: () => {},
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.copy),
                                      title: Text('Copy Link'),
                                      onTap: () => {},
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.flag_outlined,
                                        color: Colors.red,
                                      ),
                                      title: Text(
                                        'Report',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onTap: () => {},
                                    ),
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
                          child: PageView(
                            // controller: _model.pageViewController ??=
                            //     PageController(initialPage: 0),
                            // onPageChanged: (_) => setState(() {}),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            scrollDirection: Axis.horizontal,
                            children: [
                              Image.network(
                                'https://picsum.photos/seed/169/600',
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
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
                              ),
                              Image.network(
                                'https://picsum.photos/seed/144/900',
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
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
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.error),
                              ),
                              Image.network(
                                'https://picsum.photos/986/600',
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
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
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.error),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              ]),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HealthBadge(condition: Health.NEW),
                  Text(
                    'Valencia, Spain',
                    textAlign: TextAlign.end,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                    ),
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
                      'Sonic Black Headset',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w500,
                      ),
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
                          'Office Desk, Desk Frame, Office Chair',
                          style: GoogleFonts.manrope(
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
