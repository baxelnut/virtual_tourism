import 'package:flutter/material.dart';

import '../../services/firebase/api/firebase_api.dart';
import 'tour_collections.dart';
import 'tour_card.dart';

class TourPage extends StatefulWidget {
  const TourPage({super.key});

  @override
  State<TourPage> createState() => _TourPageState();
}

class _TourPageState extends State<TourPage> {
  final FirebaseApi firebaseApi = FirebaseApi();
  List<Map<String, dynamic>> tours0 = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTours();
  }

  Future<void> loadTours() async {
    final tours = await firebaseApi.fetchDestinations(
        collection: "verified_user_uploads");

    setState(() {
      tours0 = tours;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Tour'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TourCollections(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Text(
                'Public',
                style: theme.textTheme.headlineSmall,
              ),
            ),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: tours0.map((destinationData) {
                      return FutureBuilder<Map<String, dynamic>?>(
                        future: firebaseApi
                            .getUserData(destinationData['userId'] ?? ''),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return TourCard(
                              userProfile: '',
                              destinationData: destinationData,
                              theId: destinationData['id'],
                            );
                          }

                          final userData = snapshot.data;
                          final userProfile = userData?['imageUrl'] ?? '';

                          return TourCard(
                            userProfile: userProfile,
                            destinationData: destinationData,
                            theId: destinationData['id'],
                          );
                        },
                      );
                    }).toList(),
                  ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
