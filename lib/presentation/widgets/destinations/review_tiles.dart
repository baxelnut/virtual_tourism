import 'package:flutter/material.dart';

class ReviewTiles extends StatefulWidget {
  final String? userProfile;
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
  State<ReviewTiles> createState() => _ReviewTilesState();
}

class _ReviewTilesState extends State<ReviewTiles> {
  final String defaultProfile =
      'https://firebasestorage.googleapis.com/v0/b/virtual-tourism-7625f.appspot.com/o/users%2F.default%2Fprofile.png?alt=media&token=3471ca29-03b2-4bd7-a3fe-20dcc1810559';

  handleShowPict() {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: CircleAvatar(
            radius: 125,
            backgroundImage: NetworkImage(
              widget.userProfile ?? defaultProfile,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        dense: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              widget.userName,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.end,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: List.generate(
                widget.userRating,
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
            const SizedBox(height: 16),
            Text(
              widget.userComment,
              style: theme.textTheme.labelMedium,
              textAlign: TextAlign.end,
              maxLines: 69,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              widget.datePosted,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
        trailing: SizedBox(
          width: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => handleShowPict(),
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    widget.userProfile ?? defaultProfile,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
