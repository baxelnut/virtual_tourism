import 'package:flutter/material.dart';

class ButtonShare extends StatelessWidget {
  const ButtonShare({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: () {
        print('Share clicked');
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
            Icons.share_rounded,
            size: 20,
            color: theme.colorScheme.onPrimary,
          ),
          const SizedBox(width: 5),
          Text(
            'Share',
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
