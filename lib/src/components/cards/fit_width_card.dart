import 'package:flutter/material.dart';
import '../../components/content/load_image.dart';
import '../../components/destinations/destination_overview.dart';

class FitWidthCard extends StatelessWidget {
  final String userProfile;
  final Map<String, dynamic> destinationData;
  const FitWidthCard({
    super.key,
    required this.userProfile,
    required this.destinationData,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    const String placeholderPath =
        'https://hellenic.org/wp-content/plugins/elementor/assets/images/placeholder.png';
    String? fallbackThumbnailPath =
        destinationData['hotspotData']?['hotspot0']?['thumbnailPath'];
    String thumbnailUrl = (destinationData['thumbnailPath'] == null ||
            destinationData['thumbnailPath'].isEmpty)
        ? (fallbackThumbnailPath ?? '')
        : destinationData['thumbnailPath'];
    String title = destinationData['destinationName'] ?? 'Unknown';
    String subtitle = (destinationData['userName'] != null)
        ? destinationData['userName']
        : "basilius tengang";

    return GestureDetector(
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
        height: 300,
        width: screenSize.width,
        child: Column(
          children: [
            LoadImage(
              imagePath: thumbnailUrl == "" ? placeholderPath : thumbnailUrl,
              width: screenSize.width,
              height: 200,
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  userProfile == "" ? placeholderPath : userProfile,
                ),
              ),
              title: Text(
                title,
                style: theme.textTheme.headlineSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                subtitle,
                style: theme.textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Icon(Icons.more_vert_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
