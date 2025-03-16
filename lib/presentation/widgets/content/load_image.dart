import 'package:flutter/material.dart';

class LoadImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;

  const LoadImage({
    super.key,
    required this.imagePath,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imagePath,
      fit: BoxFit.cover,
      width: width,
      height: height,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey,
          child: const Center(
            child: Icon(Icons.error, color: Colors.red),
          ),
        );
      },
    );
  }
}
