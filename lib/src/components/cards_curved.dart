import 'package:flutter/material.dart';

class CardsCurved extends StatefulWidget {
  final String title;
  final String subtitle;
  const CardsCurved({super.key, required this.title, required this.subtitle});

  @override
  State<CardsCurved> createState() => _CardsCurvedState();
}

class _CardsCurvedState extends State<CardsCurved> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 180,
      height: 320,
      decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(360),
              topRight: Radius.circular(360),
              bottomLeft: Radius.circular(60),
              bottomRight: Radius.circular(60))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(360),
                  color: Colors.amber),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              widget.subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          )
        ],
      ),
    );
  }
}
