import 'package:flutter/material.dart';
import 'package:zwap_test/model/conditions.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/components/health_badge.dart';

class ItemCondition extends StatefulWidget {
  final bool
      showAsChecklist; // Parameter to determine checklist or radio button
  final List<String> initialSelectedItems; // New parameter

  ItemCondition(
      {Key? key,
      this.showAsChecklist = false,
      required this.initialSelectedItems})
      : super(key: key);

  @override
  _ItemConditionState createState() => _ItemConditionState();
}

class _ItemConditionState extends State<ItemCondition> {
  late Future<List<Conditions>> _conditionsFuture;
  List<String> selectedItems = []; // List to hold selected items

  @override
  void initState() {
    super.initState();
    _conditionsFuture = api().getConditions();
    selectedItems = List.from(widget.initialSelectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: Text('Item Condition'),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            return;
          }
          if (context.mounted) {
            Navigator.pop(context, selectedItems);
          }
        },
        child: SingleChildScrollView(
          child: FutureBuilder<List<Conditions>>(
            future: _conditionsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return widget.showAsChecklist
                          ? CheckboxListTile(
                              title: Wrap(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: HealthBadge(
                                        condition: snapshot.data![index].name),
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(snapshot.data![index].description),
                              ),
                              value: selectedItems
                                  .contains(snapshot.data![index].name),
                              onChanged: (value) {
                                setState(() {
                                  if (value as bool) {
                                    selectedItems
                                        .add(snapshot.data![index].name);
                                  } else {
                                    selectedItems
                                        .remove(snapshot.data![index].name);
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            )
                          : RadioListTile(
                              title: Wrap(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: HealthBadge(
                                        condition: snapshot.data![index].name),
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(snapshot.data![index].description),
                              ),
                              value: snapshot.data![index].name,
                              groupValue: selectedItems.isNotEmpty
                                  ? selectedItems[0]
                                  : null,
                              onChanged: (value) {
                                setState(() {
                                  selectedItems = [value as String];
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
