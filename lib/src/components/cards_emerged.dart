import 'package:flutter/material.dart';

import '../pages/home/image_screen.dart';

class CardsEmerged extends StatelessWidget {
  final String country;
  final String destination;
  final String thumbnailPath;
  final String imagePath;
  const CardsEmerged(
      {super.key,
      required this.country,
      required this.destination,
      required this.thumbnailPath,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Stack(
        children: [
          Container(
            width: screenSize.width / 2,
            height: screenSize.width / 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                thumbnailPath,
                fit: BoxFit.cover,
                width: screenSize.width / 2,
                height: screenSize.width / 2,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            width: screenSize.width / 2,
            height: screenSize.width / 2,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.black,
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 10,
              right: 10,
              child: ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.all(0),
                  minVerticalPadding: 0,
                  title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.location_on_rounded,
                                color: theme.colorScheme.surface,
                                size: 16,
                              ),
                            ),
                            Text(
                              country,
                              overflow: TextOverflow.visible,
                              maxLines: 2,
                              style: theme.textTheme.labelMedium
                                  ?.copyWith(color: theme.colorScheme.surface),
                            )
                          ],
                        ),
                        Text(
                          destination,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.surface,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 8),
                          child: Container(
                            width: screenSize.width,
                            height: 30,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.surface
                                      .withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(360),
                            ),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      theme.colorScheme.onSecondary,
                                  backgroundColor: theme.colorScheme.secondary,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ImageScreen(
                                        image: Image.network(imagePath),
                                        appBarTitle: destination,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Visit')),
                          ),
                        ),
                      ],
                    ),
                  ))),
        ],
      ),
    );
  }
}
