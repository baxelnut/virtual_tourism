import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/cards/cards_emerged.dart';
import '../../components/cards/cards_header.dart';
import '../../services/firebase/api/firebase_api.dart';

class TourExamplePage extends StatefulWidget {
  const TourExamplePage({super.key});

  @override
  State<TourExamplePage> createState() => _TourExamplePageState();
}

class _TourExamplePageState extends State<TourExamplePage> {
  List<Map<String, dynamic>> caseStudies = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final firebaseApi = Provider.of<FirebaseApi>(context, listen: false);
    final data = await firebaseApi.fetchDocuments();
    setState(() {
      caseStudies = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            caseStudyDestinations(context),
            caseStudyDestinations(context),
            caseStudyDestinations(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget caseStudyDestinations(BuildContext context) {
    final double cardSize = MediaQuery.of(context).size.width / 2;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        children: [
          const CardsHeader(
            cardsTitle: 'La Silla',
          ),
          SizedBox(
            height: cardSize,
            child: RotatedBox(
              quarterTurns: -1,
              child: ListWheelScrollView(
                itemExtent: cardSize,
                squeeze: 1.05,
                physics: const FixedExtentScrollPhysics(),
                children: caseStudies.map((caseStudy) {
                  return RotatedBox(
                    quarterTurns: 1,
                    child: CardsEmerged(
                      destinationData: caseStudy,
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
