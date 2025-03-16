import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/global_values.dart';
// import '../../../services/firebase/api/destinations_service.dart';
// import '../../../services/firebase/api/storage_service.dart';

class ImageWidgetInput extends StatefulWidget {
  final IconData icon;
  final String hintText;
  final int maxLength;
  final int? maxLines;
  final Function(String) onTextChanged;
  final String collectionId;
  final String category;
  final String subcategory;
  final String typeShit;
  final String destinationName;
  final List<String> infosPath;
  final String continent;
  final String country;
  final String externalSource;
  final String address;
  final String description;
  final Map<String, dynamic> hotspotData;
  const ImageWidgetInput({
    super.key,
    required this.icon,
    required this.hintText,
    required this.maxLength,
    this.maxLines,
    required this.onTextChanged,
    required this.collectionId,
    required this.category,
    required this.subcategory,
    required this.typeShit,
    required this.destinationName,
    required this.infosPath,
    required this.continent,
    required this.country,
    required this.externalSource,
    required this.address,
    required this.hotspotData,
    required this.description,
  });

  @override
  ImageWidgetInputState createState() => ImageWidgetInputState();
}

class ImageWidgetInputState extends State<ImageWidgetInput> {
  // final DestinationsService _destinationsService = DestinationsService();
  // final StorageService _storageService = StorageService();
  final TextEditingController controller = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    // temp
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }

    // if (image != null) {
    //   if (_selectedImage != null) {
    //     // 1️⃣ Upload image to Firebase Storage first!
    //     List<String>? uploadedUrls = await _storageService.addInfosPath(
    //       collectionId: widget.collectionId,
    //       typeShit: widget.typeShit,
    //       category: widget.category,
    //       subcategory: widget.subcategory,
    //       imageId: widget.destinationName, // Use docId or name
    //       images: [_selectedImage!], // Passing list of files
    //     );

    //     if (uploadedUrls != null && uploadedUrls.isNotEmpty) {
    //       print("🔥 Uploaded URLs: $uploadedUrls");

    //       // 2️⃣ Send URLs to Firestore
    //       await _destinationsService.addDestination(
    //         collectionId: widget.collectionId,
    //         category: widget.category,
    //         subcategory: widget.subcategory,
    //         destinationName: widget.destinationName,
    //         continent: widget.continent,
    //         country: widget.country,
    //         description: widget.description,
    //         externalSource: widget.externalSource,
    //         typeShit: widget.typeShit,
    //         address: widget.address,
    //         hotspotData: widget.hotspotData,
    //         trynnaDoHotspot: false,
    //         infosPath: uploadedUrls, // ✅ Finally pass the URLs
    //       );
    //     } else {
    //       print("🔥 Upload failed, no URLs received.");
    //     }
    //   }
    // }
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
              onChanged: widget.onTextChanged,
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
              onPressed: () {
                _pickImage();
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: theme.colorScheme.primary,
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
