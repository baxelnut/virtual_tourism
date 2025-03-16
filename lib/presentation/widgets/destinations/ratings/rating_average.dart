import 'package:flutter/material.dart';

import '../../../../core/global_values.dart';
import '../../../../services/firebase/api/reviews_service.dart';

class RatingAverage extends StatelessWidget {
  final String collectionId;
  final String destinationId;
  final Map<String, dynamic> destinationData;

  const RatingAverage({
    super.key,
    required this.collectionId,
    required this.destinationId,
    required this.destinationData,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);

    return FutureBuilder<double>(
      future: ReviewsService().getAverageRating(
        collectionId: collectionId,
        destinationId: destinationId,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error loading rating',
              style: theme.textTheme.bodyMedium);
        }

        double averageScore = destinationData['averageScore'] ?? 0;
        int totalRatings = destinationData['totalRatings'] ?? 0;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              averageScore.toString(),
              style: theme.textTheme.displayMedium,
            ),
            Text(
              "$totalRatings ratings",
              style: theme.textTheme.labelLarge,
            ),
          ],
        );
      },
    );
  }
}
