import 'package:flutter/material.dart';

import '../../../core/global_values.dart';
import '../../../services/gamification/gamification_service.dart';
import 'full_medals_list.dart';

class MedalsSection extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> medals;
  const MedalsSection({
    super.key,
    required this.title,
    required this.medals,
  });

  @override
  State<MedalsSection> createState() => _MedalsSectionState();
}

class _MedalsSectionState extends State<MedalsSection> {
  final GamificationService gamificationService = GamificationService();

  int get obtainedMedals =>
      widget.medals.where((entry) => entry['obtained'] == true).length;
  int get totalMedals => widget.medals.length;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);
    final Size screenSize = GlobalValues.screenSize(context);

    return Column(
      children: [
        sectionHeader(
          title: widget.title,
          progress: '$obtainedMedals/$totalMedals',
          screenSize: screenSize,
          theme: theme,
        ),
        sectionCards(
          screenSize: screenSize,
          theme: theme,
        )
      ],
    );
  }

  Widget sectionHeader({
    required String title,
    required String progress,
    required Size screenSize,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullMedalsList(
              title: widget.title,
              medals: widget.medals,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        width: screenSize.width,
        child: Row(
          children: [
            Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
            Text(progress, style: theme.textTheme.bodyMedium),
            const Icon(Icons.keyboard_arrow_right_rounded),
          ],
        ),
      ),
    );
  }

  Widget sectionCards({
    required Size screenSize,
    required ThemeData theme,
  }) {
    final obtained =
        widget.medals.where((entry) => entry['obtained'] == true).toList();
    final notObtained =
        widget.medals.where((entry) => entry['obtained'] != true).toList();

    obtained.sort((a, b) => a['id'].compareTo(b['id']));
    notObtained.sort((a, b) => a['id'].compareTo(b['id']));

    final showFirstCards = [
      ...obtained,
      ...notObtained,
    ].take(6).toList();

    // print(showFirstCards);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      width: screenSize.width,
      child: Center(
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: showFirstCards.map((entry) {
            final medalId = entry['id'];
            final isObtained = entry['obtained'] == true;

            final fullInfo = entry['fullInfo'];
            String displayName;

            if (fullInfo is Map<String, dynamic>) {
              displayName = fullInfo['artefactName'] ??
                  fullInfo['countryName'] ??
                  medalId;
            } else {
              displayName = medalId;
            }

            return GestureDetector(
              onTap: () {
                // print("Clicked $displayName");
              },
              child: Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  color: isObtained
                      ? theme.colorScheme.primary
                      : theme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    displayName,
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
