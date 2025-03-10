import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/global_values.dart';
import '../../../services/firebase/api/firebase_api.dart';
import '../../pages/medals/full_country_list_page.dart';

class MedalsCards extends StatefulWidget {
  final String title;
  final Map<String, bool> countries;

  const MedalsCards({
    super.key,
    required this.title,
    required this.countries,
  });

  @override
  MedalsCardsState createState() => MedalsCardsState();
}

class MedalsCardsState extends State<MedalsCards> {
  late Map<String, bool> countries;

  @override
  void initState() {
    super.initState();
    countries = {...widget.countries};
  }

  int get visitedCount => countries.values.where((visited) => visited).length;

  int get totalCount => countries.length;

  void toggleCountryVisited(String countryName) async {
    final firebaseApi = Provider.of<FirebaseApi>(context, listen: false);
    final newVisited = !countries[countryName]!;
    setState(() {
      countries[countryName] = newVisited;
    });

    try {
      await firebaseApi.updatePassportStatus(countryName, newVisited);
    } catch (e) {
      setState(() {
        countries[countryName] = !newVisited;
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
    final ThemeData theme = GlobalValues.theme(context);
    final Size screenSize = GlobalValues.screenSize(context);

    return Column(
      children: [
        buildHeader(
          title: widget.title,
          progress: '$visitedCount/$totalCount',
          screenSize: screenSize,
          theme: theme,
          context: context,
        ),
        buildCountryCards(
          screenSize: screenSize,
          theme: theme,
          context: context,
        ),
      ],
    );
  }

  Widget buildHeader({
    required String title,
    required String progress,
    required Size screenSize,
    required ThemeData theme,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FullCountryListPage(countries: countries),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        width: screenSize.width,
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium,
              ),
            ),
            Text(
              progress,
              style: theme.textTheme.bodyLarge,
            ),
            const Icon(Icons.keyboard_arrow_right_rounded),
          ],
        ),
      ),
    );
  }

  Widget buildCountryCards({
    required Size screenSize,
    required ThemeData theme,
    required BuildContext context,
  }) {
    final visited = countries.entries.where((entry) => entry.value).toList();
    final notVisited =
        countries.entries.where((entry) => !entry.value).toList();

    visited.sort((a, b) => a.key.compareTo(b.key));
    notVisited.sort((a, b) => a.key.compareTo(b.key));

    final topCountries = [
      ...visited,
      ...notVisited,
    ].take(6).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      width: screenSize.width,
      child: Center(
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: topCountries.map((entry) {
            return GestureDetector(
              onTap: () => toggleCountryVisited(entry.key),
              child: buildCountryCard(entry.key, entry.value, theme),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildCountryCard(String countryName, bool visited, ThemeData theme) {
    return Container(
      height: 110,
      width: 110,
      decoration: BoxDecoration(
        color: visited ? Colors.green : Colors.amber[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          countryName,
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
