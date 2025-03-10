import 'package:flutter/material.dart';

import '../../widgets/cards/more_button.dart';
import '../../widgets/content/load_image.dart';
import '../../widgets/destinations/destination_overview.dart';

class ContentTiles extends StatelessWidget {
  final Map<String, dynamic> destinationData;
  const ContentTiles({
    super.key,
    required this.destinationData,
  });

  String getImagePath(String placeholderPath) {
    return destinationData["thumbnailPath"] ??
        destinationData["hotspotData"]?["hotspot0"]?["imagePath"] ??
        placeholderPath;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;
    const String placeholderPath =
        'https://hellenic.org/wp-content/plugins/elementor/assets/images/placeholder.png';

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
              _buildImage(getImagePath(placeholderPath)),
              const SizedBox(width: 14),
              _buildTextContent(theme, screenSize),
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

  Widget _buildTextContent(ThemeData theme, Size screenSize) {
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

  Widget _buildHeader(ThemeData theme) {
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
          ),
        ],
      ),
    );
  }

  Widget _buildStats(ThemeData theme, Size screenSize) {
    final stats = [
      {'icon': Icons.star, 'value': '3.3'},
      {'icon': Icons.comment, 'value': '4'},
      {'icon': Icons.remove_red_eye_rounded, 'value': '10'},
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

  Widget _buildText(String text, TextStyle? style, {EdgeInsets? padding}) {
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
