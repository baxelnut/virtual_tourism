import 'package:flutter/material.dart';
import 'package:virtual_tourism/src/components/destinations/destination_overview.dart';

import '../../components/content/load_image.dart';

class YourContentTiles extends StatelessWidget {
  final Map<String, dynamic> destinationData;
  const YourContentTiles({
    super.key,
    required this.destinationData,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;
    const String placeholderPath =
        'https://hellenic.org/wp-content/plugins/elementor/assets/images/placeholder.png';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DestinationOverview(
                destinationData: destinationData,
              ),
            ),
          );
        },
        child: SizedBox(
          height: 110,
          width: screenSize.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LoadImage(
                  imagePath: destinationData["thumbnailPath"].isEmpty
                      ? placeholderPath
                      : destinationData["thumbnailPath"],
                  width: 100,
                  height: 100,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            destinationData['destinationName'],
                            style: theme.textTheme.headlineSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.more_vert_rounded,
                              size: 20,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStats(
                      avgRating: 3.3,
                      totalReviews: 4,
                      totalView: 10,
                      theme: theme,
                      screenSize: screenSize,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 24, bottom: 8),
                      child: Text(
                        "${destinationData['category']} • ${destinationData['subcategory']}",
                        style: theme.textTheme.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStats({
    required double avgRating,
    required int totalReviews,
    required int totalView,
    required ThemeData theme,
    required Size screenSize,
  }) {
    return SizedBox(
      width: screenSize.width / 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.star,
            size: 16,
            color: theme.colorScheme.onSurface,
          ),
          Text(
            avgRating.toString(),
          ),
          Icon(
            Icons.comment,
            size: 16,
            color: theme.colorScheme.onSurface,
          ),
          Text(
            totalReviews.toString(),
          ),
          Icon(
            Icons.remove_red_eye_rounded,
            size: 16,
            color: theme.colorScheme.onSurface,
          ),
          Text(
            totalView.toString(),
          ),
        ],
      ),
    );
  }
}
