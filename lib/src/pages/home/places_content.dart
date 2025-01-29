import 'package:flutter/material.dart';

import '../../components/cards_emerged.dart';
import '../../components/cards_header.dart';
import '../../components/cards_linear.dart';
import '../../services/destination_data.dart';

class PlacesContent extends StatelessWidget {
  const PlacesContent({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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
        topCountries(),
        popularDestionation(context),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget topCountries() {
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
      ],
    );
  }

  Widget popularDestionation(BuildContext context) {
    final double cardSize = MediaQuery.of(context).size.width / 2;
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
        ],
      ),
    );
  }
}
