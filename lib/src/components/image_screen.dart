import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class ImageScreen extends StatelessWidget {
  final Image image;
  final String appBarTitle;
  const ImageScreen(
      {super.key, required this.image, required this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: PanoramaViewer(
        child: image,
      ),
    );
  }
}
