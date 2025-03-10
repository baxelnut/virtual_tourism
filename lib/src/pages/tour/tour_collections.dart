import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/cards/cards_emerged.dart';
import '../../components/cards/cards_header.dart';
import '../../services/firebase/api/firebase_api.dart';

class TourCollections extends StatefulWidget {
  const TourCollections({super.key});

  @override
  State<TourCollections> createState() => _TourCollectionsState();
}

class _TourCollectionsState extends State<TourCollections> {
  final Map<String, List<Map<String, dynamic>>> fetchedData = {
    'case_study_destinations': [],
    'verified_user_uploads': [],
  };

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final firebaseApi = Provider.of<FirebaseApi>(context, listen: false);
      final collections = fetchedData.keys.toList();

      final results = await Future.wait(
        collections.map((collection) async {
          final data = await firebaseApi.fetchDocuments(collection: collection);
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          caseStudyDestinations(
              collections: "verified_user_uploads",
              title: 'by Users',
              context: context),
          caseStudyDestinations(
              collections: "case_study_destinations",
              title: 'La Silla',
              context: context),
        ],
      ),
    );
  }

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
    );
  }

  Widget dataSection(
      {required String title,
      required double cardSize,
      required List<Map<String, dynamic>> data}) {
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
        ],
      ),
    );
  }
}
