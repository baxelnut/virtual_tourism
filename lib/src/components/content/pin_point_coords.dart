import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class PinPointCoords extends StatefulWidget {
  final Image image;
  final Function(double, double) onCoordinatesSelected;
  const PinPointCoords({
    super.key,
    required this.image,
    required this.onCoordinatesSelected,
  });

  @override
  State<PinPointCoords> createState() => _PinPointCoordsState();
}

class _PinPointCoordsState extends State<PinPointCoords> {
  double _lon = 0;
  double _lat = 0;

  void onViewChanged(longitude, latitude, tilt) {
    setState(() {
      _lon = longitude;
      _lat = latitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          PanoramaViewer(
            animSpeed: .1,
            sensorControl: SensorControl.orientation,
            onViewChanged: onViewChanged,
            child: widget.image,
          ),
          Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSecondary,
                borderRadius: BorderRadius.circular(360),
              ),
              child: Icon(
                Icons.add_sharp,
                color: theme.colorScheme.secondary,
                size: 35,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: screenSize.width,
                height: 300,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'longitude: ${_lon.toStringAsFixed(1)}\nlatitude: ${_lat.toStringAsFixed(1)}',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    backgroundColor: theme.colorScheme.surface,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onCoordinatesSelected(_lon, _lat);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                ),
                child: SizedBox(
                  width: screenSize.width / 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_rounded,
                        color: theme.colorScheme.onPrimary,
                      ),
                      Text(
                        'Confirm',
                        style: theme.textTheme.bodyLarge,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
