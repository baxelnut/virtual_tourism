import 'package:flutter/material.dart';

import '../../../../core/global_values.dart';

class RatingAverage extends StatelessWidget {
  final List<int> ratings;
  final int totalRatings;
  const RatingAverage({
    super.key,
    required this.ratings,
    required this.totalRatings,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);

    final starMap = {0: 5, 1: 4, 2: 3, 3: 2, 4: 1};
    int weightedSum = 0;

    for (int i = 0; i < ratings.length; i++) {
      weightedSum += starMap[i]! * ratings[i];
    }

    final averageScore = totalRatings > 0 ? weightedSum / totalRatings : 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          averageScore.toStringAsFixed(1),
          style: theme.textTheme.displayMedium,
        ),
        Text(
          '$totalRatings ratings',
          style: theme.textTheme.labelLarge,
        ),
      ],
    );
  }
}
