import 'package:firebase_auth/firebase_auth.dart';
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
  late Future<void> _fetchImagesFuture;
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _subCategoryController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchImagesFuture = fetchImages();
  }

  Future<void> fetchImages() async {
    await Provider.of<StorageService>(context, listen: false)
        .fetchDestination(category: 'beach', subcategory: 'beach');
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Destinations'),
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
                  child: SizedBox(
                    width: screenSize.width,
                    height: screenSize.height,
                    child: ListView.builder(
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        final String imageUrl = imageUrls[index];
                        // print(imageUrls);
                        // FirebaseApi().getDestinationData(destinationId)
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              title: const Text('country'),
                              subtitle: const Text('destinationName'),
                              trailing: Image(image: NetworkImage(imageUrl)),
                            ));
                      },
                    ),
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
