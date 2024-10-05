import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../pages/home/image_screen.dart';

class Thumbnail extends StatelessWidget {
  final String imagePath;
  final String thumbPath;
  const Thumbnail(
      {required this.imagePath, required this.thumbPath, super.key});

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
              builder: (context) => ImageScreen(
                  image: Image.asset(imagePath),
                  appBarTitle: imagePath
                      .split('/')
                      .last
                      .split('.')
                      .first
                      .toUpperCase()
                      .replaceAll('_', ' ')),
            ),
          );
        },
      ),
    );
  }
}
