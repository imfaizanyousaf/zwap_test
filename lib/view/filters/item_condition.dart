import 'package:flutter/material.dart';
import 'package:zwap_test/model/conditions.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/res/colors/colors.dart';
import 'package:zwap_test/view/components/health_badge.dart';

class ItemCondition extends StatefulWidget {
  final bool
      showAsChecklist; // Parameter to determine checklist or radio button
  final List<String> initialSelectedItems;
  final bool returnConditions;

  ItemCondition(
      {Key? key,
      this.showAsChecklist = false,
      this.returnConditions = false,
      required this.initialSelectedItems})
      : super(key: key);

  @override
  _ItemConditionState createState() => _ItemConditionState();
}

class _ItemConditionState extends State<ItemCondition> {
  late Future<List<Conditions>> _conditionsFuture;
  List<dynamic> selectedItems = []; // List to hold selected items

  @override
  void initState() {
    super.initState();
    _conditionsFuture = api().getConditions();
    if (widget.returnConditions) {
      setInitialConditions();
    } else {
      selectedItems = List.from(widget.initialSelectedItems);
    }
  }

  setInitialConditions() async {
    selectedItems = await _conditionsFuture.then(
      (value) => value
          .where((condition) =>
              widget.initialSelectedItems.contains(condition.name))
          .toList(),
    );
  }

  Future<bool?> _showExitDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Discard Selection?'),
          content: const Text(
              'Are you sure you want to exit without selecting any items?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
          bool shouldPop = true;
          if (selectedItems.isNotEmpty) {
            shouldPop = await _showExitDialog() ?? false;
          }
          if (context.mounted && shouldPop) {
            Navigator.pop(
              context,
              widget.returnConditions
                  ? (selectedItems.map((item) => item as Conditions).toList())
                  : selectedItems.map((e) => e.toString()).toList(),
            );
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
                              value: selectedItems.contains(
                                  widget.returnConditions
                                      ? snapshot.data![index]
                                      : snapshot.data![index].name),
                              onChanged: (value) {
                                setState(() {
                                  if (value as bool) {
                                    selectedItems.add(widget.returnConditions
                                        ? snapshot.data![index]
                                        : snapshot.data![index].name);
                                  } else {
                                    selectedItems.remove(widget.returnConditions
                                        ? snapshot.data![index]
                                        : snapshot.data![index].name);
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
                              value: widget.returnConditions
                                  ? snapshot.data![index]
                                  : snapshot.data![index].name,
                              groupValue: selectedItems.isNotEmpty
                                  ? selectedItems[0]
                                  : null,
                              onChanged: (value) {
                                setState(() {
                                  if (widget.returnConditions) {
                                    selectedItems = [value];
                                  } else {
                                    selectedItems = [value.toString()];
                                  }
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
      floatingActionButton: selectedItems.isNotEmpty
          ? FloatingActionButton(
              onPressed: () async {
                Navigator.pop(
                    context,
                    widget.returnConditions
                        ? (selectedItems
                            .map((item) => item as Conditions)
                            .toList())
                        : selectedItems.map((e) => e.toString()).toList());
              },
              child: Icon(Icons.check, color: AppColor.background),
              backgroundColor: AppColor.primary,
            )
          : null,
    );
  }
}
