import 'package:flutter/material.dart';

import '../../../core/global_values.dart';
import '../../widgets/cards/more_button.dart';
import '../../widgets/content/load_image.dart';
import '../../widgets/destinations/destination_overview.dart';

class ContentTiles extends StatelessWidget {
  final Map<String, dynamic> destinationData;
  const ContentTiles({
    super.key,
    required this.destinationData,
  });

  String getImagePath() {
    final String? mainThumbnail = destinationData['thumbnailPath'];
    final String? hotspotThumbnail =
        destinationData['hotspotData']?['hotspot0']?['thumbnailPath'];
    const String placeholderPath = GlobalValues.placeholderPath;

    if (mainThumbnail != null && mainThumbnail.isNotEmpty) {
      return mainThumbnail;
    } else if (hotspotThumbnail != null && hotspotThumbnail.isNotEmpty) {
      return hotspotThumbnail;
    } else {
      return placeholderPath;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);
    final Size screenSize = GlobalValues.screenSize(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DestinationOverview(
              destinationData: destinationData,
            ),
          ),
        ),
        child: SizedBox(
          height: 110,
          width: screenSize.width,
          child: Row(
            children: [
              _buildImage(
                getImagePath(),
              ),
              const SizedBox(width: 14),
              _buildTextContent(
                theme,
                screenSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: LoadImage(
        imagePath: imagePath,
        width: 100,
        height: 100,
      ),
    );
  }

  Widget _buildTextContent(
    ThemeData theme,
    Size screenSize,
  ) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          _buildStats(theme, screenSize),
          _buildText(
            "${destinationData['category']} • ${destinationData['subcategory']}",
            theme.textTheme.labelSmall,
            padding: const EdgeInsets.only(right: 24, bottom: 8),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              destinationData['destinationName'],
              style: theme.textTheme.headlineSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          MoreButton(
            isAdmin: true,
            destinationData: destinationData,
          ),
        ],
      ),
    );
  }

  Widget _buildStats(
    ThemeData theme,
    Size screenSize,
  ) {
    double averageScore = destinationData['averageScore'] ?? 0;
    int totalRatings = destinationData['totalRatings'] ?? 0;
    dynamic totalHotspot = destinationData['hotspotData'].isEmpty
        ? 1
        : destinationData['hotspotData'].length;

    final stats = [
      {'icon': Icons.star, 'value': averageScore.toString()},
      {'icon': Icons.comment, 'value': totalRatings.toString()},
      {'icon': Icons.location_on_rounded, 'value': totalHotspot.toString()},
    ];

    return SizedBox(
      width: screenSize.width / 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: stats.map(
          (stat) {
            return Row(
              children: [
                Icon(
                  stat['icon'] as IconData,
                  size: 16,
                  color: theme.colorScheme.onSurface,
                ),
                const SizedBox(width: 4),
                Text(
                  stat['value'].toString(),
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }

  Widget _buildText(
    String text,
    TextStyle? style, {
    EdgeInsets? padding,
  }) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Text(
        text,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
