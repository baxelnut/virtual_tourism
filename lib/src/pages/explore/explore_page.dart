import 'package:flutter/material.dart';

import '../../components/cards_curved.dart';
import '../../components/cards_emerged.dart';
import '../../components/cards_header.dart';
import '../../components/cards_linear.dart';
import '../../components/chips_component.dart';
import '../home/user_overview.dart';

// must be applied to all pages
// padding: const EdgeInsets.symmetric(horizontal: 20),
class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

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
        'destination': 'LOREM IPSUM',
        'description':
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        'imagePath': 'assets/nusa_penida.jpeg'
      },
      {
        'destination': 'LOREM IPSUM',
        'description':
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        'imagePath': 'assets/nusa_penida.jpeg'
      },
      {
        'destination': 'LOREM IPSUM',
        'description':
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        'imagePath': 'assets/nusa_penida.jpeg'
      },
      {
        'destination': 'LOREM IPSUM',
        'description':
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        'imagePath': 'assets/nusa_penida.jpeg'
      },
      {
        'destination': 'LOREM IPSUM',
        'description':
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        'imagePath': 'assets/nusa_penida.jpeg'
      },
    ];

    return Column(
      children: [
        const CardsHeader(cardsTitle: 'Popular'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: topPicks.map((topPicksData) {
              return CardsCurved(
                destination: topPicksData['destination']!,
                description: topPicksData['description']!,
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
        'imagePath': 'assets/nusa_penida.jpeg'
      },
      {
        'flag': '🇺🇸',
        'country': 'United States',
        'imagePath': 'assets/nusa_penida.jpeg'
      },
      {
        'flag': '🇯🇵',
        'country': 'Japan',
        'imagePath': 'assets/nusa_penida.jpeg'
      },
      {
        'flag': '🇬🇧',
        'country': 'United Kingdom',
        'imagePath': 'assets/nusa_penida.jpeg'
      },
      {
        'flag': '🇮🇳',
        'country': 'India',
        'imagePath': 'assets/nusa_penida.jpeg'
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
        'imagePath': 'assets/nusa_penida.jpeg',
      },
      {
        'country': 'United States',
        'destination': 'Grand Canyon',
        'imagePath': 'assets/nusa_penida.jpeg',
      },
      {
        'country': 'Japan',
        'destination': 'Mount Fuji',
        'imagePath': 'assets/nusa_penida.jpeg',
      },
      {
        'country': 'United Kingdom',
        'destination': 'Stonehenge',
        'imagePath': 'assets/nusa_penida.jpeg',
      },
      {
        'country': 'India',
        'destination': 'Taj Mahal',
        'imagePath': 'assets/nusa_penida.jpeg',
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
