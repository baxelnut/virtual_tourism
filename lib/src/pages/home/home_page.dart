import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/cards_curved.dart';
import '../../components/cards_emerged.dart';
import '../../components/cards_header.dart';
import '../../components/cards_linear.dart';
import '../../components/chips_component.dart';
import '../../components/user_overview.dart';
import '../../data/destination_data.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser;

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
    return Column(
      children: [
        UserOverview(
          username: user?.displayName,
          imagePath: 'assets/profile.png',
          isFull: false,
          email: 'basiliustengang24@gmail.com',
        ),
        const ChipsComponent(listOfThangz: ['Places', 'Conservation', 'News']),
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
            height: cardSize,
            child: RotatedBox(
              quarterTurns: -1,
              child: ListWheelScrollView(
                itemExtent: cardSize,
                squeeze: 1.05,
                physics: const FixedExtentScrollPhysics(),
                children: popularList.map((popularData) {
                  return RotatedBox(
                    quarterTurns: 1,
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
