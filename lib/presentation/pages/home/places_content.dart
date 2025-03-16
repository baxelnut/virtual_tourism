import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/global_values.dart';
import '../../../data/destination_data.dart';
import '../../../services/firebase/api/destinations_service.dart';
import '../../widgets/cards/cards_emerged.dart';
import '../../widgets/cards/cards_header.dart';
import '../../widgets/cards/cards_linear.dart';
// import 'top_picks.dart';

class PlacesContent extends StatefulWidget {
  const PlacesContent({super.key});

  @override
  State<PlacesContent> createState() => _PlacesContentState();
}

class _PlacesContentState extends State<PlacesContent> {
  final Map<String, List<Map<String, dynamic>>> fetchedData = {
    'case_study_destinations': [],
  };

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final destinationsService =
          Provider.of<DestinationsService>(context, listen: false);
      final collections = fetchedData.keys.toList();

      final results = await Future.wait(
        collections.map((collection) async {
          final data =
              await destinationsService.fetchDocuments(collection: collection);
          return {collection: data};
        }),
      );

      setState(() {
        for (var result in results) {
          final key = result.keys.first;
          fetchedData[key] = result[key] ?? [];
        }
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching data: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);
    // final Size screenSize = GlobalValues.screenSize(context);

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
        // popularDestionation(theme, screenSize),
        caseStudyDestinations(
          collections: "case_study_destinations",
          title: 'Popular',
          context: context,
        ),
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

  // Widget popularDestionation(ThemeData theme, Size screenSize) {
  //   final double cardSize = screenSize.width / 2;

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 25),
  //     child: Column(
  //       children: [
  //         const SizedBox(height: 20),
  //         const CardsHeader(cardsTitle: 'Popular'),
  //         const SizedBox(height: 10),
  //         SizedBox(
  //           height: cardSize,
  //           child: RotatedBox(
  //             quarterTurns: -1,
  //             child: ListWheelScrollView(
  //               itemExtent: cardSize,
  //               squeeze: 1.05,
  //               physics: const FixedExtentScrollPhysics(),
  //               children: popularList.map(
  //                 (popularData) {
  //                   return RotatedBox(
  //                     quarterTurns: 1,
  //                     child: CardsEmerged(
  //                       destinationData: popularData,
  //                     ),
  //                   );
  //                 },
  //               ).toList(),
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //           child: Text(
  //             'Explore trending spots that travelers love right now. Start your journey today and let your curiosity guide you! 🔥',
  //             style: theme.textTheme.bodyMedium,
  //             textAlign: TextAlign.center,
  //             maxLines: 4,
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget caseStudyDestinations({
    required String collections,
    required String title,
    required BuildContext context,
  }) {
    final double cardSize = MediaQuery.of(context).size.width / 2;
    final List<Map<String, dynamic>> caseStudies =
        fetchedData[collections] ?? [];

    return dataSection(
      title: title,
      cardSize: cardSize,
      data: caseStudies,
      context: context,
    );
  }

  Widget dataSection({
    required String title,
    required double cardSize,
    required List<Map<String, dynamic>> data,
    required BuildContext context,
  }) {
    if (data.isEmpty) {
      final ThemeData theme = Theme.of(context);
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          '$title: No data yet',
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          CardsHeader(
            cardsTitle: title,
            destinationData: data,
          ),
          SizedBox(
            height: cardSize,
            child: RotatedBox(
              quarterTurns: -1,
              child: ListWheelScrollView(
                itemExtent: cardSize,
                squeeze: 1.05,
                physics: const FixedExtentScrollPhysics(),
                children: data.map((item) {
                  return RotatedBox(
                    quarterTurns: 1,
                    child: CardsEmerged(
                      destinationData: item,
                    ),
                  );
                }).toList(),
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
