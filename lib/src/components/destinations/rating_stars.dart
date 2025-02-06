import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({super.key});

  @override
  Widget build(BuildContext context) {
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
}
