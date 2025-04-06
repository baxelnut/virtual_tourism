import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/global_values.dart';
import 'photographic_screen.dart';

class Thumbnail extends StatelessWidget {
  final Map<String, dynamic> destinationData;
  const Thumbnail({
    super.key,
    required this.destinationData,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = GlobalValues.screenSize(context).width;
    String placeholderPath = GlobalValues.placeholderPath;

    double thumbWidth = screenWidth;
    if (kIsWeb) {
      thumbWidth = 300;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: InkWell(
        child: Image.asset(
          destinationData['thumbnailPath'] ?? placeholderPath,
          cacheWidth: thumbWidth.toInt(),
          cacheHeight: (thumbWidth ~/ 2),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PhotographicScreen(
                destinationData: destinationData,
              ),
            ),
          );
        },
      ),
    );
  }
}
