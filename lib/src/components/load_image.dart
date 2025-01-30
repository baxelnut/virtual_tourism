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
    return FutureBuilder(
      future: precacheImage(
        NetworkImage(
          imagePath,
        ),
        context,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Image.network(
            imagePath,
            fit: BoxFit.cover,
            width: width,
            height: height,
          );
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
    );
  }
}
