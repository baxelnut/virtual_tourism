import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../components/thumbnail.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

    @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> imagePaths = [
      {
        'imagePath': 'assets/images/balcony_water.jpg',
        'thumbnailPath': 'assets/images/thumbs/balcony_water_thumb.webp'
      },
      {
        'imagePath': 'assets/images/boat.jpg',
        'thumbnailPath': 'assets/images/thumbs/boat_thumb.webp'
      },
      {
        'imagePath': 'assets/images/carlsbad_nps.jpg',
        'thumbnailPath': 'assets/images/thumbs/carlsbad_nps_thumb.webp'
      },
      {
        'imagePath': 'assets/images/carlsbad.jpg',
        'thumbnailPath': 'assets/images/thumbs/carlsbad_thumb.jpg'
      },
      {
        'imagePath': 'assets/images/dock.jpg',
        'thumbnailPath': 'assets/images/thumbs/dock_thumb.webp'
      },
      {
        'imagePath': 'assets/images/game_world.jpeg',
        'thumbnailPath': 'assets/images/thumbs/game_world_thumb.webp'
      },
      {
        'imagePath': 'assets/images/lagoon.jpg',
        'thumbnailPath': 'assets/images/thumbs/lagoon_thumb.webp'
      },
      {
        'imagePath': 'assets/images/mountain.jpg',
        'thumbnailPath': 'assets/images/thumbs/mountain_thumb.webp'
      },
      {
        'imagePath': 'assets/images/planet.jpeg',
        'thumbnailPath': 'assets/images/thumbs/planet_thumb.webp'
      },
      {
        'imagePath': 'assets/images/room.jpeg',
        'thumbnailPath': 'assets/images/thumbs/room_thumb.webp'
      },
      {
        'imagePath': 'assets/images/trees.jpeg',
        'thumbnailPath': 'assets/images/thumbs/trees_thumb.webp'
      },
      {
        'imagePath': 'assets/images/bunker.jpeg',
        'thumbnailPath': 'assets/images/thumbs/bunker_thumb.webp'
      },
      {
        'imagePath': 'assets/images/grocery.jpeg',
        'thumbnailPath': 'assets/images/thumbs/grocery_thumb.webp'
      },
    ];

    final List<Thumbnail> thumbList = imagePaths
        .map((image) => Thumbnail(
              imagePath: image['imagePath']!,
              thumbPath: image['thumbnailPath']!,
            ))
        .toList();

    return SafeArea(
      child: kIsWeb
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1.5,
                ),
                itemCount: thumbList.length,
                itemBuilder: (context, index) => thumbList[index],
              ),
            )
          : ListView.builder(
              itemCount: thumbList.length,
              itemBuilder: (context, index) => thumbList[index],
            ),
    );
  }

}