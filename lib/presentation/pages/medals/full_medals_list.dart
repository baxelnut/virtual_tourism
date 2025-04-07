import 'package:flutter/material.dart';

import '../../../core/global_values.dart';
import 'medals_box.dart';

class FullMedalsList extends StatefulWidget {
  final String title;
  final Map<String, bool> medals;
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
      widget.medals.values.where((obtained) => obtained).length;
  int get notObtainedCount =>
      widget.medals.values.where((obtained) => !obtained).length;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);

    final sortedMedals = widget.medals.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

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
                  children: sortedMedals.map((entry) {
                    return MedalsBox(
                      medalName: entry.key,
                      isObtained: entry.value,
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
