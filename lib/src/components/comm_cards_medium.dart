import 'package:flutter/material.dart';

import 'load_image.dart';

class CommCardsMedium extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  const CommCardsMedium({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(left: 6, bottom: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: screenSize.width / 1.5,
          height: screenSize.width / 3,
          color: theme.colorScheme.secondary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LoadImage(
                imagePath: imagePath,
                width: screenSize.width / 3 - 20,
                height: screenSize.width / 3,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        subtitle,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
