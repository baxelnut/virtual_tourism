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
  final descriptionController = TextEditingController();
  final websiteController = TextEditingController();
  final addressController = TextEditingController();

  late String _selectedCategory;
  String? _selectedSubcategory;
  late String _selectedContinent;
  String? _selectedCountry;
  String _selectedType = "Photographic";

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
              ),
              InputSection(
                controller: descriptionController,
                hintText: 'Description',
                icon: Icons.description_outlined,
                decorationColor: theme.colorScheme.onSurface,
                maxLength: 6000,
                maxLines: null,
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
                hintText: 'Link/Website',
                icon: Icons.description_outlined,
                decorationColor: theme.colorScheme.onSurface,
                maxLength: 253,
                maxLines: 1,
              ),
              InputSection(
                controller: addressController,
                hintText: 'Address*',
                icon: Icons.location_on,
                decorationColor: theme.colorScheme.onSurface,
                maxLength: 253,
                maxLines: null,
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
            final country = _selectedCountry ?? '';
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
            'Upload a photo',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

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
  };

  Map<String, List<String>> countriesMap = {
    'Africa': [
      'Algeria',
      'Angola',
      'Benin',
      'Botswana',
      'Burkina Faso',
      'Burundi',
      'Cabo Verde',
      'Cameroon',
      'Central African Republic',
      'Chad',
      'Comoros',
      'Congo',
      'Democratic Republic of the Congo',
      'Djibouti',
      'Egypt',
      'Equatorial Guinea',
      'Eritrea',
      'Eswatini',
      'Ethiopia',
      'Gabon',
      'Gambia',
      'Ghana',
      'Guinea',
      'Guinea-Bissau',
      'Ivory Coast',
      'Kenya',
      'Lesotho',
      'Liberia',
      'Libya',
      'Madagascar',
      'Malawi',
      'Mali',
      'Mauritania',
      'Mauritius',
      'Morocco',
      'Mozambique',
      'Namibia',
      'Niger',
      'Nigeria',
      'Rwanda',
      'São Tomé and Príncipe',
      'Senegal',
      'Seychelles',
      'Sierra Leone',
      'Somalia',
      'South Africa',
      'South Sudan',
      'Sudan',
      'Togo',
      'Tunisia',
      'Uganda',
      'Zambia',
      'Zimbabwe'
    ],
    'Asia': [
      'Afghanistan',
      'Armenia',
      'Azerbaijan',
      'Bahrain',
      'Bangladesh',
      'Bhutan',
      'Brunei',
      'Cambodia',
      'China',
      'Cyprus',
      'Georgia',
      'India',
      'Indonesia',
      'Iran',
      'Iraq',
      'Israel',
      'Japan',
      'Jordan',
      'Kazakhstan',
      'Kuwait',
      'Kyrgyzstan',
      'Laos',
      'Lebanon',
      'Malaysia',
      'Maldives',
      'Mongolia',
      'Myanmar',
      'Nepal',
      'North Korea',
      'Oman',
      'Pakistan',
      'Palestine',
      'Philippines',
      'Qatar',
      'Russia',
      'Saudi Arabia',
      'Singapore',
      'South Korea',
      'Sri Lanka',
      'Syria',
      'Tajikistan',
      'Thailand',
      'Timor-Leste',
      'Turkey',
      'Turkmenistan',
      'United Arab Emirates',
      'Uzbekistan',
      'Vietnam',
      'Yemen'
    ],
    'Europe': [
      'Albania',
      'Andorra',
      'Armenia',
      'Austria',
      'Azerbaijan',
      'Belarus',
      'Belgium',
      'Bosnia and Herzegovina',
      'Bulgaria',
      'Croatia',
      'Cyprus',
      'Czech Republic',
      'Denmark',
      'Estonia',
      'Finland',
      'France',
      'Georgia',
      'Germany',
      'Greece',
      'Hungary',
      'Iceland',
      'Ireland',
      'Italy',
      'Kazakhstan',
      'Kosovo',
      'Latvia',
      'Liechtenstein',
      'Lithuania',
      'Luxembourg',
      'Malta',
      'Moldova',
      'Monaco',
      'Montenegro',
      'Netherlands',
      'North Macedonia',
      'Norway',
      'Poland',
      'Portugal',
      'Romania',
      'Russia',
      'San Marino',
      'Serbia',
      'Slovakia',
      'Slovenia',
      'Spain',
      'Sweden',
      'Switzerland',
      'Turkey',
      'Ukraine',
      'United Kingdom',
      'Vatican City'
    ],
    'North America': [
      'Antigua and Barbuda',
      'Bahamas',
      'Barbados',
      'Belize',
      'Canada',
      'Costa Rica',
      'Cuba',
      'Dominica',
      'Dominican Republic',
      'El Salvador',
      'Grenada',
      'Guatemala',
      'Haiti',
      'Honduras',
      'Jamaica',
      'Mexico',
      'Nicaragua',
      'Panama',
      'Saint Kitts and Nevis',
      'Saint Lucia',
      'Saint Vincent and the Grenadines',
      'Trinidad and Tobago',
      'United States of America'
    ],
    'South America': [
      'Argentina',
      'Bolivia',
      'Brazil',
      'Chile',
      'Colombia',
      'Ecuador',
      'Guyana',
      'Paraguay',
      'Peru',
      'Suriname',
      'Uruguay',
      'Venezuela'
    ],
    'Oceania': [
      'Australia',
      'Fiji',
      'Kiribati',
      'Marshall Islands',
      'Micronesia',
      'Nauru',
      'New Zealand',
      'Palau',
      'Papua New Guinea',
      'Samoa',
      'Solomon Islands',
      'Tonga',
      'Tuvalu',
      'Vanuatu'
    ],
    'Antarctica': ['Antarctica']
  };
}
