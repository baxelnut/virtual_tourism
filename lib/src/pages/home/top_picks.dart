import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../components/cards/cards_curved.dart';
import '../../components/cards/cards_header.dart';

class TopPicks extends StatefulWidget {
  const TopPicks({super.key});

  @override
  State<TopPicks> createState() => _TopPicksState();
}

class _TopPicksState extends State<TopPicks> {
  late Future<List<Map<String, dynamic>>> _fetchTopPicksFuture;

  @override
  void initState() {
    super.initState();
    _fetchTopPicksFuture = fetchTopPicks();
  }

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
      // ignore: avoid_print
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
          continue;
        }
      }
    }
    return '';
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
      final path = 'example_images/$destinationId.$ext';
      try {
        return await FirebaseStorage.instance.ref(path).getDownloadURL();
      } catch (e) {
        if (e.toString().contains('object-not-found')) {
          continue;
        }
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CardsHeader(cardsTitle: 'Top Picks'),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchTopPicksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No top picks found.'));
            }

            final topPickList = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: topPickList.map((topPicksData) {
                  final String destinationName =
                      (topPicksData['destination'] as String?)
                              ?.replaceAll('_', ' ') ??
                          'Unknown';
                  final String description =
                      (topPicksData['description'] as String?) ??
                          'No description available.';
                  final String? destinationId = topPicksData['id'];

                  if (destinationId == null) {
                    return const SizedBox.shrink();
                  }

                  return FutureBuilder<String>(
                    future: getThumbnailUrl(destinationId),
                    builder: (context, thumbnailSnapshot) {
                      if (thumbnailSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width / 1.9,
                          height: MediaQuery.of(context).size.height / 2.5,
                          child:
                              const Center(child: CircularProgressIndicator()),
                        );
                      } else if (thumbnailSnapshot.hasError) {
                        return const SizedBox.shrink();
                      }

                      final String thumbnailPath = thumbnailSnapshot.data ?? '';
                      return FutureBuilder<String>(
                        future: getImageUrl(destinationId),
                        builder: (context, imageSnapshot) {
                          if (imageSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width / 1.9,
                              height: MediaQuery.of(context).size.height / 2.5,
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            );
                          } else if (imageSnapshot.hasError) {
                            return const SizedBox.shrink();
                          }

                          final String imagePath = imageSnapshot.data ?? '';

                          return CardsCurved(
                            destination: destinationName
                                .split(' ')
                                .map((word) =>
                                    '${word[0].toUpperCase()}${word.substring(1)}')
                                .join(' '),
                            description: description,
                            thumbnailPath: thumbnailPath,
                            imagePath: imagePath,
                          );
                        },
                      );
                    },
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}
