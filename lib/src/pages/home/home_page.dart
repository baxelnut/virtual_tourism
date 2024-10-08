import 'package:flutter/material.dart';

import '../../components/cards_curved.dart';
import '../../components/cards_emerged.dart';
import '../../components/cards_header.dart';
import '../../components/cards_linear.dart';
import '../../components/chips_component.dart';
import '../../components/user_overview.dart';
import '../../data/destination_data.dart';

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
        UserOverview(
          username: 'Basil',
          imagePath: 'assets/profile.jpg',
          isFull: false,
          email: 'basiliustengang24@gmail.com',
        ),
        ChipsComponent(listOfThangz: ['Places', 'Conservation', 'News']),
      ],
    );
  }

  Widget topPicks(BuildContext context) {
    return Column(
      children: [
        const CardsHeader(cardsTitle: 'Top Picks'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: topPickList.map((topPicksData) {
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
    return Column(
      children: [
        const CardsHeader(cardsTitle: 'Top Countries'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: countriesList.map((countryData) {
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
                children: popularList.map((popularData) {
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
