import 'package:flutter/material.dart';

import '../../../core/global_values.dart';

class AddArtefact extends StatefulWidget {
  final String title;
  final TextEditingController artefactController;
  final int sceneLength;
  final void Function(Map<String, dynamic> artefact) onConfirm;

  const AddArtefact({
    super.key,
    required this.title,
    required this.artefactController,
    required this.sceneLength,
    required this.onConfirm,
  });

  @override
  State<AddArtefact> createState() => _AddArtefactState();
}

class _AddArtefactState extends State<AddArtefact> {
  final TextEditingController latControllers = TextEditingController();
  final TextEditingController lonControllers = TextEditingController();
  String _dropDownValue = "Scene 1";
  bool _isConfirmed = false;

  void dropDownValueChange(String? selectedValue) {
    if (selectedValue != null) {
      setState(() {
        _dropDownValue = selectedValue;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    latControllers.dispose();
    lonControllers.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: ListTile(
            dense: true,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.artefactController,
                    readOnly: _isConfirmed,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.title,
                      hintStyle: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      counterText: "",
                    ),
                    maxLength: 100,
                    maxLines: 1,
                  ),
                ),
                if (widget.sceneLength > 0)
                  DropdownButton<String>(
                    value: _dropDownValue,
                    onChanged: dropDownValueChange,
                    items: List.generate(
                      widget.sceneLength,
                      (index) {
                        String value = 'Scene ${index + 1}';
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCoordTextField(
                      controller: latControllers,
                      hint: "Latitude",
                      theme: theme,
                    ),
                    SizedBox(width: 10),
                    _buildCoordTextField(
                      controller: lonControllers,
                      hint: "Longitude",
                      theme: theme,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    final name = widget.artefactController.text.trim();
                    final lat = latControllers.text.trim();
                    final lon = lonControllers.text.trim();

                    if (name.isEmpty) {
                      _showSnackBar("Please enter an artefact's name.");
                      return;
                    }

                    if (lat.isEmpty || lon.isEmpty) {
                      _showSnackBar(
                          "Please enter an artefact's latitude and longitude.");
                      return;
                    }

                    final artefact = {
                      'name': name,
                      'lat': lat,
                      'lon': lon,
                    };

                    widget.onConfirm(artefact);

                    setState(() => _isConfirmed = !_isConfirmed);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: Text(
                    _isConfirmed ? "Edit" : "Confirm",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
        readOnly: _isConfirmed,
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
        onChanged: (_) {},
      ),
    );
  }
}
