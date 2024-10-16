import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/storage/storage_service.dart';

class ImageStorageTest extends StatefulWidget {
  const ImageStorageTest({super.key});

  @override
  State<ImageStorageTest> createState() => _ImageStorageTestState();
}

class _ImageStorageTestState extends State<ImageStorageTest> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchImages();
  }

  Future fetchImages() async {
    await Provider.of<StorageService>(context, listen: false).fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StorageService>(builder: (context, storageService, child) {
      final List<String> imageUrls = storageService.imageUrls;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Storage Service'),
        ),
        body: ListView.builder(
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            final String imageUrl = imageUrls[index];

            return Image.network(imageUrl);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            storageService.uploadImage();
          },
          child: const Icon(Icons.add_a_photo_rounded),
        ),
      );
    });
  }
}
