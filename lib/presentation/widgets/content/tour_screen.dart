import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

import '../../../core/global_values.dart';

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
  String placeholder = GlobalValues.placeholderPath;
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

    String hotDesc = widget.destinationData['hotspotData']['hotspot$_panoIndex']
            ['hotDesc'] ??
        "";
    String hotUrl = widget.destinationData['hotspotData']['hotspot$_panoIndex']
            ['hotUrl'] ??
        placeholder;

    double estimatedHeight = hotDesc.length * 1.0;
    double maxHeight = 1000;

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
              if (hotDesc != "")
                Hotspot(
                  latitude: clampedLat - 16,
                  longitude: clampedLon,
                  width: (hotUrl == placeholder ? 300 : 400),
                  height: estimatedHeight.clamp(
                      (hotUrl == placeholder ? 100 : 200), maxHeight),
                  widget: hotspotDescription(
                    hotDesc: hotDesc,
                    hotUrl: hotUrl,
                  ),
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
    required String hotUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(4),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                hotDesc,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 69,
              ),
              if (hotUrl != placeholder)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.network(
                    hotUrl,
                    fit: BoxFit.cover,
                    height: 150,
                    width: 330,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
