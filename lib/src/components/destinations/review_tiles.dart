import 'package:flutter/material.dart';

class ReviewTiles extends StatelessWidget {
  final String userProfile;
  final String userName;
  final int userRating;
  final String userComment;
  final String datePosted;
  const ReviewTiles({
    super.key,
    required this.userProfile,
    required this.userName,
    required this.userRating,
    required this.userComment,
    required this.datePosted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        dense: true,
        
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              userName,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.end,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: List.generate(
                userRating,
                (index) => const Icon(
                  Icons.star_rate,
                  size: 18,
                  color: Colors.amber,
                ),
              ),
            )
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              userComment,
              style: theme.textTheme.labelMedium,
              textAlign: TextAlign.end,
            ),
            const SizedBox(height: 8),
            Text(
              datePosted,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
        trailing: CircleAvatar(
          radius: 16,
          backgroundImage: NetworkImage(userProfile),
        ),
      ),
    );
  }
}
