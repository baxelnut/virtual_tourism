import 'package:flutter/material.dart';

import '../../../core/global_values.dart';
import 'country_box.dart';

class FullCountryListPage extends StatefulWidget {
  final Map<String, bool> countries;

  const FullCountryListPage({
    super.key,
    required this.countries,
  });

  @override
  FullCountryListPageState createState() => FullCountryListPageState();
}

class FullCountryListPageState extends State<FullCountryListPage> {
  late Map<String, bool> countries;

  @override
  void initState() {
    super.initState();
    countries = {...widget.countries};
  }

  int get visitedCount => countries.values.where((visited) => visited).length;
  int get unvisitedCount =>
      countries.values.where((visited) => !visited).length;

  void updateCountry(String countryName, bool visited) {
    setState(() {
      countries[countryName] = visited;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);

    final sortedCountries = countries.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Passport'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Text(
              '$visitedCount/${countries.length}',
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: sortedCountries.map((entry) {
              return CountryBox(
                countryName: entry.key,
                initialVisited: entry.value,
                onVisitedChanged: (visited) {
                  updateCountry(entry.key, visited);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
