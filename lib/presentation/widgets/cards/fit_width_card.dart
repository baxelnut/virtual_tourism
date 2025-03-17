import 'package:flutter/material.dart';

import '../../../core/global_values.dart';
import '../content/load_image.dart';
import '../destinations/destination_overview.dart';
import 'more_button.dart';

class FitWidthCard extends StatefulWidget {
  final String userProfile;
  final Map<String, dynamic> destinationData;
  const FitWidthCard({
    super.key,
    required this.userProfile,
    required this.destinationData,
  });

  @override
  State<FitWidthCard> createState() => _FitWidthCardState();
}

class _FitWidthCardState extends State<FitWidthCard> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);
    final Size screenSize = GlobalValues.screenSize(context);
    const String placeholderPath = GlobalValues.placeholderPath;

    String? fallbackThumbnailPath =
        widget.destinationData['hotspotData']?['hotspot0']?['thumbnailPath'];
    String thumbnailUrl = (widget.destinationData['thumbnailPath'] == null ||
            widget.destinationData['thumbnailPath'].isEmpty)
        ? (fallbackThumbnailPath ?? '')
        : widget.destinationData['thumbnailPath'];
    String title = widget.destinationData['destinationName'] ?? 'Unknown';
    String subtitle = (widget.destinationData['userName'] != null)
        ? widget.destinationData['userName']
        : "basilius tengang";

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DestinationOverview(
              destinationData: widget.destinationData,
            ),
          ),
        );
      },
      child: SizedBox(
        width: screenSize.width,
        child: Column(
          children: [
            LoadImage(
              imagePath: thumbnailUrl == "" ? placeholderPath : thumbnailUrl,
              width: screenSize.width,
              height: 225,
            ),
            ListTile(
              leading: CircleAvatar(
                maxRadius: 20,
                backgroundImage: NetworkImage(
                  widget.userProfile == ""
                      ? placeholderPath
                      : widget.userProfile,
                ),
              ),
              title: Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 18,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  subtitle,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              trailing: MoreButton(
                isAdmin: false,
                destinationData: widget.destinationData,
              ),
              contentPadding: EdgeInsets.only(left: 24, right: 6),
            ),
          ],
        ),
      ),
    );
  }
}
