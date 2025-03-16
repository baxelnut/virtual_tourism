import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/global_values.dart';

class ImageWidgetInput extends StatefulWidget {
  final IconData icon;
  final String hintText;
  final int maxLength;
  final int? maxLines;

  const ImageWidgetInput({
    super.key,
    required this.icon,
    required this.hintText,
    required this.maxLength,
    this.maxLines,
  });

  @override
  _ImageWidgetInputState createState() => _ImageWidgetInputState();
}

class _ImageWidgetInputState extends State<ImageWidgetInput> {
  final TextEditingController controller = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ListTile(
            dense: true,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            leading: Icon(
              widget.icon,
              color: theme.colorScheme.onSurface,
              size: 20,
            ),
            title: TextField(
              controller: controller,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: theme.textTheme.bodyLarge,
              ),
              maxLength: widget.maxLength,
              maxLines: widget.maxLines,
            ),
            trailing: ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: theme.colorScheme.primary,
                padding: EdgeInsets.all(0),
              ),
              child: Icon(
                Icons.image,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ),
        if (_selectedImage != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                _selectedImage!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
      ],
    );
  }
}
