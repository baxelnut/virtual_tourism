import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/firebase/storage/storage_service.dart';

class UploadDestinations extends StatefulWidget {
  const UploadDestinations({super.key});

  @override
  State<UploadDestinations> createState() => _UploadDestinationsState();
}

class _UploadDestinationsState extends State<UploadDestinations> {
  late Future<List<Map<String, dynamic>>> _fetchDestinationsFuture;

  @override
  void initState() {
    super.initState();
    _fetchDestinationsFuture = fetchDestinations();
  }

  Future<List<Map<String, dynamic>>> fetchDestinations() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('example_destinations')
          .get();
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

  Future<String> getThumbnailUrl(String destinationId) async {
    final List<String> extensions = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'webp'
    ];

    for (final ext in extensions) {
      final path = 'example_images/${destinationId}_thumbnail.$ext';
      try {
        return await FirebaseStorage.instance.ref(path).getDownloadURL();
      } catch (e) {
        if (e.toString().contains('object-not-found')) {
          // ignore: avoid_print
          print('Error fetching image: $e');
          continue;
        }
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Destinations')),
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
                  destination['destination'] ?? 'Unknown';

              if (destinationId == null) {
                return ListTile(
                  leading: Text(country),
                  title: Text(destinationName),
                  subtitle: Text(description),
                  trailing: const Icon(Icons.error),
                );
              }

              return FutureBuilder<String>(
                future: getThumbnailUrl(destinationId),
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
                      subtitle: Text('Country: $country\nID: $destinationId'),
                      trailing: const Icon(Icons.broken_image, size: 50),
                    );
                  }

                  final String imageUrl = imageSnapshot.data ?? '';

                  return ListTile(
                    leading: Text(country),
                    title: Text(destinationName),
                    subtitle: Text(description),
                    trailing: imageUrl.isNotEmpty
                        ? Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(360)),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.broken_image),
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
              storageService.uploadImage(ref: 'uploaded_images/');
            },
            child: const Icon(Icons.add_a_photo_rounded),
          );
        },
      ),
    );
  }
}
