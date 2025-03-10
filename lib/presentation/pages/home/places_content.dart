import 'package:flutter/material.dart';

import '../../../core/global_values.dart';
import '../../../data/destination_data.dart';
import '../../widgets/cards/cards_emerged.dart';
import '../../widgets/cards/cards_header.dart';
import '../../widgets/cards/cards_linear.dart';
// import 'top_picks.dart';

class PlacesContent extends StatelessWidget {
  const PlacesContent({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);
    final Size screenSize = GlobalValues.screenSize(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Text(
            'Where do we go now?',
            style: theme.textTheme.displayMedium,
            textAlign: TextAlign.start,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "Where will your next adventure take you? Discover the world’s most breathtaking destinations from the comfort of your home. Whether you're dreaming of a tropical getaway, a historic city tour, or a nature retreat, we bring the world to your fingertips.",
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.left,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // TopPicks(),
        topCountries(theme),
        popularDestionation(theme, screenSize),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget topCountries(ThemeData theme) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const CardsHeader(cardsTitle: 'Top Countries'),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: countriesList.map(
              (countryData) {
                return CardsLinear(
                  flag: countryData['flag']!,
                  country: countryData['country']!,
                  thumbnailPath: countryData['thumbnailPath']!,
                  imagePath: countryData['imagePath']!,
                );
              },
            ).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Experience the most sought-after travel destinations with immersive virtual tours 🌍',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget popularDestionation(ThemeData theme, Size screenSize) {
    final double cardSize = screenSize.width / 2;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CardsHeader(cardsTitle: 'Popular'),
          const SizedBox(height: 10),
          SizedBox(
            height: cardSize,
            child: RotatedBox(
              quarterTurns: -1,
              child: ListWheelScrollView(
                itemExtent: cardSize,
                squeeze: 1.05,
                physics: const FixedExtentScrollPhysics(),
                children: popularList.map(
                  (popularData) {
                    return RotatedBox(
                      quarterTurns: 1,
                      child: CardsEmerged(
                        destinationData: popularData,
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Explore trending spots that travelers love right now. Start your journey today and let your curiosity guide you! 🔥',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
