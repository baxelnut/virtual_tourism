import 'package:flutter/material.dart';

import '../../components/content/load_image.dart';

class TourCard extends StatelessWidget {
  final String author;
  final String title;
  final String thumbnailUrl;
  final String userProfile;
  const TourCard({
    super.key,
    required this.author,
    required this.title,
    required this.thumbnailUrl,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;
    const String placeholderPath =
        'https://hellenic.org/wp-content/plugins/elementor/assets/images/placeholder.png';

    return SizedBox(
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
                  userProfile == "" ? placeholderPath : userProfile),
            ),
            title: Text(
              title,
              style: theme.textTheme.headlineSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              author,
              style: theme.textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
    );
  }
}
