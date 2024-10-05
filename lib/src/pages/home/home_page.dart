import 'package:flutter/material.dart';

import '../../components/cards_curved.dart';
import '../../components/cards_emerged.dart';
import '../../components/cards_header.dart';
import '../../components/cards_linear.dart';
import 'user_overview.dart';
import '../../components/chips_component.dart';

// must be applied to all pages
// padding: const EdgeInsets.symmetric(horizontal: 20),
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              homeHeader(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(
                  'Where do we go now?',
                  style: theme.textTheme.displayLarge,
                ),
              ),
              topPicks(context),
              topCountries(),
              popularDestionation(context),
              const SizedBox(
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget homeHeader() {
    return const Column(
      children: [
        UserOverview(username: 'Basil'),
        ChipsComponent(listOfThangz: ['Places', 'Conservation', 'News']),
      ],
    );
  }

  Widget topPicks(BuildContext context) {
    final List<Map<String, String>> topPicks = [
      {
        'destination': 'balcony_water',
        'description':
            'Ready-to-use, one-component, water-based, UV-resistant, clear gloss, aliphatic, polyurethane, waterproofing coating.',
        'imagePath': 'assets/images/balcony_water.jpg',
        'thumbnailPath': 'assets/images/thumbs/balcony_water_thumb.webp'
      },
      {
        'destination': 'dock',
        'description':
            'A structure extending alongshore or out from the shore into a body of water, to which boats may be moored.',
        'imagePath': 'assets/images/dock.jpg',
        'thumbnailPath': 'assets/images/thumbs/dock_thumb.webp'
      },
      {
        'destination': 'Carlsbad Caverns National Park',
        'description':
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        'imagePath': 'assets/images/carlsbad_nps.jpg',
        'thumbnailPath': 'assets/images/thumbs/carlsbad_nps_thumb.webp'
      },
      {
        'destination': 'boat',
        'description':
            'A small vessel propelled on water by oars, sails, or an engine.',
        'imagePath': 'assets/images/boat.jpg',
        'thumbnailPath': 'assets/images/thumbs/boat_thumb.webp'
      },
      {
        'destination': 'carlsbad',
        'description':
            "Carlsbad is a city near San Diego, in California. It's known for Tamarack Surf Beach, backed by the Carlsbad Sea Wall, and secluded South Carlsbad State Beach.",
        'imagePath': 'assets/images/carlsbad.jpg',
        'thumbnailPath': 'assets/images/thumbs/carlsbad_thumb.jpg'
      },
      {
        'destination': 'game_world',
        'description':
            'A game world is a place of imagination and is usually placed in an alternate fictional universe',
        'imagePath': 'assets/images/game_world.jpeg',
        'thumbnailPath': 'assets/images/thumbs/game_world_thumb.webp'
      },
      {
        'destination': 'lagoon',
        'description':
            'A stretch of salt water separated from the sea by a low sandbank or coral reef.',
        'imagePath': 'assets/images/lagoon.jpg',
        'thumbnailPath': 'assets/images/thumbs/lagoon_thumb.webp'
      },
      {
        'destination': 'mountain',
        'description':
            "Large natural elevation of the earth's surface rising abruptly from the surrounding level; a large steep hill.",
        'imagePath': 'assets/images/mountain.jpg',
        'thumbnailPath': 'assets/images/thumbs/mountain_thumb.webp'
      },
      {
        'destination': 'planet',
        'description': "It's a messed up planet.",
        'imagePath': 'assets/images/planet.jpeg',
        'thumbnailPath': 'assets/images/thumbs/planet_thumb.webp'
      },
      {
        'destination': 'room',
        'description': "It's a room",
        'imagePath': 'assets/images/room.jpeg',
        'thumbnailPath': 'assets/images/thumbs/room_thumb.webp'
      },
      {
        'destination': 'trees',
        'description':
            "Perennial plant with an elongated stem, or trunk, usually supporting branches and leaves.",
        'imagePath': 'assets/images/trees.jpeg',
        'thumbnailPath': 'assets/images/thumbs/trees_thumb.webp'
      },
      {
        'destination': 'Führerbunker',
        'description':
            "The Führerbunker was an air raid shelter located near the Reich Chancellery in Berlin, Germany. It was part of a subterranean bunker complex constructed in two phases in 1936 and 1944. It was the last of the Führer Headquarters used by Adolf Hitler during World War II.",
        'imagePath': 'assets/images/bunker.jpeg',
        'thumbnailPath': 'assets/images/thumbs/bunker_thumb.webp'
      },
      {
        'destination': 'grocery',
        'description':
            "A store that sells perishable and nonperishable food supplies and certain nonedible household items, such as soaps and paper products.",
        'imagePath': 'assets/images/grocery.jpeg',
        'thumbnailPath': 'assets/images/thumbs/grocery_thumb.webp'
      },
    ];

    return Column(
      children: [
        const CardsHeader(cardsTitle: 'Top Picks'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: topPicks.map((topPicksData) {
              return CardsCurved(
                destination: topPicksData['destination']!
                    .replaceAll('_', ' ')
                    .split(' ')
                    .map((word) =>
                        '${word[0].toUpperCase()}${word.substring(1)}')
                    .join(' '),
                description: topPicksData['description']!,
                thumbnailPath: topPicksData['thumbnailPath']!,
                imagePath: topPicksData['imagePath']!,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget topCountries() {
    final List<Map<String, String>> countries = [
      {
        'flag': '🇮🇩',
        'country': 'Indonesia',
        'thumbnailPath':
            'https://www.gowisatanusapenida.com/wp-content/uploads/2020/12/48369E1C-3A4B-4C9D-9DA5-E1534803E34F-768x960.jpeg',
        'imagePath':
            'https://www.gowisatanusapenida.com/wp-content/uploads/2020/12/48369E1C-3A4B-4C9D-9DA5-E1534803E34F-768x960.jpeg'
      },
      {
        'flag': '🇯🇲',
        'country': 'Jamaica',
        'thumbnailPath':
            'https://www.libertytravel.com/sites/default/files/LT1059807892-BLOG-jamaicas_jaw_dropping_natural_wonders_interior_1000x667_1%20%281%29.jpg',
        'imagePath':
            'https://www.libertytravel.com/sites/default/files/LT1059807892-BLOG-jamaicas_jaw_dropping_natural_wonders_interior_1000x667_1%20%281%29.jpg'
      },
      {
        'flag': '🇯🇵',
        'country': 'Japan',
        'thumbnailPath':
            'https://vagatrip.com/storage/blogs/July2023/Mount%20Fuji.jpg',
        'imagePath':
            'https://vagatrip.com/storage/blogs/July2023/Mount%20Fuji.jpg'
      },
      {
        'flag': '🇺🇸',
        'country': 'United States',
        'thumbnailPath':
            'https://www.kayak.com/news/wp-content/uploads/sites/19/2024/02/5bfd0ca39cbe98553bf5dd6811f4a95d-820x656.jpg',
        'imagePath':
            'https://www.kayak.com/news/wp-content/uploads/sites/19/2024/02/5bfd0ca39cbe98553bf5dd6811f4a95d-820x656.jpg'
      },
      {
        'flag': '🇬🇧',
        'country': 'United Kingdom',
        'thumbnailPath':
            'https://cdn.mos.cms.futurecdn.net/q4i42ws72RZ3sEcx2QT3iV-1200-80.jpg',
        'imagePath':
            'https://cdn.mos.cms.futurecdn.net/q4i42ws72RZ3sEcx2QT3iV-1200-80.jpg'
      },
    ];

    return Column(
      children: [
        const CardsHeader(cardsTitle: 'Top Countries'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: countries.map((countryData) {
              return CardsLinear(
                flag: countryData['flag']!,
                country: countryData['country']!,
                thumbnailPath: countryData['thumbnailPath']!,
                imagePath: countryData['imagePath']!,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget popularDestionation(BuildContext context) {
    final List<Map<String, String>> popular = [
      {
        'country': 'Indonesia',
        'destination': 'Nusa Penida',
        'thumbnailPath':
            'https://www.gowisatanusapenida.com/wp-content/uploads/2020/12/48369E1C-3A4B-4C9D-9DA5-E1534803E34F-768x960.jpeg',
        'imagePath':
            'https://www.gowisatanusapenida.com/wp-content/uploads/2020/12/48369E1C-3A4B-4C9D-9DA5-E1534803E34F-768x960.jpeg'
      },
      {
        'country': 'Jamaica',
        'destination': 'Dunn’s River Falls',
        'thumbnailPath':
            'https://www.libertytravel.com/sites/default/files/LT1059807892-BLOG-jamaicas_jaw_dropping_natural_wonders_interior_1000x667_1%20%281%29.jpg',
        'imagePath':
            'https://www.libertytravel.com/sites/default/files/LT1059807892-BLOG-jamaicas_jaw_dropping_natural_wonders_interior_1000x667_1%20%281%29.jpg'
      },
      {
        'country': 'Japan',
        'destination': 'Mount Fuji',
        'thumbnailPath':
            'https://vagatrip.com/storage/blogs/July2023/Mount%20Fuji.jpg',
        'imagePath':
            'https://vagatrip.com/storage/blogs/July2023/Mount%20Fuji.jpg'
      },
      {
        'country': 'United States',
        'destination': 'Glacier National Park',
        'thumbnailPath':
            'https://www.kayak.com/news/wp-content/uploads/sites/19/2024/02/5bfd0ca39cbe98553bf5dd6811f4a95d-820x656.jpg',
        'imagePath':
            'https://www.kayak.com/news/wp-content/uploads/sites/19/2024/02/5bfd0ca39cbe98553bf5dd6811f4a95d-820x656.jpg'
      },
      {
        'country': 'United Kingdom',
        'destination': 'Stonehenge',
        'thumbnailPath':
            'https://cdn.mos.cms.futurecdn.net/q4i42ws72RZ3sEcx2QT3iV-1200-80.jpg',
        'imagePath':
            'https://cdn.mos.cms.futurecdn.net/q4i42ws72RZ3sEcx2QT3iV-1200-80.jpg'
      },
    ];
    final double cardSize = MediaQuery.of(context).size.width / 2;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        children: [
          const CardsHeader(cardsTitle: 'Popular'),
          SizedBox(
            height: cardSize, // height dynamic based on card size
            child: RotatedBox(
              quarterTurns: -1, // rotate content by 90 degrees
              child: ListWheelScrollView(
                itemExtent: cardSize, // item extent dynamic
                squeeze: 1.05,
                physics: const FixedExtentScrollPhysics(),
                children: popular.map((popularData) {
                  return RotatedBox(
                    quarterTurns: 1, // rotate back normal orientation
                    child: CardsEmerged(
                      country: popularData['country']!,
                      destination: popularData['destination']!,
                      thumbnailPath: popularData['thumbnailPath']!,
                      imagePath: popularData['imagePath']!,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
