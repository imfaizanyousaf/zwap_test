import 'package:flutter/material.dart';
import 'package:zwap_test/model/categories.dart';
import 'package:zwap_test/model/post.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/view/components/post_card.dart';
import 'package:zwap_test/view/components/search_box.dart';

class SearchScreen extends StatelessWidget {
  final api userViewModel = api();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: SearchBox(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Container(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  FutureBuilder<List<Categories>>(
                    future: userViewModel.getCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                          children: snapshot.data!.map((category) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FilterChip(
                                label: Text(category.name!),
                                onSelected: (value) {
                                  searchQuery = category.name!;
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
            Expanded(
              child: FutureBuilder<List<Post>>(
                future: userViewModel.searchPosts(searchQuery),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
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
                  return Center(
                    child: CircularProgressIndicator(),
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
