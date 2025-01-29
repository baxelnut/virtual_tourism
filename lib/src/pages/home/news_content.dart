import 'package:flutter/material.dart';

import '../../components/cards_header.dart';
import '../../components/news_cards_large.dart';
import '../../components/news_tiles.dart';

class NewsContent extends StatelessWidget {
  const NewsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'News',
            style: theme.textTheme.displayMedium,
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: 20),
        topNewsLarge(),
        discoverNews(),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget topNewsLarge() {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          NewsCardsLarge(
            imagePath:
                'https://img.bleacherreport.net/img/images/photos/003/633/033/hi-res-adb5ec5ce649bedb7a531cf819e7803d_crop_north.jpg?1476736156&w=3072&h=2048',
            publisher: 'McLovin News',
            headline:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            timePublished: '6 hours ago',
          ),
          NewsCardsLarge(
            imagePath:
                'https://img.bleacherreport.net/img/images/photos/003/633/033/hi-res-adb5ec5ce649bedb7a531cf819e7803d_crop_north.jpg?1476736156&w=3072&h=2048',
            publisher: 'McLovin News',
            headline:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            timePublished: '6 hours ago',
          ),
          NewsCardsLarge(
            imagePath:
                'https://img.bleacherreport.net/img/images/photos/003/633/033/hi-res-adb5ec5ce649bedb7a531cf819e7803d_crop_north.jpg?1476736156&w=3072&h=2048',
            publisher: 'McLovin News',
            headline:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            timePublished: '6 hours ago',
          ),
          NewsCardsLarge(
            imagePath:
                'https://img.bleacherreport.net/img/images/photos/003/633/033/hi-res-adb5ec5ce649bedb7a531cf819e7803d_crop_north.jpg?1476736156&w=3072&h=2048',
            publisher: 'McLovin News',
            headline:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            timePublished: '6 hours ago',
          ),
        ],
      ),
    );
  }

  Widget discoverNews() {
    return const Column(
      children: [
        SizedBox(height: 20),
        CardsHeader(cardsTitle: 'Discover'),
        NewsTiles(
          imagePath:
              'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f',
          publisher: 'Alex Turner',
          topic: 'Conservation',
          headline: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          datePublished: '29 Jan 2025',
          publisherPath:
              'https://i.pinimg.com/736x/a2/6d/5d/a26d5da94d71c2c7e56b0b7cf3955ad3.jpg',
        ),
        NewsTiles(
          imagePath:
              'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f',
          publisher: 'Alex Turner',
          topic: 'Conservation',
          headline: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          datePublished: '29 Jan 2025',
          publisherPath:
              'https://i.pinimg.com/736x/a2/6d/5d/a26d5da94d71c2c7e56b0b7cf3955ad3.jpg',
        ),
        NewsTiles(
          imagePath:
              'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f',
          publisher: 'Alex Turner',
          topic: 'Conservation',
          headline: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          datePublished: '29 Jan 2025',
          publisherPath:
              'https://i.pinimg.com/736x/a2/6d/5d/a26d5da94d71c2c7e56b0b7cf3955ad3.jpg',
        ),
        NewsTiles(
          imagePath:
              'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f',
          publisher: 'Alex Turner',
          topic: 'Conservation',
          headline: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          datePublished: '29 Jan 2025',
          publisherPath:
              'https://i.pinimg.com/736x/a2/6d/5d/a26d5da94d71c2c7e56b0b7cf3955ad3.jpg',
        ),
      ],
    );
  }
}
