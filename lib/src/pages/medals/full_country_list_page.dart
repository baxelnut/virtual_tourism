import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/firebase/api/firebase_api.dart';

class FullCountryListPage extends StatefulWidget {
  final Map<String, bool> countries;

  const FullCountryListPage({super.key, required this.countries});

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
    final sortedCountries = countries.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final ThemeData theme = Theme.of(context);

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

class CountryBox extends StatefulWidget {
  final String countryName;
  final bool initialVisited;
  final ValueChanged<bool> onVisitedChanged;

  const CountryBox({
    super.key,
    required this.countryName,
    required this.initialVisited,
    required this.onVisitedChanged,
  });

  @override
  CountryBoxState createState() => CountryBoxState();
}

class CountryBoxState extends State<CountryBox> {
  late bool visited;

  @override
  void initState() {
    super.initState();
    visited = widget.initialVisited;
  }

  void toggleVisited() async {
    setState(() {
      visited = !visited;
    });

    widget.onVisitedChanged(visited);

    final firebaseApi = Provider.of<FirebaseApi>(context, listen: false);
    try {
      await firebaseApi.updateVisitedState(widget.countryName, visited);
    } catch (e) {
      setState(() {
        visited = !visited;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating state: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: toggleVisited,
      child: Container(
        height: 110,
        width: 110,
        decoration: BoxDecoration(
          color: visited ? Colors.green : Colors.amber[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            widget.countryName,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
