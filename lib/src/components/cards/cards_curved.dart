import 'package:flutter/material.dart';
import 'package:virtual_tourism/src/components/content/photographic_screen.dart';

class CardsCurved extends StatelessWidget {
  final String destination;
  final String description;
  final String thumbnailPath;
  final String imagePath;
  const CardsCurved(
      {super.key,
      required this.destination,
      required this.description,
      required this.thumbnailPath,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
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
                bottomRight: Radius.circular(90))),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: InkWell(
                child: CircleAvatar(
                  radius: screenSize.width / 4,
                  backgroundImage: NetworkImage(thumbnailPath),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PhotographicScreen(
                        imageUrl: imagePath,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                destination.toUpperCase(),
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
                description,
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
