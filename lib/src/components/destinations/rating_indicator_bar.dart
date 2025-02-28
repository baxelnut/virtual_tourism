import 'package:flutter/material.dart';

class RatingIndicatorBar extends StatelessWidget {
  final List<int> ratings;
  const RatingIndicatorBar({
    super.key,
    required this.ratings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final totalRatings = ratings.reduce((a, b) => a + b);
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
