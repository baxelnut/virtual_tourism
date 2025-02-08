import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/input_dropdown.dart';
import '../../components/input_section.dart';
import '../../services/firebase/api/firebase_api.dart';

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
  final nameController = TextEditingController();
  final countryController = TextEditingController();
  final descriptionController = TextEditingController();

  Map<String, List<String>> categoryMap = {
    'Travel': ['Adventure', 'Culture', 'Luxury', 'Budget'],
    'Food': ['Restaurants', 'Street Food', 'Recipes'],
    'Lifestyle': ['Fashion', 'Health & Fitness', 'Home & Decor'],
    'Entertainment': ['Movies', 'Music', 'Art & Events'],
    'Technology': ['Gadgets', 'Reviews', 'Innovations'],
    'Sports': ['Football', 'Basketball', 'Tennis', 'Cricket'],
    'Business': ['Finance', 'Startups', 'Market Trends'],
    'Education': ['Schools', 'Universities', 'Online Courses'],
    'Health': ['Nutrition', 'Fitness', 'Wellness'],
    'Art': ['Painting', 'Sculpture', 'Photography'],
    // ... add additional categories as needed
  };

  late String _selectedCategory;
  String? _selectedSubcategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = categoryMap.keys.first;
    _selectedSubcategory = categoryMap[_selectedCategory]?.first;
  }

  @override
  void dispose() {
    nameController.dispose();
    countryController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            children: [
              InputSection(
                controller: nameController,
                hintText: 'Title',
                icon: Icons.title,
                decorationColor: theme.colorScheme.onSurface,
              ),
              InputSection(
                controller: countryController,
                hintText: 'Country',
                icon: Icons.flag,
                decorationColor: theme.colorScheme.onSurface,
              ),
              InputDropdown(
                title: 'Category',
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
                title: 'Sub-category',
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
                controller: descriptionController,
                hintText: 'Description',
                icon: Icons.description_outlined,
                decorationColor: theme.colorScheme.onSurface,
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
          onPressed: () {
            final name = nameController.text;
            final country = countryController.text;
            final description = descriptionController.text;

            FirebaseApi().addDestination(
              collections: 'verified_user_uploads',
              category: _selectedCategory,
              subcategory: _selectedSubcategory ?? '',
              destinationName: name,
              country: country,
              description: description,
            );

            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          ),
          child: Text(
            'Submit',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
