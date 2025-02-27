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
  // bool _showDebugInfo = false;
  // double _lon = 0;
  // double _lat = 0;
  // double _tilt = 0;
  int _panoId = 0;

  // void onViewChanged(longitude, latitude, tilt) {
  //   setState(() {
  //     _lon = longitude;
  //     _lat = latitude;
  //     _tilt = tilt;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final hotspotData =
        widget.destinationData['hotspotData'] as Map<String, dynamic>;
    final hotspotKeys = hotspotData.keys.toList();

    return Scaffold(
      body: Stack(
        children: [
          PanoramaViewer(
            animSpeed: .1,
            sensorControl: SensorControl.orientation,
            // onViewChanged: onViewChanged,
            hotspots: hotspotKeys.asMap().entries.map((entry) {
              String key = entry.value;
              final hotspot = hotspotData[key];

              return Hotspot(
                latitude: hotspot['latitude'] ?? 0.0,
                longitude: hotspot['longitude'] ?? 0.0,
                width: 90,
                height: 80,
                widget: hotspotButton(
                  text: "Next scene",
                  icon: Icons.double_arrow,
                  onPressed: () => setState(() {
                    if (widget.destinationData['hotspotData'].isNotEmpty) {
                      _panoId = ((_panoId + 1) %
                              widget.destinationData['hotspotData'].length)
                          .toInt();
                    }
                  }),
                ),
              );
            }).toList(),
            child: Image.network(
              hotspotData[hotspotKeys[_panoId]]['imagePath'],
              fit: BoxFit.cover,
            ),
          ),
          // if (_showDebugInfo)
          //   Positioned(
          //     bottom: 10,
          //     left: 10,
          //     child: Text(
          //       '${_lon.toStringAsFixed(3)}, ${_lat.toStringAsFixed(3)}, ${_tilt.toStringAsFixed(3)}',
          //       style: const TextStyle(
          //         backgroundColor: Colors.black54,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       _showDebugInfo = !_showDebugInfo;
      //     });
      //   },
      //   child: Icon(_showDebugInfo ? Icons.visibility_off : Icons.visibility),
      // ),
    );
  }

  Widget hotspotButton(
      {String? text, IconData? icon, VoidCallback? onPressed}) {
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
        text != null
            ? Container(
                padding: const EdgeInsets.all(4.0),
                decoration: const BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: Center(
                  child: Text(
                    text,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
