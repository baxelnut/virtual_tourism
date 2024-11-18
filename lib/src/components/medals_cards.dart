import 'package:flutter/material.dart';

class MedalsCards extends StatelessWidget {
  final String title;
  final String progress;
  final String medalName;
  const MedalsCards({
    super.key,
    required this.title,
    required this.progress,
    required this.medalName,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    return Column(
      children: [
        buildHeader(
          title: title,
          progress: progress,
          screenSize: screenSize,
          theme: theme,
        ),
        buildCards(
          medalName: medalName,
          screenSize: screenSize,
          theme: theme,
        ),
      ],
    );
  }

  Widget buildHeader({
    required String title,
    required String progress,
    required Size screenSize,
    required ThemeData theme,
  }) {
    return Container(
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
            style: theme.textTheme.bodyMedium,
          ),
          const Icon(Icons.keyboard_arrow_right_rounded)
        ],
      ),
    );
  }

  Widget buildCards({
    required String medalName,
    required Size screenSize,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      width: screenSize.width,
      child: Row(
        children: [
          SizedBox(
            height: 170,
            width: 120,
            child: Column(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(child: Text('insert image here')),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    medalName,
                    style: theme.textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
