import 'package:flutter/material.dart';

import '../../services/firebase/api/firebase_api.dart';
import '../example_pages/tour_example_page.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Tour'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TourExamplePage(),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: tours0.map((destinationData) {
                      return FutureBuilder<Map<String, dynamic>?>(
                        future:
                            firebaseApi.getUserData(destinationData['userId']),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return TourCard(
                              userProfile: '',
                              destinationData: destinationData,
                            );
                          }

                          final userData = snapshot.data;
                          final userProfile = userData?['imageUrl'] ?? '';

                          return TourCard(
                            userProfile: userProfile,
                            destinationData: destinationData,
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
