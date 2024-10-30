import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/cards_emerged.dart';
import '../../components/cards_header.dart';
import '../../components/cards_linear.dart';
import '../../components/chips_component.dart';
import '../../components/user_overview.dart';
import '../../services/destination_data.dart';
import 'top_picks.dart';

class HomePage extends StatefulWidget {
  final Function(int) onPageChange;
  const HomePage({super.key, required this.onPageChange});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              const TopPicks(),
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
        const SizedBox(height: 50),
        UserOverview(
          isFull: false,
          onPageChange: widget.onPageChange,
        ),
        const ChipsComponent(listOfThangz: ['Places', 'Conservation', 'News']),
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
                      destinationData: popularData,
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
