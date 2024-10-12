import 'package:flutter/material.dart';

class CardsHeader extends StatelessWidget {
  final String cardsTitle;
  const CardsHeader({super.key, required this.cardsTitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(60)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  cardsTitle,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: theme.colorScheme.surface),
                ),
              )),
          GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text(cardsTitle),
                      );
                    });
              },
              child: Text(
                'See All',
                style: theme.textTheme.labelSmall
                    ?.copyWith(decoration: TextDecoration.underline),
              ))
        ],
      ),
    );
  }
}
