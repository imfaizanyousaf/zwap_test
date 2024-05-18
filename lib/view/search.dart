import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwap_test/model/categories.dart';
import 'package:zwap_test/model/post.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/view/components/post_card.dart';
import 'package:zwap_test/view/filters/sort_filter.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var filters = {
    "categories": [],
    "locations": [],
    "conditions": [],
    "isRecent": false,
    "isRelevant": false,
  };
  final api userViewModel = api();
  String searchQuery = "";
  List<String> categoriesSelected = [];
  bool isCategorySelected = false;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        surfaceTintColor: AppColor.background,
        backgroundColor:
            AppColor.background, // You can set the background color here
        elevation: 0, // No shadow
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Color.fromARGB(
                  65, 0, 0, 0), // You can set the border color here
              width: 1.6, // You can set the border width here
            ),
          ),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  searchQuery = "";
                });
              } else {
                setState(() {
                  searchQuery = value;
                });
              }
            },
            decoration: InputDecoration(
              hintText: 'Search Items',
              hintStyle: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.0,
                letterSpacing: 0.25,
                color: Color(0xff5c5c5c),
              ),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              suffixIcon: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () async {
                  var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SortFilter(initialFilters: filters)));
                  setState(() {
                    filters = result;
                    categoriesSelected = filters["categories"] as List<String>;
                  });
                  print(filters["categories"].toString() == "[]");
                },
                child: Icon(
                  Icons.tune_rounded,
                  color: (filters["categories"].toString() == "[]" &&
                          filters["locations"].toString() == "[]" &&
                          filters["conditions"].toString() == "[]" &&
                          filters["isRecent"] == false &&
                          filters["isRelevant"] == false)
                      ? Colors.black
                      : AppColor.secondary, // Default color
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    FutureBuilder<List<Categories>>(
                      future: userViewModel.getCategories(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // Separate the categories into selected and unselected
                          List<Categories> selectedCategories = snapshot.data!
                              .where((category) =>
                                  categoriesSelected.contains(category.name))
                              .toList();
                          List<Categories> unselectedCategories = snapshot.data!
                              .where((category) =>
                                  !categoriesSelected.contains(category.name))
                              .toList();

                          // Combine them with selected categories first
                          List<Categories> orderedCategories = [
                            ...selectedCategories,
                            ...unselectedCategories
                          ];

                          return Row(
                            children: orderedCategories.map((category) {
                              bool isSelected =
                                  categoriesSelected.contains(category.name);
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: FilterChip(
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
                                        categoriesSelected.add(category.name!);
                                      } else {
                                        categoriesSelected
                                            .remove(category.name!);
                                      }
                                      filters["categories"] =
                                          categoriesSelected;
                                    });
                                  },
                                ),
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
                    ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding:
            //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            //   child: Row(
            //     children: [
            //       Text(
            //         "$itemsFound Search results for $searchQuery",
            //       ),
            //     ],
            //   ),
            // ),
            Expanded(
              child: FutureBuilder<List<Post>>(
                future:
                    userViewModel.searchPosts(searchQuery, categoriesSelected),
                builder: (context, snapshot) {
                  if (searchQuery.isEmpty && categoriesSelected.isEmpty) {
                    return Center(
                      child: Text("Search for items"),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: Text("No items found for your search criteria."),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return PostCard(post: snapshot.data![index]);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }

                  // This case should be handled if there is no data and no error
                  return Center(
                    child: Text("Unexpected state."),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
