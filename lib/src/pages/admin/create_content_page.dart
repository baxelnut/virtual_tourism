import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/input_dropdown.dart';
import '../../components/input_section.dart';
import '../../services/firebase/api/firebase_api.dart';
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
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final websiteController = TextEditingController();
  final addressController = TextEditingController();

  late String _selectedCategory;
  String? _selectedSubcategory;
  late String _selectedContinent;
  String? _selectedCountry;
  String _selectedType = "Photographic";

  Map<String, dynamic> _hotspotData = {};
  int hotspotQty = 2;

  bool isConfirmedEnabled = false;

  void updateConfirmState(bool value) {
    setState(() {
      isConfirmedEnabled = value;
    });
  }

  // void _updateHotspotQty(int qty) {
  //   setState(() {
  //     hotspotQty = qty;
  //   });
  // }

  // void checkConfirmState() {
  //   int uploadedPictures = _hotspotData.length;
  //   int requiredPictures = hotspotQty;

  //   setState(() {
  //     isConfirmedEnabled = uploadedPictures == requiredPictures;
  //   });
  // }

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
                hintText: 'Link/Website',
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
              Visibility(
                visible: _selectedType == "Tour",
                child: HotspotInput(
                  onChanged: (data) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        _hotspotData = data;
                        // checkConfirmState();
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
                  // onHotspotQtyChanged: _updateHotspotQty,
                ),
              ),
              // Text(isConfirmedEnabled.toString()),
              // Text(_hotspotData.length.toString()),
              // Text(hotspotQty.toString()),
              (_selectedType == "Tour" && isConfirmedEnabled) ||
                      _selectedType == "Photographic"
                  ? _buildSubmitButton(
                      screenSize: screenSize,
                      theme: theme,
                    )
                  : const SizedBox(height: 40),
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
            if (nameController.text.isNotEmpty) {
              if (_selectedType == "Photographic") {
                FirebaseApi().addDestination(
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
                );
              }
              Navigator.of(context).pop();
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // include: controversial yet legal (at least in some countries) e.g. gambling
  // exclude: illegal and morally wrong
  Map<String, List<String>> categoryMap = {
    'Accessible': [
      'Inclusive Travel',
      'Barrier-Free Destinations',
      'Sensory Friendly Experiences',
      'Other',
    ],
    'Adventure': [
      'Hiking',
      'Mountain Climbing',
      'Bungee Jumping',
      'Paragliding',
      'Whitewater Rafting',
      'Zip-lining',
      'Caving',
      'Off-Road Driving',
      'Extreme Camping',
      'Other',
    ],
    'Agritourism': [
      'Farm Stays',
      'Vineyard Tours',
      'Agro-Tourism Activities',
      'Orchard Visits',
      'Ranching Experiences',
      'Equestrian Tours',
      'Other',
    ],
    'Alternative': [
      'Slow Travel',
      'Backpacker Journeys',
      'Experimental Travel',
      'Counterculture Experiences',
      'Nomadic Adventures',
      'Other',
    ],
    'Archaeological': [
      'Ancient Ruins',
      'Excavation Sites',
      'Prehistoric Sites',
      'Other',
    ],
    'Astrotourism': [
      'Star Gazing',
      'Observatory Visits',
      'Meteor Shower Events',
      'Other',
    ],
    'Atomic': [
      'Nuclear Site Tours',
      'Atomic Age Museums',
      'Cold War Relics',
      'Other',
    ],
    'Birth': [
      'Maternity Tourism',
      'Postpartum Retreats',
      'Other',
    ],
    'Bookstore': [
      'Famous Bookstores',
      'Literary Cafes',
      'Libraries',
      'Other',
    ],
    'Business': [
      'Meetings',
      'Incentives',
      'Conferences',
      'Exhibitions',
      'Corporate Retreats',
      'Team Building',
      'Trade Shows',
      'Other',
    ],
    'Casino/Gambling': [
      'Casino Resorts',
      'Gambling Cruises',
      'Betting Halls',
      'Other',
    ],
    'Cave': [
      'Speleology Tours',
      'Cave Exploration',
      'Other',
    ],
    'Culinary': [
      'Food Tours',
      'Cooking Classes',
      'Wine Tasting',
      'Street Food Exploration',
      'Local Markets',
      'Gastronomic Experiences',
      'Other',
    ],
    'Cultural': [
      'Heritage Sites',
      'Museums',
      'Festivals',
      'Art Galleries',
      'Architecture Tours',
      'Folk Traditions',
      'Cultural Immersion',
      'Local Festivals',
      'Other',
    ],
    'Cycle': [
      'Bicycle Tours',
      'Mountain Biking',
      'Other',
    ],
    'Dark': [
      'Disaster Sites',
      'War Memorials',
      'Cemeteries',
      'Haunted Locations',
      'Crime Scene Tours',
      'Other',
    ],
    'Dental': [
      'Affordable Dental Clinics Abroad',
      'Other',
    ],
    'Digital Detox': [
      'Digital Detox Retreats',
      'Disconnect & Reconnect Experiences',
      'Other',
    ],
    'Disaster': [
      'Post-Disaster Tours',
      'Crisis Region Visits',
      'Natural Disaster Sites',
      'Other',
    ],
    'Domestic': [
      'Staycations',
      'Local Travel',
      'Regional Attractions',
      'Other',
    ],
    'Drug': [
      'Cannabis Tourism',
      'Psychedelic Retreats',
      'Other',
    ],
    'Ecotourism': [
      'Wildlife Safaris',
      'Nature Reserves',
      'Conservation Tours',
      'Bird Watching',
      'Nature Trails',
      'Other',
    ],
    'Educational': [
      'Campus Tours',
      'Historical Lectures',
      'Cultural Workshops',
      'Language Immersion Programs',
      'Other',
    ],
    'Enotourism': [
      'Wine Tours',
      'Vineyard Visits',
      'Wine Festivals',
      'Other',
    ],
    'Extreme': [
      'Base Jumping',
      'Wingsuit Flying',
      'Ice Climbing',
      'Parkour Tours',
      'Ice Diving',
      'Other',
    ],
    'Factory Tours': [
      'Industrial Heritage Tours',
      'Brewery Tours',
      'Distillery Tours',
      'Craft Workshops',
      'Other',
    ],
    'Fashion': [
      'Fashion Weeks',
      'Designer Boutiques',
      'Shopping District Tours',
      'Other',
    ],
    'Festival': [
      'Music Festivals',
      'Cultural Festivals',
      'Food Festivals',
      'Film Festivals',
      'Other',
    ],
    'Film & TV': [
      'Film Location Tours',
      'TV Show Destinations',
      'Cinema Museums',
      'Other',
    ],
    'Gaming': [
      'Video Game Conventions',
      'Esports Arenas',
      'Retro Gaming Cafes',
      'Other',
    ],
    'Garden': [
      'Botanical Gardens',
      'Landscape Parks',
      'Zen Gardens',
      'Japanese Gardens',
      'Other',
    ],
    'Genealogy': [
      'Ancestry Tours',
      'Heritage Visits',
      'Family History Research',
      'Other',
    ],
    'Geotourism': [
      'Geological Site Tours',
      'Landform Exploration',
      'Volcano Tours',
      'Other',
    ],
    'Halal': [
      'Muslim-Friendly Destinations',
      'Halal Accommodations',
      'Other',
    ],
    'Heritage': [
      'Historical Landmarks',
      'World Heritage Sites',
      'Colonial Towns',
      'Civil War Sites',
      'Other',
    ],
    'Honeymoon': [
      'Romantic Getaways',
      'Couples Retreats',
      'Other',
    ],
    'Hot Springs': [
      'Thermal Baths',
      'Geothermal Spas',
      'Other',
    ],
    'Jungle': [
      'Rainforest Expeditions',
      'Wild Jungle Tours',
      'Tropical Adventures',
      'Other',
    ],
    'Justice': [
      'Revolutionary Tours',
      'Social Justice Tours',
      'Political Heritage',
      'Other',
    ],
    'Kosher': [
      'Jewish-Friendly Destinations',
      'Kosher Food Tours',
      'Other',
    ],
    'LGBT': [
      'Gay-Friendly Destinations',
      'Pride Events',
      'LGBT History Tours',
      'Other',
    ],
    'Literary': [
      'Author Birthplaces',
      'Literary Festivals',
      'Book Tours',
      'Other',
    ],
    'Medical': [
      'Cosmetic Surgery',
      'Fertility Treatments',
      'Wellness Clinics',
      'Health Resorts',
      'Other',
    ],
    'Militarism Heritage': [
      'Battlefields',
      'Military Museums',
      'Fort Tours',
      'Naval History',
      'Warship Museums',
      'Other',
    ],
    'Motorcycle': [
      'Motorcycle Rallies',
      'Scenic Motorcycle Routes',
      'Other',
    ],
    'Music': [
      'Concert Tours',
      'Music Festivals',
      'Live Performances',
      'Opera Houses',
      'Jazz Clubs',
      'Music Museums',
      'Other',
    ],
    'Nautical': [
      'Cruise Ships',
      'Yacht Charters',
      'Sailing Tours',
      'Island Hopping',
      'Submarine Tours',
      'Other',
    ],
    'Pop-Culture': [
      'Film Location Tours',
      'TV Show Destinations',
      'Comic Conventions',
      'Fan Festivals',
      'Other',
    ],
    'Religious': [
      'Pilgrimages',
      'Sacred Sites',
      'Churches',
      'Mosques',
      'Temples',
      'Synagogues',
      'Shrines',
      'Monasteries',
      'Spiritual Retreats',
      'Other',
    ],
    'Road Trip': [
      'Self-Drive Tours',
      'Motorhome Adventures',
      'Other',
    ],
    'Rural': [
      'Village Stays',
      'Agro-Tourism',
      'Eco-Lodges',
      'Countryside Retreats',
      'Other',
    ],
    'Sacred Travel': [
      'Religious Pilgrimages',
      'Holy Site Tours',
      'Spiritual Journeys',
      'Other',
    ],
    'Safaris': [
      'Wildlife Safaris',
      'Big Five Tours',
      'Bird Safaris',
      'Other',
    ],
    'Science & Innovation': [
      'Science Centers',
      'Technology Hubs',
      'Innovation Museums',
      'Other',
    ],
    'Sex': [
      'Erotic Tourism',
      'Adult Entertainment',
      'Burlesque Shows',
      'Other',
    ],
    'Shopping': [
      'Luxury Shopping',
      'Outlet Malls',
      'Traditional Markets',
      'Flea Markets',
      'Other',
    ],
    'Slum': [
      'Informal Settlement Tours',
      'Urban Exploration',
      'Street Art & Graffiti Tours',
      'Other',
    ],
    'Space': [
      'Suborbital Flights',
      'Orbital Experiences',
      'Lunar Missions',
      'Zero Gravity Experiences',
      'Other',
    ],
    'Sports': [
      'Event Tourism',
      'Adventure Sports',
      'Golf Tours',
      'Skiing Holidays',
      'Motorsports',
      'Cycling Tours',
      'Marathon Routes',
      'Other',
    ],
    'Stag Party': [
      'Bachelor Party Destinations',
      'Nightlife Tours',
      'Other',
    ],
    'Sustainable': [
      'Eco-Friendly Tours',
      'Community-Based Tourism',
      'Carbon Neutral Travel',
      'Other',
    ],
    'Shark': [
      'Shark Diving',
      'Marine Wildlife Tours',
      'Other',
    ],
    'Theme Park': [
      'Amusement Parks',
      'Water Parks',
      'Adventure Parks',
      'Other',
    ],
    'Tolkien': [
      'Film Set Tours',
      'Middle-Earth Inspired Destinations',
      'Other',
    ],
    'Train': [
      'Scenic Rail Journeys',
      'Historic Train Rides',
      'Luxury Train Tours',
      'Other',
    ],
    'Vacation': [
      'Holiday Packages',
      'Resort Stays',
      'Family Holidays',
      'Other',
    ],
    'Volunteer': [
      'Voluntourism',
      'Community Service Travel',
      'Disaster Relief Volunteering',
      'Other',
    ],
    'War': [
      'Conflict Zone Tours',
      'Military History Tours',
      'Battlefield Tours',
      'Other',
    ],
    'Water': [
      'Beach Holidays',
      'Surfing',
      'Water Sports',
      'Diving',
      'Kayaking',
      'Other',
    ],
    'Wellness': [
      'Spa Retreats',
      'Yoga Retreats',
      'Meditation Retreats',
      'Thermal Baths',
      'Other',
    ],
    'Wildlife': [
      'Animal Safaris',
      'Bird Watching',
      'Marine Wildlife Tours',
      'Animal Sanctuaries',
      'Other',
    ],
    'Winter': [
      'Ski Resorts',
      'Northern Lights',
      'Ice Hotels',
      'Snow Festivals',
      'Other',
    ],
    'Other': [
      'Other',
    ],
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
    'Antarctica': [
      'Antarctica',
    ],
  };
}
