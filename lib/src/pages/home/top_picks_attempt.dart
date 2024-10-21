import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../components/cards_curved.dart';
import '../../components/cards_header.dart';

class TopPicks extends StatelessWidget {
  const TopPicks({super.key});

  Future<List<Map<String, dynamic>>> fetchTopPicks() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('example_destinations')
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching top picks: $e');
      return [];
    }
  }

  Future<String> getThumbnailUrl(String destinationId) async {
    final List<String> extensions = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'webp'
    ];

    for (final ext in extensions) {
      final path = 'example_images/${destinationId}_thumbnail.$ext';
      try {
        return await FirebaseStorage.instance.ref(path).getDownloadURL();
      } catch (e) {
        if (e.toString().contains('object-not-found')) {
          print('Error fetching thumbnail image: $e');
          continue; // Continue to the next extension if not found
        }
      }
    }
    return ''; // Return empty string if no image found
  }

  Future<String> getImageUrl(String destinationId) async {
    final List<String> extensions = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'webp'
    ];

    for (final ext in extensions) {
      final path = 'example_images/${destinationId}.$ext';
      try {
        return await FirebaseStorage.instance.ref(path).getDownloadURL();
      } catch (e) {
        if (e.toString().contains('object-not-found')) {
          print('Error fetching main image: $e');
          continue; // Continue to the next extension if not found
        }
      }
    }
    return ''; // Return empty string if no image found
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchTopPicks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No top picks found.'));
        }

        final topPicksDataList = snapshot.data!;

        return Column(
          children: [
            const CardsHeader(cardsTitle: 'Top Picks'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: topPicksDataList.map((topPicksData) {
                  final destination = topPicksData['destination']
                          ?.replaceAll('_', ' ')
                          .split(' ')
                          .map((word) =>
                              '${word[0].toUpperCase()}${word.substring(1)}')
                          .join(' ') ?? 'Unknown';
                  final description = topPicksData['description'] ?? 'No description available.';
                  final String? destinationId = topPicksData['id'];

                  // Ensure destinationId is not null
                  if (destinationId == null) {
                    return CardsCurved(
                      destination: destination,
                      description: description,
                      thumbnailPath: '', // or some placeholder
                      imagePath: '', // or some placeholder
                    );
                  }

                  // Future for thumbnail and main image URLs
                  final thumbnailFuture = getThumbnailUrl(destinationId);
                  final imageFuture = getImageUrl(destinationId);

                  return FutureBuilder<List<String>>(
                    future: Future.wait([thumbnailFuture, imageFuture]),
                    builder: (context, imageSnapshot) {
                      if (imageSnapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 50,
                          width: 50,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (imageSnapshot.hasError) {
                        return CardsCurved(
                          destination: destination,
                          description: description,
                          thumbnailPath: '', // Handle error case
                          imagePath: '', // Handle error case
                        );
                      }

                      final String thumbnailPath = imageSnapshot.data![0] ?? '';
                      final String imagePath = imageSnapshot.data![1] ?? '';

                      return CardsCurved(
                        destination: destination,
                        description: description,
                        thumbnailPath: thumbnailPath,
                        imagePath: imagePath,
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
