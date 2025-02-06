import 'package:flutter/material.dart';

class ButtonWriteReview extends StatelessWidget {
  const ButtonWriteReview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: () {
        print('Write review clicked');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            Icons.rate_review_rounded,
            size: 20,
            color: theme.colorScheme.onPrimary,
          ),
          const SizedBox(width: 5),
          Text(
            'Review',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
