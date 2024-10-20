import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_tourism/src/services/firebase/api/firebase_api.dart';

import '../../services/firebase/storage/storage_service.dart';

class UploadDestinations extends StatefulWidget {
  const UploadDestinations({super.key});

  @override
  State<UploadDestinations> createState() => _UploadDestinationsState();
}

class _UploadDestinationsState extends State<UploadDestinations> {
  final User? user = FirebaseAuth.instance.currentUser;
  late Future<List<Map<String, dynamic>>> _fetchDestinationsFuture;

  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _subCategoryController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDestinationsFuture = fetchDestinations();
  }

  Future<List<Map<String, dynamic>>> fetchDestinations() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('destinations').get();

      // Fetch image URLs based on document IDs
      final List<Map<String, dynamic>> destinations =
          await Future.wait(snapshot.docs.map((doc) async {
        String id = doc.id;
        String category =
            doc.data()['category'] ?? 'defaultCategory'; // Adjust as necessary
        String subcategory = doc.data()['subcategory'] ??
            'defaultSubcategory'; // Adjust as necessary

        // Fetch images from Storage
        List<String> imageUrls = await StorageService().fetchDestination(
          category: category,
          subcategory: subcategory,
        );

        return {
          'id': id,
          ...doc.data(),
          'imageUrls': imageUrls, // Attach the image URLs to the destination
        };
      }));

      return destinations;
    } catch (e) {
      print('Error fetching destinations: $e');
      return [];
    }
  }

  Future<String> getImageUrl(
      String category, String subcategory, String imageId) async {
    String filePath = 'destinations/$category/$subcategory/$imageId';
    try {
      String downloadUrl =
          await FirebaseStorage.instance.ref(filePath).getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error fetching image URL: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Destinations'),
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
          } else {
            final destinations = snapshot.data!;
            return ListView.builder(
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final destination = destinations[index];
                final country = destination['country'] ?? 'Unknown Country';
                final description =
                    destination['description'] ?? 'No Description';
                final destinationId = destination['id'];
                final destinationName =
                    destination['destinationName'] ?? 'Unknown Destination';

                // Fetch image URL based on destinationId
                return FutureBuilder<String>(
                  future: getImageUrl(
                    'beach', // Now using the checked category
                    'beach', // Now using the checked subcategory
                    destinationId, // This should always be a valid String
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error fetching image'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return ListTile(
                        leading: Text(country),
                        title: Text(destinationName),
                        subtitle: Text(
                            'ID: $destinationId, Description: $description'),
                        trailing: const Icon(Icons.image, size: 50),
                      );
                    }

                    final imageUrl = snapshot.data!;

                    return ListTile(
                      leading: Text(country),
                      title: Text(destinationName),
                      subtitle:
                          Text('ID: $destinationId, Description: $description'),
                      trailing: imageUrl.isNotEmpty
                          ? Image.network(
                              '${imageUrl}_thumbnail',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image, size: 50),
                    );
                  },
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
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: const Text('Upload Image'),
                    content: IntrinsicHeight(
                      child: Column(
                        children: [
                          _inputSection(
                              controller: _categoryController,
                              label: 'category',
                              theme: theme),
                          _inputSection(
                              controller: _subCategoryController,
                              label: 'sub category',
                              theme: theme),
                          _inputSection(
                              controller: _destinationController,
                              label: 'destination name',
                              theme: theme),
                          _inputSection(
                              controller: _countryController,
                              label: 'country',
                              theme: theme),
                          _inputSection(
                              controller: _descriptionController,
                              label: 'description',
                              theme: theme),
                          ElevatedButton(
                              onPressed: () {
                                FirebaseApi().addDestination(
                                  category: _categoryController.text.trim(),
                                  subcategory:
                                      _subCategoryController.text.trim(),
                                  destinationName:
                                      _destinationController.text.trim(),
                                  country: _countryController.text.trim(),
                                  description: _descriptionController.text,
                                );

                                Navigator.of(context).pop();
                              },
                              child: const Text('Upload'))
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }

  Widget _inputSection({
    required String label,
    required ThemeData theme,
    TextEditingController? controller,
    bool readOnly = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 0.5),
          ),
          label: Text(label, style: theme.textTheme.bodyLarge),
        ),
      ),
    );
  }
}
