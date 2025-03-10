import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/global_values.dart';
import '../../../services/firebase/api/firebase_api.dart';
import 'medals_cards.dart';

class MedalsPage extends StatefulWidget {
  const MedalsPage({super.key});

  @override
  State<MedalsPage> createState() => _MedalsPageState();
}

class _MedalsPageState extends State<MedalsPage> {
  late Future<Map<String, bool>> countriesFuture;

  @override
  void initState() {
    super.initState();
    countriesFuture = fetchPassport();
  }

  Future<Map<String, bool>> fetchPassport() async {
    try {
      final firebaseApi = Provider.of<FirebaseApi>(context, listen: false);
      final data = await firebaseApi.fetchPassport();
      return data;
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching passport data: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = GlobalValues.screenSize(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: const Text('Medals'),
            centerTitle: true,
          ),
          SliverToBoxAdapter(
            child: FutureBuilder<Map<String, bool>>(
              future: countriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: screenSize.height - 120,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return SizedBox(
                    height: screenSize.height - 120,
                    child: Center(
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return SizedBox(
                    height: screenSize.height - 120,
                    child: Center(
                      child: Text('No data available.'),
                    ),
                  );
                } else {
                  final countries = snapshot.data!;

                  return Column(
                    children: [
                      MedalsCards(
                        title: 'Passports',
                        countries: countries,
                      ),
                      SizedBox(height: screenSize.width / 3),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
