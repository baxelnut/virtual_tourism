import 'package:flutter/material.dart';

import '../../components/content/pin_point_coords.dart';
import '../../services/firebase/api/firebase_api.dart';

class HotspotInput extends StatefulWidget {
  final String collections;
  final String category;
  final String subcategory;
  final String destinationName;
  final String continent;
  final String country;
  final String description;
  final String externalSource;
  final String typeShit;
  final String address;
  final Map<String, dynamic> hotspotData;
  final ValueChanged<Map<String, dynamic>>? onChanged;
  final Function(bool) onConfirmChanged;
  // final ValueChanged<int> onHotspotQtyChanged;
  const HotspotInput({
    super.key,
    required this.collections,
    required this.category,
    required this.subcategory,
    required this.destinationName,
    required this.continent,
    required this.country,
    required this.description,
    required this.externalSource,
    required this.typeShit,
    required this.address,
    required this.hotspotData,
    this.onChanged,
    required this.onConfirmChanged,
    // required this.onHotspotQtyChanged,
  });

  @override
  State<HotspotInput> createState() => _HotspotInputState();
}

class _HotspotInputState extends State<HotspotInput> {
  final FirebaseApi _firebaseApi = FirebaseApi();
  final String placeholderPath =
      'https://hellenic.org/wp-content/plugins/elementor/assets/images/placeholder.png';

  int _hotspotQty = 2;
  final List<TextEditingController> _latControllers = [];
  final List<TextEditingController> _lonControllers = [];

  late Map<String, dynamic> updatedHotspot = widget.hotspotData;

  @override
  void initState() {
    super.initState();
    _initializeHotspotControllers(_hotspotQty);
  }

  void _initializeHotspotControllers(int qty) {
    _latControllers.clear();
    _lonControllers.clear();
    for (int i = 0; i < qty; i++) {
      _latControllers.add(TextEditingController());
      _lonControllers.add(TextEditingController());
    }
    _notifyHotspotData();
  }

  void _notifyHotspotData() {
    for (int i = 0; i < _hotspotQty; i++) {
      double latitude = double.tryParse(_latControllers[i].text.trim()) ?? 0.0;
      double longitude = double.tryParse(_lonControllers[i].text.trim()) ?? 0.0;

      setState(() {
        updatedHotspot['hotspot$i'] = {
          'latitude': latitude,
          'longitude': longitude,
          'imagePath': widget.hotspotData['hotspot$i']?['imagePath'] ?? '',
          'thumbnailPath':
              widget.hotspotData['hotspot$i']?['thumbnailPath'] ?? '',
        };
      });
    }
  }

  void _syncHotspotImages() {
    _hotspotImages.clear();
    for (int i = 0; i < _hotspotQty; i++) {
      String? imagePath = widget.hotspotData['hotspot$i']?['imagePath'];
      if (imagePath!.isNotEmpty) {
        _hotspotImages[i] = imagePath;
      }
    }
  }

  void _increment() {
    if (!isConfirmEnabled) {
      int requiredNumber = _hotspotQty;
      if (_hotspotQty == 2) {
        _showSnackBar("Fill Hotspot 1 & 2 first");
      } else if (_hotspotQty > 2) {
        _showSnackBar("Fill Hotspot $requiredNumber first");
      }
      return;
    }
    setState(() {
      _hotspotQty++;
      _latControllers.add(TextEditingController());
      _lonControllers.add(TextEditingController());
      isConfirmed = false;
    });
    // widget.onHotspotQtyChanged(_hotspotQty);
    _notifyHotspotData();
  }

  void _decrement() {
    if (_hotspotQty > 1) {
      setState(() {
        _hotspotQty--;
        _latControllers.last.dispose();
        _lonControllers.last.dispose();
        _latControllers.removeLast();
        _lonControllers.removeLast();
        _hotspotImages.remove(_hotspotQty);
        isConfirmed = false;
      });
      // widget.onHotspotQtyChanged(_hotspotQty);
      _notifyHotspotData();
    }
  }

  bool isConfirmed = false;
  bool get isConfirmEnabled {
    if (_hotspotImages.length != _hotspotQty) return false;
    for (int i = 0; i < _hotspotQty; i++) {
      if (!_hotspotImages.containsKey(i) ||
          _hotspotImages[i]!.isEmpty ||
          _hotspotImages[i] == 'uploading') {
        return false;
      }
    }
    return true;
  }

  void _onImageUploadComplete(int index) {
    setState(() {
      _hotspotImages[index] = widget.hotspotData['hotspot$index']['imagePath'];
      isConfirmed = isConfirmEnabled;
    });
    widget.onConfirmChanged(isConfirmed);
    // print('Updated _hotspotImages[index] ${_hotspotImages[index]}');
  }

  final Map<int, String> _hotspotImages = {};

