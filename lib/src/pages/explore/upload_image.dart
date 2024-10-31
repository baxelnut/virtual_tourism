import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_tourism/src/services/firebase/api/firebase_api.dart';

import '../../components/image_screen.dart';
import '../../services/firebase/storage/storage_service.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  late Future<List<Map<String, dynamic>>> _fetchDestinationsFuture;
  // late Future<void> _fetchImagesFuture;
  final nameController = TextEditingController();
  final countryController = TextEditingController();
  final descriptionController = TextEditingController();

  final String category = 'custom_destinations';
  final String subcategory = 'custom_destinations';
  final String collection = 'custom_destinations';

  final String placeholderPath =
      'https://hellenic.org/wp-content/plugins/elementor/assets/images/placeholder.png';

  @override
  void initState() {
    super.initState();
    _fetchDestinationsFuture = fetchDestinations(collection: collection);
    // _fetchImagesFuture = fetchImages();
  }

  Future<List<Map<String, dynamic>>> fetchDestinations({
    required final String collection,
  }) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection(collection).get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching destinations: $e');
      return [];
    }
  }

  // Future<void> fetchImages() async {
  //   await Provider.of<StorageService>(context, listen: false)
  //       .fetchImages(ref: 'custom_images/');
  // }

  Future<String> getThumbnailUrl({
    required final String collection,
    required final String category,
    required final String subcategory,
    required final String destinationId,
  }) async {
    final List<String> extensions = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'webp'
    ];

    final path = '$collection/$category/$subcategory/$destinationId';
    try {
      return await FirebaseStorage.instance.ref(path).getDownloadURL();
    } catch (e) {
      print('Error fetching image from path: $path - $e');
      return '';
    }
  }

  void uploadDestinationInfo(StorageService storageService) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Destination Info'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter destination name',
                  ),
                ),
                TextField(
                  controller: countryController,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    hintText: 'Enter country name',
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter description',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;
                final country = countryController.text;
                final description = descriptionController.text;

                FirebaseApi().addDestination(
                    collections: 'custom_destinations',
                    category: 'custom_destinations',
                    subcategory: 'custom_destinations',
                    destinationName: name,
                    country: country,
                    description: description);

                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final ThemeData theme = Theme.of(context);
    // final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Destination'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchDestinationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No destinations found.'));
          }

          final destinations = snapshot.data!;
          return ListView.builder(
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              final destination = destinations[index];
              final String country = destination['country'] ?? 'Unknown';
              final String? destinationId = destination['id'];
              final String description =
                  destination['description'] ?? 'No description available.';
              final String destinationName =
                  destination['destinationName'] ?? 'No data available';
              if (destinationId == null) {
                return ListTile(
                  leading: Text(country),
                  title: Text(destinationName),
                  subtitle: Text(description),
                  trailing: const Icon(Icons.error),
                );
              }

              return FutureBuilder<String>(
                future: getThumbnailUrl(
                    collection: collection,
                    category: category,
                    subcategory: subcategory,
                    destinationId: destinationId),
                builder: (context, imageSnapshot) {
                  if (imageSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const SizedBox(
                      height: 50,
                      width: 50,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (imageSnapshot.hasError) {
                    return ListTile(
                      leading: Text(country),
                      title: Text(destinationName),
                      subtitle: Text('Country: $country'),
                      trailing: const Icon(Icons.broken_image, size: 50),
                    );
                  }

                  final String imageUrl = imageSnapshot.data ?? placeholderPath;
                  return ListTile(
                    leading: SizedBox(
                      height: 60,
                      width: 60,
                      child: Center(
                        child: Text(
                          country,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    title: Text(destinationName),
                    subtitle: Text(description),
                    trailing: imageUrl.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ImageScreen(
                                      image: Image(
                                        image: NetworkImage(imageUrl),
                                      ),
                                      appBarTitle: destinationName),
                                ),
                              );
                            },
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.broken_image),
                              ),
                            ),
                          )
                        : const Icon(Icons.image, size: 50),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: Consumer<StorageService>(
        builder: (context, storageService, child) {
          return FloatingActionButton(
            onPressed: () {
              uploadDestinationInfo(storageService);
            },
            child: const Icon(Icons.add_a_photo_rounded),
          );
        },
      ),
    );
  }
}
