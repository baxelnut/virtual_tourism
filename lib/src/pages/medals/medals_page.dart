import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/cards/medals_cards.dart';
import '../../services/firebase/api/firebase_api.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Medals')),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, bool>>(
          future: countriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No data available.'),
              );
            } else {
              final countries = snapshot.data!;

              return Column(
                children: [
                  MedalsCards(
                    title: 'Passports',
                    countries: countries,
                  ),
                  MedalsCards(
                    title: 'Medals TEst',
                    countries: countries,
                  ),
                  const SizedBox(height: 100),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
