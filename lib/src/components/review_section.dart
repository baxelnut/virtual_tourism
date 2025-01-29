import 'package:flutter/material.dart';

class ReviewSection extends StatelessWidget {
  const ReviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

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
          SizedBox(
            width: screenSize.width,
            height: 100,
            child: Placeholder(),
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
}
