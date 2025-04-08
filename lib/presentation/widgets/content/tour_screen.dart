import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

import '../../../core/global_values.dart';
import '../../../services/gamification/gamification_service.dart';

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
  bool _hasObtainedArtefact = false;

  final GamificationService _gamificationService = GamificationService();

  @override
  void initState() {
    super.initState();
    checkIfArtefactObtained();
  }

  Future<void> checkIfArtefactObtained() async {
    final userId = GlobalValues.user?.uid;
    final destinationId = widget.destinationData['docId'];
    if (userId == null || destinationId == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final data = userDoc.data();
      final artefacts =
          Map<String, dynamic>.from(data?['artefactAcquired'] ?? {});

      if (artefacts.containsKey(destinationId)) {
        setState(() {
          _hasObtainedArtefact = true;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error checking artefact on TourScreen: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);

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
              if (widget.destinationData['artefact'] != null &&
                  widget.destinationData['artefact']['sceneIndex'] ==
                      _panoIndex &&
                  !_hasObtainedArtefact)
                Hotspot(
                  latitude: widget.destinationData['artefact']['lat'] ?? 69.69,
                  longitude: widget.destinationData['artefact']['lon'] ?? 69.69,
                  width: 100,
                  height: 100,
                  widget: GestureDetector(
                    onTap: () async {
                      final userId = GlobalValues.user?.uid;
                      final destinationId = widget.destinationData['docId'];
                      if (userId == null || destinationId == null) return;

                      setState(() {
                        _hasObtainedArtefact = true;
                      });

                      final artefactData = {
                        "artefactName": widget.destinationData['artefact']
                            ['name'],
                        "destinationId": destinationId,
                        "destinationName": widget.destinationData['name'],
                        "givenBy": widget.destinationData['userName'],
                        "timeAcquired": DateTime.now()
                            .toIso8601String()
                            .replaceAll(':', '')
                            .replaceAll('-', '')
                            .replaceAll('.', '')
                            .replaceAll('T', '_')
                            .substring(0, 15),
                      };

                      print(destinationId);

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .set({
                        "artefactAcquired": {
                          destinationId: artefactData,
                        }
                      }, SetOptions(merge: true));

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
