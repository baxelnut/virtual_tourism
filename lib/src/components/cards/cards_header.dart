import 'package:flutter/material.dart';

import '../full_view_list.dart';

class CardsHeader extends StatelessWidget {
  final String cardsTitle;
  final List<Map<String, dynamic>>? destinationData;
  const CardsHeader({
    super.key,
    required this.cardsTitle,
    this.destinationData,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: cardsTitle != '',
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface,
                borderRadius: BorderRadius.circular(60),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  cardsTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.surface,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // showDialog(
              //     context: context,
              //     builder: (_) {
              //       print('navigate to full item list...bruh.');
              //       return AlertDialog(
              //         title: Text(
              //           cardsTitle,
              //         ),
              //       );
              //     });
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FullViewList(
                    cardsTitle: cardsTitle,
                    destinationData: destinationData,
                  ),
                ),
              );
            },
            child: Text(
              'See All',
              style: theme.textTheme.labelSmall?.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
