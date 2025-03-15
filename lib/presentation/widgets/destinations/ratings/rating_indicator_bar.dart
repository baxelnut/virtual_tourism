import 'package:flutter/material.dart';

import '../../../../core/global_values.dart';

class RatingIndicatorBar extends StatelessWidget {
  final List<int> ratings;
  final int totalRatings;
  const RatingIndicatorBar({
    super.key,
    required this.ratings,
    required this.totalRatings,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);

    final percentages = ratings
        .map((count) => totalRatings > 0 ? (count / totalRatings) * 100 : 0.0)
        .toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(5, (index) {
        final percentage = percentages[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: SizedBox(
            width: 100 * (percentage / 100),
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(60),
              ),
            ),
          ),
        );
      }),
    );
  }
}
