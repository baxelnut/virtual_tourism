import 'package:flutter/material.dart';

class RatingReviewerQty extends StatelessWidget {
  final List<int> ratings;
  const RatingReviewerQty({
    super.key,
    required this.ratings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(ratings.length, (index) {
        return Text(
          ratings[index] > 999 ? '999+' : ratings[index].toString(),
          style: theme.textTheme.titleMedium,
        );
      }),
    );
  }
}
