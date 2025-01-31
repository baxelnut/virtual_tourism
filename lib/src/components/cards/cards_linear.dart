import 'package:flutter/material.dart';

import '../content/load_image.dart';

class CardsLinear extends StatelessWidget {
  final String flag;
  final String country;
  final String thumbnailPath;
  final String imagePath;
  const CardsLinear({
    super.key,
    required this.country,
    required this.flag,
    required this.thumbnailPath,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: InkWell(
        onTap: () {
          // enter code here
        },
        child: Stack(
          children: [
            Container(
              width: screenSize.width / 3,
              height: screenSize.width / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LoadImage(
                  imagePath: thumbnailPath,
                  width: screenSize.width / 3,
                  height: screenSize.width / 2,
                ),
              ),
            ),
            Container(
              width: screenSize.width / 3,
              height: screenSize.width / 2,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff151515),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.0, 0.5],
                  tileMode: TileMode.clamp,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Text(
                '$flag\n$country',
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
