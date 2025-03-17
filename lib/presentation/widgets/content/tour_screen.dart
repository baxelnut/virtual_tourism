import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class TourScreen extends StatefulWidget {
  final Map<String, dynamic> destinationData;
  const TourScreen({
    super.key,
    required this.destinationData,
  });

  @override
  State<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen> {
  int _panoId = 0;

  @override
  Widget build(BuildContext context) {
    final hotspotData =
        widget.destinationData['hotspotData'] as Map<String, dynamic>;
    final hotspotKeys = hotspotData.keys.toList();

    double clampedLat = (hotspotData[hotspotKeys[_panoId]]['latitude'] ?? 0.0)
        .clamp(-90.0, 90.0);
    double clampedLon =
        (hotspotData[hotspotKeys[_panoId]]['longitude'] ?? 0.0) % 360;

    return Scaffold(
      body: Stack(
        children: [
          PanoramaViewer(
            animSpeed: .1,
            sensorControl: SensorControl.orientation,
            hotspots: [
              if (hotspotData.isNotEmpty && hotspotKeys.isNotEmpty)
                Hotspot(
                  latitude: clampedLat,
                  longitude: clampedLon,
                  width: 90,
                  height: 80,
                  widget: hotspotButton(
                    text: "Next Scene",
                    icon: Icons.double_arrow,
                    onPressed: () => setState(() {
                      if (widget.destinationData['hotspotData'].isNotEmpty) {
                        _panoId = ((_panoId + 1) %
                                widget.destinationData['hotspotData'].length)
                            .toInt();
                      }
                    }),
                  ),
                ),
            ],
            child: Image.network(
              hotspotData[hotspotKeys[_panoId]]['imagePath'],
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget hotspotButton({
    String? text,
    IconData? icon,
    VoidCallback? onPressed,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(const CircleBorder()),
            backgroundColor: WidgetStateProperty.all(Colors.black38),
            foregroundColor: WidgetStateProperty.all(Colors.white),
          ),
          onPressed: onPressed,
          child: Icon(icon),
        ),
        if (text != null)
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: const BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Center(
              child: Text(text, textAlign: TextAlign.center),
            ),
          ),
      ],
    );
  }
}
