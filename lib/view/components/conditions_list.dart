import 'package:flutter/material.dart';
import 'package:zwap_test/model/conditions.dart';
import 'package:zwap_test/utils/api.dart';
import 'package:zwap_test/view/components/health_badge.dart';

class ConditionsList extends StatefulWidget {
  @override
  _ConditionsListState createState() => _ConditionsListState();
}

class _ConditionsListState extends State<ConditionsList> {
  late Future<List<Conditions>> _conditionsFuture;
  List<Conditions> selectedItems = [];

  @override
  void initState() {
    super.initState();
    _conditionsFuture = api().getConditions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Conditions>>(
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
                return CheckboxListTile(
                  title: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child:
                            HealthBadge(condition: snapshot.data![index].name!),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(snapshot.data![index].description!),
                  ),
                  value: selectedItems.contains(snapshot.data![index]),
                  onChanged: (value) {
                    setState(() {
                      if (value != null && value) {
                        selectedItems.add(snapshot.data![index]);
                      } else {
                        selectedItems.remove(snapshot.data![index]);
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
    );
  }
}
