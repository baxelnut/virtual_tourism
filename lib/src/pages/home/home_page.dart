import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../components/thumbnail.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> imagePaths = [
      {
        'image': 'assets/images/balcony_water.jpg',
        'thumb': 'assets/images/thumbs/balcony_water_thumb.webp'
      },
      {
        'image': 'assets/images/boat.jpg',
        'thumb': 'assets/images/thumbs/boat_thumb.webp'
      },
      {
        'image': 'assets/images/carlsbad_nps.jpg',
        'thumb': 'assets/images/thumbs/carlsbad_nps_thumb.webp'
      },
      {
        'image': 'assets/images/carlsbad.jpg',
        'thumb': 'assets/images/thumbs/carlsbad_thumb.jpg'
      },
      {
        'image': 'assets/images/dock.jpg',
        'thumb': 'assets/images/thumbs/dock_thumb.webp'
      },
      {
        'image': 'assets/images/game_world.jpeg',
        'thumb': 'assets/images/thumbs/game_world_thumb.webp'
      },
      {
        'image': 'assets/images/lagoon.jpg',
        'thumb': 'assets/images/thumbs/lagoon_thumb.webp'
      },
      {
        'image': 'assets/images/mountain.jpg',
        'thumb': 'assets/images/thumbs/mountain_thumb.webp'
      },
      {
        'image': 'assets/images/planet.jpeg',
        'thumb': 'assets/images/thumbs/planet_thumb.webp'
      },
      {
        'image': 'assets/images/room.jpeg',
        'thumb': 'assets/images/thumbs/room_thumb.webp'
      },
      {
        'image': 'assets/images/trees.jpeg',
        'thumb': 'assets/images/thumbs/trees_thumb.webp'
      },
      {
        'image': 'assets/images/bunker.jpeg',
        'thumb': 'assets/images/thumbs/bunker_thumb.webp'
      },
      {
        'image': 'assets/images/grocery.jpeg',
        'thumb': 'assets/images/thumbs/grocery_thumb.webp'
      },
    ];

    final List<Thumbnail> thumbList = imagePaths
        .map((image) => Thumbnail(
              imagePath: image['image']!,
              thumbPath: image['thumb']!,
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
