import 'package:flutter/material.dart';

class HotspotInput extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>>? onChanged;
  const HotspotInput({
    super.key,
    this.onChanged,
  });

  @override
  State<HotspotInput> createState() => _HotspotInputState();
}

class _HotspotInputState extends State<HotspotInput> {
  int _hotspotQty = 2;
  final List<TextEditingController> _latControllers = [];
  final List<TextEditingController> _lonControllers = [];

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
    Map<String, dynamic> hotspotData = {};
    hotspotData['hotspotQty'] = _hotspotQty;
    for (int i = 0; i < _hotspotQty; i++) {
      int latitude = int.tryParse(_latControllers[i].text.trim()) ?? 0;
      int longitude = int.tryParse(_lonControllers[i].text.trim()) ?? 0;
      hotspotData['hotspot${i + 1}'] = {
        'latitude': latitude,
        'longitude': longitude,
      };
    }
    if (widget.onChanged != null) {
      widget.onChanged!(hotspotData);
    }
  }

  void _increment() {
    setState(() {
      _hotspotQty++;
      _latControllers.add(TextEditingController());
      _lonControllers.add(TextEditingController());
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
      });
      _notifyHotspotData();
    }
  }

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
                  decoration: const InputDecoration(
                    labelText: 'Latitude',
                    border: OutlineInputBorder(
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
                  decoration: const InputDecoration(
                    labelText: 'Longitude',
                    border: OutlineInputBorder(
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
                theme: theme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pinPointButton({
    required ThemeData theme,
  }) {
    return ElevatedButton(
      onPressed: () {
        print('fucking work');
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: theme.colorScheme.secondary,
        padding: const EdgeInsets.all(12),
      ),
      child: Icon(
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
