import 'package:flutter/material.dart';

class NewsContent extends StatelessWidget {
  const NewsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            'Breaking News',
            style: theme.textTheme.displayMedium,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
