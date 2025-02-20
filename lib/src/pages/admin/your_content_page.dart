// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/firebase/storage/storage_service.dart';
import 'content_tiles.dart';
import 'create_content_page.dart';

class YourContentPage extends StatefulWidget {
  const YourContentPage({super.key});

  @override
  State<YourContentPage> createState() => _YourContentPageState();
}

class _YourContentPageState extends State<YourContentPage> {
  final String placeholderPath =
      'https://hellenic.org/wp-content/plugins/elementor/assets/images/placeholder.png';
  late Future<List<Map<String, dynamic>>> _fetchDestinationsFuture;
  final User? user = FirebaseAuth.instance.currentUser;
  final String collection = 'verified_user_uploads';

  Future<List<Map<String, dynamic>>> fetchDestinations() async {
    try {
      // filter by user ID
      final snapshot = await FirebaseFirestore.instance
          .collection(collection)
          .where('userId', isEqualTo: user!.uid)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching destinations: $e');
      return [];
    }
  }

  Future<String> getThumbnailUrl({
    required String destinationId,
    required String typeShi,
    required String category,
    required String subcategory,
  }) async {
    final originalPath =
        '$collection/$typeShi/$category/$subcategory/$destinationId';
    final thumbnailPath =
        '$collection/$typeShi/$category/$subcategory/${destinationId}_thumbnail';
    try {
      return await FirebaseStorage.instance.ref(thumbnailPath).getDownloadURL();
    } catch (e) {
      print('Thumbnail not found, trying original: $e');
      try {
        return await FirebaseStorage.instance
            .ref(originalPath)
            .getDownloadURL();
      } catch (e) {
        print('Original image not found: $e');
        return '';
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDestinationsFuture = fetchDestinations();
  }

  // temporarwawrerereaakontol
  late String typeShi = 'Photographic';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Content'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            children: [
              searchBar(
                theme: theme,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Switch(
                    value: typeShi == "Tour",
                    onChanged: (bool newValue) {
                      setState(() {
                        typeShi = newValue ? "Tour" : "Photographic";
                      });
                    },
                  ),
                  Text(typeShi),
                ],
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchDestinationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: screenSize.width,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return SizedBox(
                      height: screenSize.width,
                      child: Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return SizedBox(
                      height: screenSize.width,
                      child: const Center(
                        child: Text(
                          'No destinations found.',
                        ),
                      ),
                    );
                  }

                  final destinations = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: destinations.length,
                    itemBuilder: (context, index) {
                      final destination = destinations[index];
                      return FutureBuilder<String>(
                        future: getThumbnailUrl(
                          destinationId: destination['id'],
                          category: destination['category'],
                          subcategory: destination['subcategory'],
                          typeShi: typeShi,
                        ),
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
                              leading: Text(destination['country']),
                              title: Text(destination['destinationName']),
                              trailing: const Icon(
                                Icons.broken_image,
                                size: 50,
                              ),
                            );
                          }
                          return ContentTiles(
                            destinationData: destination,
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
      floatingActionButton: Consumer<StorageService>(
        builder: (context, storageService, child) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreateContentPage(
                    user: user,
                  ),
                ),
              );
            },
            child: Icon(
              Icons.add_rounded,
              size: 35,
              color: theme.colorScheme.onPrimary,
            ),
          );
        },
      ),
    );
  }

  Widget searchBar({
    required ThemeData theme,
  }) {
    return ListTile(
      leading: Icon(
        Icons.search_rounded,
        color: theme.colorScheme.onSurface,
      ),
      title: Text(
        'Search...',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
      dense: true,
      tileColor: theme.colorScheme.onSurface.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onTap: () {
        print('search bar pressed');
      },
    );
  }
}
