import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool _hasObtainedArtefact = false;
  String? destinationId;

  @override
  void initState() {
    super.initState();

    destinationId = widget.destinationData['docId'];

    _loadedImage = Image.network(
      widget.destinationData['imagePath'] ?? placeholderPath,
    );

    _loadedImage!.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((info, _) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }),
    );

    checkIfArtefactObtained();
  }

  Future<void> checkIfArtefactObtained() async {
    final userId = GlobalValues.user?.uid;
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
      print("Error checking artefact: $e");
    }
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
                  if (widget.destinationData['artefact'] != null &&
                      !_hasObtainedArtefact)
                    Hotspot(
                      latitude:
                          widget.destinationData['artefact']['lat'] ?? 69.69,
                      longitude:
                          widget.destinationData['artefact']['lon'] ?? 69.69,
                      width: 100,
                      height: 100,
                      widget: GestureDetector(
                        onTap: () async {
                          final userId = GlobalValues.user?.uid;
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

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .set({
                            "artefactAcquired": {
                              destinationId!: artefactData,
                            },
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
                ],
                child: _loadedImage!,
              ),
            ),
        ],
      ),
    );
  }
}
