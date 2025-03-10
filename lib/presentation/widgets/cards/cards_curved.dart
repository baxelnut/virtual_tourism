import 'package:flutter/material.dart';

import '../../../core/global_values.dart';
import '../content/photographic_screen.dart';

class CardsCurved extends StatelessWidget {
  final Map<String, dynamic> destinationData;
  const CardsCurved({
    super.key,
    required this.destinationData,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);
    final Size screenSize = GlobalValues.screenSize(context);
    const String placeholderPath = GlobalValues.placeholderPath;

    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Container(
        width: screenSize.width / 1.9,
        height: screenSize.height / 2.5,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(360),
            topRight: Radius.circular(360),
            bottomLeft: Radius.circular(90),
            bottomRight: Radius.circular(90),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: InkWell(
                child: CircleAvatar(
                  radius: screenSize.width / 4,
                  backgroundImage: NetworkImage(
                    destinationData['thumbnailPath'] ?? placeholderPath,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PhotographicScreen(
                        imageUrl:
                            destinationData['imagePath'] ?? placeholderPath,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                destinationData['destination']
                        .split(' ')
                        .map((word) =>
                            '${word[0].toUpperCase()}${word.substring(1)}')
                        .join(' ')
                        .toUpperCase() ??
                    "No data",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 14, top: 5),
              child: Text(
                destinationData['description'] ?? "No description",
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
