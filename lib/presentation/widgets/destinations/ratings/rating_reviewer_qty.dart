import 'package:flutter/material.dart';

import '../../../../core/global_values.dart';

class RatingReviewerQty extends StatelessWidget {
  final List<int> ratings;
  const RatingReviewerQty({
    super.key,
    required this.ratings,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
