import 'package:flutter/material.dart';

class ReviewSection extends StatelessWidget {
  const ReviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final List<int> ratings = [23, 5, 4, 2, 0];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 50),
            child: Text(
              'Rating & Reviews',
              style: theme.textTheme.headlineSmall,
            ),
          ),
          _buildRatingStat(
            screenSize,
            theme,
            ratings,
          ),
          _buildReviewWidget(
            screenSize,
            theme,
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
            ),
            child: Icon(
              Icons.comment,
              size: 22,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewWidget(
    Size screenSize,
    ThemeData theme,
  ) {
    return Column(
      children: [
        Text(
          'X reviews',
          style: theme.textTheme.titleSmall,
        ),
        ListTile(
          trailing: const CircleAvatar(
            radius: 24,
          ),
          title: Text(
            '50 Cent',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.end,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'this app is so good! will definitely recommend to my homies and ops❤️',
                style: theme.textTheme.labelMedium,
                textAlign: TextAlign.end,
              ),
              const SizedBox(height: 5),
              Text(
                '30 Jan 2025',
                style: theme.textTheme.labelMedium,
              ),
            ],
          ),
        ),
        ListTile(
          trailing: const CircleAvatar(
            radius: 24,
          ),
          title: Text(
            '50 Cent',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.end,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'this app is so good! will definitely recommend to my homies and ops❤️',
                style: theme.textTheme.labelMedium,
                textAlign: TextAlign.end,
              ),
              const SizedBox(height: 5),
              Text(
                '30 Jan 2025',
                style: theme.textTheme.labelMedium,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildRatingStat(
    Size screenSize,
    ThemeData theme,
    List<int> ratings,
  ) {
    return SizedBox(
      width: screenSize.width,
      height: 130,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildAverageScore(theme, ratings),
          Row(
            children: [
              _buildStarsOrder(),
              const SizedBox(width: 8),
              _buildIndicatorBar(theme: theme, ratings: ratings),
            ],
          ),
          _buildReviewerQty(theme, ratings),
        ],
      ),
    );
  }

  Widget _buildAverageScore(ThemeData theme, List<int> ratings) {
    final totalRatings = ratings.reduce((a, b) => a + b);
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
          style: theme.textTheme.labelMedium,
        ),
      ],
    );
  }

  Widget _buildStarsOrder() {
    return Column(
      children: List.generate(
        5,
        (index) {
          final starCount = 5 - index;
          return Row(
            children: [
              ...List.generate(index, (_) => const SizedBox(width: 22)),
              ...List.generate(
                starCount,
                (_) => const Icon(
                  Icons.star_rate,
                  size: 22,
                  color: Colors.amber,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildReviewerQty(ThemeData theme, List<int> ratings) {
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

  Widget _buildIndicatorBar({
    required ThemeData theme,
    required List<int> ratings,
  }) {
    final totalRatings = ratings.reduce((a, b) => a + b);
    final percentages = ratings
        .map((count) => totalRatings > 0 ? (count / totalRatings) * 100 : 0.0)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(5, (index) {
        final percentage = percentages[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(
            width: 100 * (percentage / 100),
            child: Container(
              height: 8,
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
