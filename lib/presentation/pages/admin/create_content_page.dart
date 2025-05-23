import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/global_values.dart';
import '../../../data/destination_data.dart';
import '../../../services/firebase/api/destinations_service.dart';
import '../../widgets/utils/input_dropdown.dart';
import '../../widgets/utils/input_section.dart';
import 'add_artefact.dart';
import 'add_trivia.dart';
import 'hotspot_input.dart';

class CreateContentPage extends StatefulWidget {
  final User? user;
  const CreateContentPage({
    super.key,
    required this.user,
  });

  @override
  State<CreateContentPage> createState() => _CreateContentPageState();
}

class _CreateContentPageState extends State<CreateContentPage> {
  final DestinationsService _destinationsService = DestinationsService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final TextEditingController artefactController = TextEditingController();
  final TextEditingController triviaController = TextEditingController();
  final List<TextEditingController> optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  late String _selectedCategory;
  String? _selectedSubcategory;
  late String _selectedContinent;
  String? _selectedCountry;
  String _selectedType = "Photographic";

  Map<String, dynamic> _hotspotData = {};
  int hotspotQty = 2;

  bool isConfirmedEnabled = true;

  Map<String, dynamic>? _finalTrivia;
  Map<String, dynamic>? _finalArtefact;

  void updateConfirmState(bool value) {
    setState(() {
      isConfirmedEnabled = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedCategory = categoryMap.keys.first;
    _selectedSubcategory = categoryMap[_selectedCategory]?.first;
    _selectedContinent = countriesMap.keys.first;
    _selectedCountry = countriesMap[_selectedContinent]?.first;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    websiteController.dispose();
    addressController.dispose();

    triviaController.dispose();
    artefactController.dispose();
    for (final controller in optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void addAnswerField() {
    setState(() {
      optionControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);
    final Size screenSize = GlobalValues.screenSize(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            children: [
              InputDropdown(
                title: 'Type*',
                items: const ['Photographic', 'Tour'],
                initialValue: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
              ),
              InputSection(
                controller: nameController,
                hintText: 'Title*',
                icon: Icons.title,
                decorationColor: theme.colorScheme.onSurface,
                maxLength: 100,
                maxLines: 1,
                isReadOnly: false,
              ),
              InputSection(
                controller: descriptionController,
                hintText: 'Description',
                icon: Icons.description_outlined,
                decorationColor: theme.colorScheme.onSurface,
                maxLength: 6000,
                maxLines: null,
                isReadOnly: nameController.text.isEmpty,
              ),
              InputDropdown(
                title: 'Category*',
                items: categoryMap.keys.toList(),
                initialValue: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                    _selectedSubcategory = categoryMap[value]?.first;
                  });
                },
              ),
              InputDropdown(
                title: 'Sub-category*',
                items: categoryMap[_selectedCategory]!,
                initialValue: _selectedSubcategory ??
                    categoryMap[_selectedCategory]!.first,
                onChanged: (value) {
                  setState(() {
                    _selectedSubcategory = value;
                  });
                },
              ),
              InputSection(
                controller: websiteController,
                hintText: 'Link/Website (Optional)',
                icon: Icons.description_outlined,
                decorationColor: theme.colorScheme.onSurface,
                maxLength: 253,
                maxLines: 1,
                isReadOnly: nameController.text.isEmpty,
              ),
              InputSection(
                controller: addressController,
                hintText: 'Address',
                icon: Icons.location_on,
                decorationColor: theme.colorScheme.onSurface,
                maxLength: 253,
                maxLines: null,
                isReadOnly: nameController.text.isEmpty,
              ),
              InputDropdown(
                title: 'Continent*',
                items: countriesMap.keys.toList(),
                initialValue: _selectedContinent,
                onChanged: (value) {
                  setState(() {
                    _selectedContinent = value;
                    _selectedCountry = countriesMap[value]?.first;
                  });
                },
              ),
              InputDropdown(
                title: 'Country*',
                items: countriesMap[_selectedContinent]!,
                initialValue: _selectedCountry ?? '',
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value;
                  });
                },
              ),
              AddTrivia(
                title: "Add trivia question (Optional)",
                triviaController: triviaController,
                optionControllers: optionControllers,
                addAnswerField: addAnswerField,
                onConfirm: (trivia) {
                  setState(() {
                    _finalTrivia = trivia;
                  });
                },
              ),
              Visibility(
                visible: _selectedType == "Tour",
                child: HotspotInput(
                  onChanged: (data) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        _hotspotData = data;
                      });
                    });
                  },
                  collections: 'verified_user_uploads',
                  typeShit: _selectedType,
                  destinationName: nameController.text.trim(),
                  category: _selectedCategory,
                  subcategory: _selectedSubcategory ?? '',
                  description: descriptionController.text.trim(),
                  externalSource: websiteController.text.trim(),
                  address: addressController.text.trim(),
                  continent: _selectedContinent,
                  country: _selectedCountry ?? '',
                  hotspotData: _hotspotData,
                  onConfirmChanged: updateConfirmState,
                ),
              ),
              AddArtefact(
                title: 'Add artefact (Optional)',
                artefactController: artefactController,
                sceneLength: _selectedType == "Tour" ? _hotspotData.length : 0,
                onConfirm: (artefact) {
                  setState(() {
                    _finalArtefact = artefact;
                  });
                  // print("_finalArtefact at field: $_finalArtefact");
                },
              ),
              _buildSubmitButton(
                screenSize: screenSize,
                theme: theme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton({
    required Size screenSize,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: SizedBox(
        width: screenSize.width,
        child: ElevatedButton(
          onPressed: () async {
            if (nameController.text.isNotEmpty) {
              await _destinationsService.addDestination(
                collectionId: 'verified_user_uploads',
                typeShit: _selectedType,
                destinationName: nameController.text.trim(),
                category: _selectedCategory,
                subcategory: _selectedSubcategory ?? '',
                description: descriptionController.text.trim(),
                externalSource: websiteController.text.trim(),
                address: addressController.text.trim(),
                continent: _selectedContinent,
                country: _selectedCountry ?? '',
                hotspotData: _hotspotData,
                // infos: infos,
                // infosPath: infosPath,
                trynnaDoHotspot: false,
                trivia: _finalTrivia,
                artefact: _finalArtefact,
              );

              if (mounted) {
                Navigator.of(context).pop();
              }
              _showSnackBar("Please wait...");
            } else {
              _showSnackBar("Title can't be emtpy.");
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          ),
          child: Text(
            _selectedType == "Tour" ? 'Confirm' : 'Upload a photo',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
