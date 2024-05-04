import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/components/buttons/primaryLarge.dart';
import 'package:zwap_test/view/components/health_badge.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({super.key});
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
                          child: Icon(
                            Icons.call_received,
                            color: AppColor.primary,
                            size: 16,
                          ),
                        ),
                        Text(
                          '2hrs ago',
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
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border(
                      left: BorderSide(
                        color:
                            Colors.grey, // Specify the color of the left border
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
                          child: Text(
                            'Hi! I would like to exchange your Canon  EOS-1DX Mark III with my Nikon EDS Mark III. If you need further details you can chat with me',
                            softWrap: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                      OutlinedButton(
                        onPressed: () {
                          // Chat button logic
                        },
                        child: Icon(Icons.chat),
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(
                            BorderSide(color: AppColor.primary),
                          ),
                          foregroundColor:
                              MaterialStateProperty.all(AppColor.primary),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: OutlinedButton(
                              onPressed: () {
                                // Close button logic
                              },
                              child: Icon(Icons.close),
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                  BorderSide(color: AppColor.secondary),
                                ),
                                foregroundColor: MaterialStateProperty.all(
                                    AppColor.secondary),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Check button logic
                            },
                            child: Icon(Icons.check),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(AppColor.primary),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                          ),
                        ],
                      )
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
