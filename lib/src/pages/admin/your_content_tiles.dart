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
        height: 110,
        width: screenSize.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destinationData['category'],
                    style: theme.textTheme.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    destinationData['destinationName'],
                    style: theme.textTheme.headlineSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    destinationData['userId'],
                    style: theme.textTheme.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    destinationData['userEmail'],
                    style: theme.textTheme.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// SizedBox(
//         width: screenSize.width,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: LoadImage(
//                 imagePath: destinationData["thumbnailPath"] ?? placeholderPath,
//                 width: 100,
//                 height: 100,
//               ),
//             ),
//             Text(
//               destinationData['category'],
//               style: theme.textTheme.labelMedium,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             Text(
//               destinationData['destinationName'],
//               style: theme.textTheme.headlineSmall,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//             Text(
//               destinationData['userId'],
//               style: theme.textTheme.labelLarge,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             Text(
//               destinationData['userEmail'],
//               style: theme.textTheme.labelLarge,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
