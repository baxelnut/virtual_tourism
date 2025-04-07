import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

import '../../../core/global_values.dart';
import '../../../services/gamification/gamification_service.dart';

class PhotographicScreen extends StatefulWidget {
  final Map<String, dynamic> destinationData;
  const PhotographicScreen({
    super.key,
    required this.destinationData,
  });

  @override
  State<PhotographicScreen> createState() => _PhotographicScreenState();
}

class _PhotographicScreenState extends State<PhotographicScreen> {
  String placeholderPath = GlobalValues.placeholderPath;
  bool _isLoading = true;
  Image? _loadedImage;

  final GamificationService _gamificationService = GamificationService();

  @override
  void initState() {
    super.initState();

    _loadedImage =
        Image.network(widget.destinationData['imagePath'] ?? placeholderPath);

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
    final ThemeData theme = GlobalValues.theme(context);

    return Scaffold(
      body: Stack(
        children: [
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (!_isLoading)
            Center(
              child: PanoramaViewer(
                sensorControl: SensorControl.orientation,
                hotspots: [
                  if (widget.destinationData['artefact'] != null)
                    Hotspot(
                      latitude: widget.destinationData['artefact']['lat'] ?? 69,
                      longitude:
                          widget.destinationData['artefact']['lon'] ?? 69,
                      width: 100,
                      height: 100,
                      widget: GestureDetector(
                        onTap: () {
                          _gamificationService.announce(
                            destinationData: widget.destinationData,
                          );
                          _gamificationService.updateUserStats(
                            destinationData: widget.destinationData,
                          );
                        },
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(100, 0, 0, 0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.diamond_outlined,
                                size: 30,
                                color: Colors.amber,
                              ),
                              Text(
                                widget.destinationData['artefact']['name'] ??
                                    "Virgin Oil (Extra)",
                                style: theme.textTheme.titleMedium,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
                child: _loadedImage!,
              ),
            ),
        ],
      ),
    );
  }
}
