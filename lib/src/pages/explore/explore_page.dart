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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(
                  'Where do we go now?',
                  style: theme.textTheme.displayLarge,
                ),
              ),
              topPicks(),
              topCountries(),
              popularDestionation(),
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

  Widget topPicks() {
    return const Column(
      children: [
        CardsHeader(cardsTitle: 'Top Picks'),
        CardsCurved(
          destination: 'LOREM IPSUM',
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
        ),
      ],
    );
  }

  Widget topCountries() {
    final List<Map<String, String>> countries = [
      {'flag': '🇮🇩', 'country': 'Indonesia'},
      {'flag': '🇺🇸', 'country': 'United States'},
      {'flag': '🇯🇵', 'country': 'Japan'},
      {'flag': '🇬🇧', 'country': 'United Kingdom'},
      {'flag': '🇮🇳', 'country': 'India'},
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
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget popularDestionation() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 25),
      child: Column(
        children: [
          CardsHeader(cardsTitle: 'Popular'),
          CardsEmerged(
            country: 'Indonesia',
            destination: 'Nusa Penida',
          ),
        ],
      ),
    );
  }
}
