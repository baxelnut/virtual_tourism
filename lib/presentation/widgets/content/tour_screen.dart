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
  int _panoIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hotspotData =
        widget.destinationData['hotspotData'] as Map<String, dynamic>;
    final hotspotKeys = hotspotData.keys.toList();

    double clampedLat =
        (hotspotData[hotspotKeys[_panoIndex]]['latitude'] ?? 0.0)
            .clamp(-90.0, 90.0);
    double clampedLon =
        (hotspotData[hotspotKeys[_panoIndex]]['longitude'] ?? 0.0) % 360;

    String? hotDesc =
        widget.destinationData['hotspotData']['hotspot$_panoIndex']['hotDesc'];
    double estimatedHeight = ((hotDesc?.length ?? 0) / 50).ceil() * 20.0;
    double maxHeight = 80085;

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
                        _panoIndex = ((_panoIndex + 1) %
                                widget.destinationData['hotspotData'].length)
                            .toInt();
                      }
                    }),
                  ),
                ),
              if (hotDesc != null)
                Hotspot(
                  latitude: clampedLat - 10,
                  longitude: clampedLon,
                  width: 300,
                  height: estimatedHeight.clamp(50, maxHeight),
                  widget: hotspotDescription(hotDesc: hotDesc),
                ),
            ],
            child: Image.network(
              hotspotData[hotspotKeys[_panoIndex]]['imagePath'],
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
              child: Text(
                text,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
      ],
    );
  }

  Widget hotspotDescription({
    required String hotDesc,
  }) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(4),
      ),
      child: SingleChildScrollView(
        child: Text(
          hotDesc,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 69,
        ),
      ),
    );
  }
}
