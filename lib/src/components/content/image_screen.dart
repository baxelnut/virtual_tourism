import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class ImageScreen extends StatelessWidget {
  final Image image;
  const ImageScreen({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PanoramaViewer(
        sensorControl: SensorControl.orientation,
        child: image,
      ),
    );
  }
}
