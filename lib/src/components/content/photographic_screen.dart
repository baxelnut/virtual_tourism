import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class PhotographicScreen extends StatefulWidget {
  final String imageUrl;
  const PhotographicScreen({
    super.key,
    required this.imageUrl,
  });

  @override
  State<PhotographicScreen> createState() => _PhotographicScreenState();
}

class _PhotographicScreenState extends State<PhotographicScreen> {
  bool _isLoading = true;
  Image? _loadedImage;

  @override
  void initState() {
    super.initState();

    _loadedImage = Image.network(widget.imageUrl);

    final ImageStream stream = _loadedImage!.image.resolve(
      const ImageConfiguration(),
    );

    stream.addListener(
      ImageStreamListener((
        ImageInfo info,
        bool synchronousCall,
      ) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (!_isLoading)
            Center(
              child: PanoramaViewer(
                sensorControl: SensorControl.orientation,
                child: _loadedImage!,
              ),
            ),
        ],
      ),
    );
  }
}
