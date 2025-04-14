import 'package:flutter/material.dart';

import '../../../core/global_values.dart';
import 'medals_box.dart';

class FullMedalsList extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> medals;
  const FullMedalsList({
    super.key,
    required this.title,
    required this.medals,
  });

  @override
  State<FullMedalsList> createState() => _FullMedalsListState();
}

class _FullMedalsListState extends State<FullMedalsList> {
  int get obtainedCount =>
      widget.medals.where((medal) => medal['obtained'] == true).length;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);

    final sortedMedals = [...widget.medals]
      ..sort((a, b) => a['id'].compareTo(b['id']));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text(widget.title),
            centerTitle: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Text(
                  '$obtainedCount/${widget.medals.length}',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: sortedMedals.map((medal) {
                    final isObtained = medal['obtained'] == true;
                    final medalId = medal['id'];

                    final fullInfo = medal['fullInfo'];
                    String displayName;

                    if (fullInfo is Map<String, dynamic>) {
                      displayName = fullInfo['artefactName'] ??
                          fullInfo['countryName'] ??
                          fullInfo['trivia']['question'] ??
                          medalId;
                    } else {
                      displayName = medalId;
                    }

                    return MedalsBox(
                      medalName: displayName,
                      isObtained: isObtained,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