  @override
  void dispose() {
    for (var controller in _latControllers) {
      controller.dispose();
    }
    for (var controller in _lonControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _hotspotQty,
            itemBuilder: (context, index) {
              return _hotspotCoords(
                index: index,
                theme: theme,
              );
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Hotspot Quantity:',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              _decrementButton(),
              _hotspotQtyBox(),
              _incrementbutton(),
            ],
          ),
          // Text(isConfirmEnabled.toString()),
          // Text(isConfirmed.toString()),
        ],
      ),
    );
  }

  Widget _hotspotCoords({
    required int index,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hotspot ${index + 1} Coordinates:',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _latControllers[index],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Latitude',
                    labelStyle: theme.textTheme.bodyLarge?.copyWith(
                      overflow: TextOverflow.ellipsis,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                  ),
                  onChanged: (_) => _notifyHotspotData(),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TextField(
                  controller: _lonControllers[index],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Longitude',
                    labelStyle: theme.textTheme.bodyLarge?.copyWith(
                      overflow: TextOverflow.ellipsis,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                  ),
                  onChanged: (_) => _notifyHotspotData(),
                ),
              ),
              const SizedBox(width: 20),
              _pinPointButton(
                index: index,
                theme: theme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pinPointButton({
    required int index,
    required ThemeData theme,
  }) {
    return ElevatedButton(
      onPressed: () async {
        if (widget.destinationName.isEmpty) {
          _showSnackBar("Title can't be empty.");
          return;
        }
        if (isConfirmed == true) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PinPointCoords(
                image: Image(
                  image: NetworkImage(
                    widget.typeShit == 'Tour'
                        ? (widget.hotspotData["hotspot$index"]["imagePath"] ??
                            placeholderPath)
                        : placeholderPath,
                  ),
                ),
                onCoordinatesSelected:
                    (double latitude, double longitude) async {
                  setState(() {
                    _latControllers[index].text = latitude.toStringAsFixed(1);
                    _lonControllers[index].text = longitude.toStringAsFixed(1);
                    _notifyHotspotData();
                  });
                  await _firebaseApi.addDestination(
                    collectionId: 'verified_user_uploads',
                    typeShit: widget.typeShit,
                    destinationName: widget.destinationName,
                    category: widget.category,
                    subcategory: widget.subcategory,
                    description: widget.description,
                    externalSource: widget.externalSource,
                    address: widget.address,
                    continent: widget.continent,
                    country: widget.country,
                    hotspotData: updatedHotspot,
                    hotspotIndex: index,
                    decideCoords: true,
                  );
                },
              ),
            ),
          );
        } else {
          _showSnackBar("Please wait...");
          setState(() {
            _hotspotImages[index] = 'uploading';
          });
          _notifyHotspotData();
          String? downloadUrl = await _firebaseApi.addDestination(
            collectionId: 'verified_user_uploads',
            typeShit: widget.typeShit,
            destinationName: widget.destinationName,
            category: widget.category,
            subcategory: widget.subcategory,
            description: widget.description,
            externalSource: widget.externalSource,
            address: widget.address,
            continent: widget.continent,
            country: widget.country,
            hotspotData: updatedHotspot,
            hotspotIndex: index,
          );

          widget.onChanged?.call(updatedHotspot);
          _syncHotspotImages();
          setState(() {
            isConfirmed = isConfirmEnabled;
          });

          setState(() {
            if (downloadUrl != null) {
              setState(() {
                _hotspotImages[index] = downloadUrl;
              });
            } else {
              setState(() {
                _hotspotImages.remove(index);
              });
            }
            if (!isConfirmEnabled) {
              _onImageUploadComplete(index);
            }
          });
          // print('Updated _hotspotImages: $_hotspotImages');
          // print('isConfirmEnabled: $isConfirmEnabled');
          // print('isConfirmed: $isConfirmed');
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: _hotspotImages[index] == 'uploading'
            ? theme.colorScheme.onSecondary
            : _hotspotImages.containsKey(index)
                ? (_latControllers[index].text == "0.0" &&
                            _lonControllers[index].text == "0.0") ||
                        (_latControllers[index].text == "" &&
                            _lonControllers[index].text == "")
                    ? Colors.yellow
                    : Colors.green
                : theme.colorScheme.secondary,
        padding: const EdgeInsets.all(12),
      ),
      child: _hotspotImages[index] == 'uploading'
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: theme.colorScheme.secondary,
              ),
            )
          : _hotspotImages.containsKey(index)
              ? Icon(
                  Icons.remove_red_eye_rounded,
                  color: theme.colorScheme.onSecondary,
                  size: 24,
                )
              : Icon(
                  Icons.add_a_photo_rounded,
                  color: theme.colorScheme.onSecondary,
                  size: 24,
                ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _decrementButton() {
    return IconButton(
      onPressed: () {
        if (_hotspotQty > 2) {
          _decrement();
        } else {
          _showSnackBar("Minimum hotspot quantity is 2");
        }
      },
      icon: const Icon(Icons.remove_rounded),
    );
  }

  Widget _incrementbutton() {
    return IconButton(
      onPressed: () {
        if (_hotspotQty < 20) {
          _increment();
        } else {
          _showSnackBar("Maximum hotspot quantity is 20");
        }
      },
      icon: const Icon(Icons.add_rounded),
    );
  }

  Widget _hotspotQtyBox() {
    return SizedBox(
      width: 60,
      child: TextField(
        controller: TextEditingController(
          text: _hotspotQty.toString(),
        ),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        readOnly: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
