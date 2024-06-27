import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/global/commons/toast.dart';
import 'package:zwap_test/model/categories.dart';
import 'package:zwap_test/model/user.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/utils/connection.dart';
import 'package:zwap_test/view/add_locations.dart';
import 'package:zwap_test/view/components/buttons/primaryLarge.dart';
import 'package:zwap_test/view/home.dart';

class AddInterestsScreen extends StatefulWidget {
  final String previousScreen;
  List<int> initialSelectedItems = [];

  AddInterestsScreen({
    Key? key,
    required this.previousScreen,
  }) : super(key: key);

  @override
  _AddInterestsScreenState createState() => _AddInterestsScreenState();
}

class _AddInterestsScreenState extends State<AddInterestsScreen> {
  List<int> categoriesSelected = [];

  api user = api();
  bool connected = true;

  @override
  void initState() {
    super.initState();
    checkConnection();
    setInitialCategories();
  }

  void setInitialCategories() async {
    User currentUser = await user.getUser(null);
    List<Categories> categories = await user.getUserIntersts(currentUser.id);
    if (mounted) {
      setState(() {
        categoriesSelected = categories.map((e) => e.id!).toList();
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
    bool savingCategories = false;
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
                            ? 'What are your interests?'
                            : 'Edit your interests',
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
                          ? FutureBuilder<List<Categories>>(
                              future: user.getCategories(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<Categories> categories = snapshot.data!;

                                  return Wrap(
                                    spacing:
                                        8.0, // Horizontal space between chips
                                    runSpacing:
                                        4.0, // Vertical space between lines
                                    children: categories.map((category) {
                                      bool isSelected = categoriesSelected
                                          .contains(category.id!);
                                      return FilterChip(
                                        label: Text(
                                          category.name!,
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
                                              categoriesSelected
                                                  .add(category.id!);
                                            } else {
                                              categoriesSelected
                                                  .remove(category.id!);
                                            }
                                          });
                                          print(categoriesSelected);
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
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddLocationsScreen(
                                        previousScreen: "SignUpScreen",
                                      ),
                                    ),
                                  );
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
                                (categoriesSelected.isEmpty || savingCategories)
                                    ? true
                                    : false,
                            text: widget.previousScreen == 'SignUpScreen'
                                ? "Continue"
                                : "Save",
                            loading: savingCategories,
                            onPressed: (categoriesSelected.isEmpty)
                                ? null
                                : () async {
                                    setState(() {
                                      savingCategories = true;
                                    });
                                    checkConnection();
                                    if (connected) {
                                      User currentUser =
                                          await user.getUser(null);

                                      var response =
                                          await user.assignCategories(
                                              currentUser.id,
                                              categoriesSelected);
                                      if (response == 200) {
                                        if (widget.previousScreen ==
                                            'ProfileScreen') {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        } else {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddLocationsScreen(
                                                previousScreen: "SignUpScreen",
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
                                      savingCategories = false;
                                    });
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
