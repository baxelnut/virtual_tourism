import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'photographic_screen.dart';

class Thumbnail extends StatelessWidget {
  final String imagePath;
  final String thumbPath;
  const Thumbnail({
    super.key,
    required this.imagePath,
    required this.thumbPath,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double thumbWidth = screenWidth;
    if (kIsWeb) {
      thumbWidth = 300;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: InkWell(
        child: Image.asset(
          thumbPath,
          cacheWidth: thumbWidth.toInt(),
          cacheHeight: (thumbWidth ~/ 2),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PhotographicScreen(
                imageUrl: imagePath,
              ),
            ),
          );
        },
      ),
    );
  }
}
