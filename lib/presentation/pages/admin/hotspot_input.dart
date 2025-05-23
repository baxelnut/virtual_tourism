import 'package:flutter/material.dart';

import '../../../core/global_values.dart';
import '../../../services/firebase/api/destinations_service.dart';
import '../../widgets/content/pin_point_coords.dart';
import 'image_widget_input.dart';

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
  });

  @override
  State<HotspotInput> createState() => _HotspotInputState();
}

class _HotspotInputState extends State<HotspotInput> {
  final DestinationsService _destinationsService = DestinationsService();
  final String placeholderPath = GlobalValues.placeholderPath;

  int _hotspotQty = 2;
  final List<TextEditingController> _latControllers = [];
  final List<TextEditingController> _lonControllers = [];
  final List<TextEditingController> _hotspotDecsController = [];

  late Map<String, dynamic> updatedHotspot = widget.hotspotData;

  @override
  void initState() {
    super.initState();
    _initializeHotspotControllers(_hotspotQty);

    _addNewWidget();
  }

  List<String> infos = [];
  List<String> infosPath = [];

  void _addNewWidget() {
    setState(() {
      infos.add("");
      infosPath.add("");
    });
  }

  void _updateInfoText(int index, String text) {
    if (index < infos.length) {
      setState(() {
        infos[index] = text;
      });
    } else {}
  }

  void _initializeHotspotControllers(int qty) {
    _latControllers.clear();
    _lonControllers.clear();
    _hotspotDecsController.clear();
    for (int i = 0; i < qty; i++) {
      _latControllers.add(TextEditingController());
      _lonControllers.add(TextEditingController());
      _hotspotDecsController.add(TextEditingController());
    }
    _notifyHotspotData();
  }

  Future<void> _notifyHotspotData({int? index}) async {
    for (int i = 0; i < _hotspotQty; i++) {
      double latitude = double.tryParse(_latControllers[i].text.trim()) ?? 0.0;
      double longitude = double.tryParse(_lonControllers[i].text.trim()) ?? 0.0;
      String hotDesc = _hotspotDecsController[i].text.trim();

      setState(() {
        updatedHotspot['hotspot$i'] = {
          'latitude': latitude,
          'longitude': longitude,
          "hotDesc": hotDesc,
          'imagePath': widget.hotspotData['hotspot$i']?['imagePath'] ?? '',
          'thumbnailPath':
              widget.hotspotData['hotspot$i']?['thumbnailPath'] ?? '',
        };
      });

      if (index != null) {
        await _destinationsService.addDestination(
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
          trynnaDoHotspot: true,
        );
      }
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
      _hotspotDecsController.add(TextEditingController());
      isConfirmed = false;
    });

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
        _hotspotDecsController.removeLast();
        _hotspotDecsController.removeLast();
        _hotspotImages.remove(_hotspotQty);
        isConfirmed = false;
      });

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
    for (var controller in _hotspotDecsController) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);

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
              _buildCoordTextField(
                controller: _latControllers[index],
                hint: 'Latitude',
                theme: theme,
              ),
              const SizedBox(width: 10),
              _buildCoordTextField(
                controller: _lonControllers[index],
                hint: 'Longitude',
                theme: theme,
              ),
              const SizedBox(width: 10),
              _pinPointButton(index: index, theme: theme),
            ],
          ),
          ...List.generate(infos.length, (index) {
            return ImageWidgetInput(
              key: ValueKey(index),
              textField: TextField(
                controller: _hotspotDecsController[index],
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Additional info (Optional)',
                  hintStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                ),
                onChanged: (_) => _notifyHotspotData(index: index),
              ),
              onTextChanged: (text) => _updateInfoText(index, text),
              collectionId: widget.collections,
              typeShit: widget.typeShit,
              destinationName: widget.destinationName,
              category: widget.category,
              subcategory: widget.subcategory,
              infosPath: infosPath,
              description: widget.description,
              externalSource: widget.externalSource,
              address: widget.address,
              continent: widget.continent,
              country: widget.country,
              hotspotData: widget.hotspotData,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCoordTextField({
    required TextEditingController controller,
    required String hint,
    required ThemeData theme,
  }) {
    return Expanded(
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.colorScheme.onSurface.withOpacity(0),
              width: 1,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
        ),
        onChanged: (_) => _notifyHotspotData(),
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
                  await _destinationsService.addDestination(
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
                    trynnaDoHotspot: true,
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
          String? downloadUrl = await _destinationsService.addDestination(
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
            trynnaDoHotspot: true,
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
