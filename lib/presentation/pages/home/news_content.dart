import 'package:flutter/material.dart';

import '../../widgets/cards/cards_header.dart';
import '../../widgets/cards/news_cards_large.dart';
import '../../widgets/cards/news_tiles.dart';

class NewsContent extends StatelessWidget {
  const NewsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // temporary
    const String loremIpsum =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?\n';

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
        topNewsLarge(
          newsContent: loremIpsum,
        ),
        discoverNews(
          newsContent: loremIpsum,
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget topNewsLarge({
    required String newsContent,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          NewsCardsLarge(
            imagePath:
                'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f',
            publisher: 'McLovin News',
            headline:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            datePublished: '6 hours ago',
            publisherPath:
                'https://cdn-2.tstatic.net/style/foto/bank/images/potret-alex-turner-vokalis-dan-gitaris-band-arctic-monkeys.jpg',
            newsContent: newsContent,
          ),
          NewsCardsLarge(
            imagePath:
                'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f',
            publisher: 'McLovin News',
            headline:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            datePublished: '6 hours ago',
            publisherPath:
                'https://cdn-2.tstatic.net/style/foto/bank/images/potret-alex-turner-vokalis-dan-gitaris-band-arctic-monkeys.jpg',
            newsContent: newsContent,
          ),
          NewsCardsLarge(
            imagePath:
                'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f',
            publisher: 'McLovin News',
            headline:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            publisherPath:
                'https://cdn-2.tstatic.net/style/foto/bank/images/potret-alex-turner-vokalis-dan-gitaris-band-arctic-monkeys.jpg',
            datePublished: '6 hours ago',
            newsContent: newsContent,
          ),
          NewsCardsLarge(
            imagePath:
                'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f',
            publisher: 'McLovin News',
            headline:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            datePublished: '6 hours ago',
            publisherPath:
                'https://cdn-2.tstatic.net/style/foto/bank/images/potret-alex-turner-vokalis-dan-gitaris-band-arctic-monkeys.jpg',
            newsContent: newsContent,
          ),
        ],
      ),
    );
  }

  Widget discoverNews({
    required String newsContent,
  }) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const CardsHeader(cardsTitle: 'Discover'),
        NewsTiles(
          imagePath:
              'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f',
          publisher: 'Alex Turner',
          topic: 'Conservation',
          headline: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          datePublished: '29 Jan 2025',
          publisherPath:
              'https://cdn-2.tstatic.net/style/foto/bank/images/potret-alex-turner-vokalis-dan-gitaris-band-arctic-monkeys.jpg',
          newsContent: newsContent,
        ),
        NewsTiles(
          imagePath:
              'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f',
          publisher: 'Alex Turner',
          topic: 'Conservation',
          headline: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          datePublished: '29 Jan 2025',
          publisherPath:
              'https://cdn-2.tstatic.net/style/foto/bank/images/potret-alex-turner-vokalis-dan-gitaris-band-arctic-monkeys.jpg',
          newsContent: newsContent,
        ),
        NewsTiles(
          imagePath:
              'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f',
          publisher: 'Alex Turner',
          topic: 'Conservation',
          headline: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          datePublished: '29 Jan 2025',
          publisherPath:
              'https://cdn-2.tstatic.net/style/foto/bank/images/potret-alex-turner-vokalis-dan-gitaris-band-arctic-monkeys.jpg',
          newsContent: newsContent,
        ),
        NewsTiles(
          imagePath:
              'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f',
          publisher: 'Alex Turner',
          topic: 'Conservation',
          headline: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          datePublished: '29 Jan 2025',
          publisherPath:
              'https://cdn-2.tstatic.net/style/foto/bank/images/potret-alex-turner-vokalis-dan-gitaris-band-arctic-monkeys.jpg',
          newsContent: newsContent,
        ),
      ],
    );
  }
}
