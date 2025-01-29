import 'package:flutter/material.dart';

class ReviewSection extends StatelessWidget {
  const ReviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final List<int> numbersData = [23, 5, 4, 2, 0];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 50),
            child: Text(
              'Rating & Reviews',
              style: theme.textTheme.headlineMedium,
            ),
          ),
          statsWidget(
            screenSize: screenSize,
            theme: theme,
            numbersData: numbersData,
          ),
          Row(
            children: [
              Text(
                'Write a review',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.rate_review_rounded,
                size: 22,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget statsWidget({
    required Size screenSize,
    required ThemeData theme,
    required List<int> numbersData,
  }) {
    return SizedBox(
      width: screenSize.width,
      height: 130,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          averageScore(
            theme: theme,
            numbersData: numbersData,
          ),
          Row(
            children: [
              starsOrder(),
              const SizedBox(width: 8),
              indicatorBar(
                theme: theme,
                numbersData: numbersData,
              ),
            ],
          ),
          reviewerQty(
            theme: theme,
            numbersData: numbersData,
          ),
        ],
      ),
    );
  }

  Widget averageScore({
    required ThemeData theme,
    required List<int> numbersData,
  }) {
    int totalStars = numbersData.reduce((a, b) => a + b); // total
    Map<int, int> starMap = {0: 5, 1: 4, 2: 3, 3: 2, 4: 1}; // mapping stars
    int weightedSum = 0; // weighted sum
    for (int i = 0; i < numbersData.length; i++) {
      weightedSum += starMap[i]! * numbersData[i];
    }
    // average score
    double starScore = totalStars > 0 ? weightedSum / totalStars : 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          starScore.toStringAsFixed(1),
          style: theme.textTheme.displayMedium,
        ),
        Text(
          '$totalStars ratings',
          style: theme.textTheme.labelMedium,
        ),
      ],
    );
  }

  Widget starsOrder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        5,
        (index) {
          int starCount = 5 - index;
          return Row(
            children: [
              ...List.generate(index, (i) => const SizedBox(width: 22)),
              ...List.generate(
                starCount,
                (i) => const Icon(
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

  Widget indicatorBar({
    required ThemeData theme,
    required List<int> numbersData,
  }) {
    int totalRatings = numbersData.reduce((a, b) => a + b);
    List<double> percentages = numbersData.map((count) {
      return totalRatings > 0 ? (count / totalRatings) * 100 : 0.0;
    }).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(5, (index) {
        double percentage = percentages[index];

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

  Widget reviewerQty({
    required List<int> numbersData,
    required ThemeData theme,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(numbersData.length, (index) {
        return Text(
          numbersData[index] > 999 ? '999+' : numbersData[index].toString(),
          style: theme.textTheme.titleMedium,
        );
      }),
    );
  }
}
