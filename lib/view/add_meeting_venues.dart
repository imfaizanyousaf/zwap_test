import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/global/commons/toast.dart';
import 'package:zwap_test/model/locations.dart';
import 'package:zwap_test/model/user.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/utils/connection.dart';
import 'package:zwap_test/view/components/buttons/primaryLarge.dart';
import 'package:zwap_test/view/home.dart';

class AddMeetingVenues extends StatefulWidget {
  final String previousScreen;
  List<int> initialSelectedItems = [];

  AddMeetingVenues({
    Key? key,
    required this.previousScreen,
  }) : super(key: key);

  @override
  _AddMeetingVenuesState createState() => _AddMeetingVenuesState();
}

class _AddMeetingVenuesState extends State<AddMeetingVenues> {
  List<int> locationsSelected = [];

  api user = api();
  bool connected = true;

  @override
  void initState() {
    super.initState();
    checkConnection();
    setInitialLocations();
  }

  void setInitialLocations() async {
    User currentUser = await user.getUser(null);
    List<Locations> locations = await user.getUserLocations(currentUser.id);
    if (mounted) {
      setState(() {
        locationsSelected = locations.map((e) => e.id!).toList();
      });
    }
  }

  void checkConnection() async {
    var connection = await isConnected();
    setState(() {
      connected = connection;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool savingLocations = false;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 48,
                      ),
                      Text(
                        widget.previousScreen == 'SignUpScreen'
                            ? 'Set Your Meeting Venues?'
                            : 'Edit Your Meeting Venues',
                        style: GoogleFonts.manrope(
                          textStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            letterSpacing: 0.15,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      Text(
                        widget.previousScreen == 'SignUpScreen'
                            ? 'You can always change these later.'
                            : 'This will help us recommend better products for you.',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.4285714286,
                          letterSpacing: 0.25,
                          color: Color(0xff5c5c5c),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      connected
                          ? FutureBuilder<List<Locations>>(
                              future: user.getLocations(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<Locations> locations = snapshot.data!;

                                  return Wrap(
                                    spacing:
                                        8.0, // Horizontal space between chips
                                    runSpacing:
                                        4.0, // Vertical space between lines
                                    children: locations.map((location) {
                                      bool isSelected = locationsSelected
                                          .contains(location.id!);
                                      return FilterChip(
                                        label: Text(
                                          location.name!,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.manrope(
                                            fontSize: 14,
                                            color: isSelected
                                                ? Colors.white
                                                : Color(0xff5c5c5c),
                                          ),
                                        ),
                                        checkmarkColor: Colors.white,
                                        selected: isSelected,
                                        selectedColor: AppColor.secondary,
                                        side: BorderSide(
                                          color: isSelected
                                              ? AppColor.secondary
                                              : Color(0xff5c5c5c),
                                        ),
                                        onSelected: (value) {
                                          setState(() {
                                            if (value) {
                                              locationsSelected
                                                  .add(location.id!);
                                            } else {
                                              locationsSelected
                                                  .remove(location.id!);
                                            }
                                          });
                                          print(locationsSelected);
                                        },
                                      );
                                    }).toList(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text("Error: ${snapshot.error}"),
                                  );
                                }
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            )
                          : Center(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.wifi_off,
                                      size: 56,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text('No Internet Connection'),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    TextButton(
                                        onPressed: checkConnection,
                                        child: Text('Retry'))
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            connected
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 32.0),
                    child: Row(
                      children: [
                        widget.previousScreen == 'SignUpScreen'
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.lightBlue,
                                ),
                                onPressed: () async {
                                  checkConnection();
                                  if (connected) {
                                    User currentUser = await user.getUser(null);

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                          currentUser: currentUser,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child:
                                    Text('Skip', style: GoogleFonts.manrope()),
                              )
                            : Container(),
                        SizedBox(
                            width: 16), // Add some spacing between the buttons
                        Expanded(
                          child: PrimaryLarge(
                            disabled:
                                (locationsSelected.isEmpty || savingLocations)
                                    ? true
                                    : false,
                            text: widget.previousScreen == 'SignUpScreen'
                                ? "Continue"
                                : "Save",
                            loading: savingLocations,
                            onPressed: (locationsSelected.isEmpty)
                                ? null
                                : () async {
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
                                              SizedBox(
                                                height: 16,
                                              ),
                                            ],
                                          ),
                                        ));
                                      },
                                    );

                                    setState(() {
                                      savingLocations = true;
                                    });
                                    checkConnection();
                                    if (connected) {
                                      User currentUser =
                                          await user.getUser(null);

                                      var response = await user.assignLocations(
                                          currentUser.id, locationsSelected);
                                      if (response == 200) {
                                        if (widget.previousScreen ==
                                            'ProfileScreen') {
                                          Navigator.pop(context);
                                        } else {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => HomeScreen(
                                                currentUser: currentUser,
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    } else {
                                      showToast(
                                          message: 'No Internet Connection');
                                    }
                                    setState(() {
                                      savingLocations = false;
                                    });
                                    Navigator.pop(context);
                                  },
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
