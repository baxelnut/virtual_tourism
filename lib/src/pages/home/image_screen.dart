import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer%20copy.dart';

class ImageScreen extends StatelessWidget {
  final Image image;
  final dynamic appBarTitle;
  const ImageScreen(this.image, this.appBarTitle, {super.key});

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
