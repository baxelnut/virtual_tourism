import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/cards_emerged.dart';
import '../../services/firebase/storage/storage_service.dart';

class ImageStorageTest extends StatefulWidget {
  const ImageStorageTest({super.key});

  @override
  State<ImageStorageTest> createState() => _ImageStorageTestState();
}

class _ImageStorageTestState extends State<ImageStorageTest> {
  late Future<void> _fetchImagesFuture;

  @override
  void initState() {
    super.initState();
    _fetchImagesFuture = fetchImages();
  }

  Future<void> fetchImages() async {
    await Provider.of<StorageService>(context, listen: false).fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    // final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage Service'),
      ),
      body: FutureBuilder<void>(
        future: _fetchImagesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Consumer<StorageService>(
              builder: (context, storageService, child) {
                final List<String> imageUrls = storageService.imageUrls;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    color: Colors.amber,
                    width: screenSize.width,
                    height: screenSize.height,
                    child: ListView.builder(
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        // final String imageUrl = imageUrls[index];
                        // print(imageUrls);
                        return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: CardsEmerged(
                              destinationData: {},
                            ));
                      },
                    ),
                    // CardsLinear(
                    //             country: imageUrl,
                    //             flag: imageUrl,
                    //             thumbnailPath: imageUrl,
                    //             imagePath: imageUrl)
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: Consumer<StorageService>(
        builder: (context, storageService, child) {
          return FloatingActionButton(
            onPressed: () {
              storageService.uploadImage();
            },
            child: const Icon(Icons.add_a_photo_rounded),
          );
        },
      ),
    );
  }
}
