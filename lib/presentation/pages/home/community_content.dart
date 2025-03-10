import 'package:flutter/material.dart';

import '../../widgets/cards/cards_header.dart';
import '../../widgets/cards/comm_cards_large.dart';
import '../../widgets/cards/comm_cards_medium.dart';
import '../../widgets/cards/comm_cards_small.dart';
import '../../widgets/cards/comm_circle_avatar.dart';

class CommunityContent extends StatelessWidget {
  const CommunityContent({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Text(
            'Welcome to the Community!',
            style: theme.textTheme.displayMedium,
            textAlign: TextAlign.start,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "Join fellow explorers, share your adventures, and engage with like-minded travelers from around the world. Start connecting today!",
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.left,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        topChicken(),
        const SizedBox(height: 20),
        topCommunity(),
        const SizedBox(height: 20),
        yourFavourite(theme: theme),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget topChicken() {
    return const Column(
      children: [
        CardsHeader(cardsTitle: ''),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              CommCardsSmall(
                title: 'Tony',
                imagePath:
                    'https://d1ef7ke0x2i9g8.cloudfront.net/hong-kong/_large700/2143830/LC-Sign-Tony-interview-Big-Hitter-header.webp',
              ),
              CommCardsSmall(
                title: 'Freddie',
                imagePath:
                    'https://static.wikia.nocookie.net/record-of-ragnarok-fanon/images/6/6e/Freddie_Mercury.png/revision/latest?cb=20231101005916',
              ),
              CommCardsSmall(
                title: 'Mbappé',
                imagePath:
                    'https://img.a.transfermarkt.technology/portrait/big/342229-1682683695.jpg?lm=1',
              ),
              CommCardsSmall(
                title: 'Rich Brian',
                imagePath:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2G0BDjxqieGz8hWeM7300NpX0JOZHw0CaHg&s',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget topCommunity() {
    return const Column(
      children: [
        SizedBox(height: 20),
        CardsHeader(cardsTitle: 'Top Communities'),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              CommCardsMedium(
                imagePath:
                    'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f',
                title: 'Lorem ipsum dolor sit amet',
                subtitle:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
              ),
              CommCardsMedium(
                imagePath:
                    'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f',
                title: 'LOREM IPSUM',
                subtitle:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
              ),
              CommCardsMedium(
                imagePath:
                    'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f',
                title: 'LOREM IPSUM',
                subtitle:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              CommCardsLarge(
                imagePath:
                    'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f',
                title: 'Lorem Ipsum',
                subtitle:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
              ),
              CommCardsLarge(
                imagePath:
                    'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f',
                title: 'Lorem Ipsum',
                subtitle:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
              ),
              CommCardsLarge(
                imagePath:
                    'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f',
                title: 'Lorem Ipsum',
                subtitle:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
              ),
              CommCardsLarge(
                imagePath:
                    'https://i.scdn.co/image/ab6761610000e5eb7da39dea0a72f581535fb11f',
                title: 'Lorem Ipsum',
                subtitle:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget yourFavourite({
    required ThemeData theme,
  }) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const CardsHeader(cardsTitle: 'Your Favourite'),
        const SizedBox(height: 10),
        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              CommCircleAvatar(
                url:
                    'https://cdn.britannica.com/65/227665-050-D74A477E/American-actor-Leonardo-DiCaprio-2016.jpg?w=400&h=300&c=crop',
              ),
              CommCircleAvatar(
                url:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFomk8lsRfYdSYD7k00kmRkdbqhVnGbAVnSQ&s',
              ),
              CommCircleAvatar(
                url:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSmpg5cF44Ud9L80mQ2tD2fPLj2-Dz-QIDlpIc8ajO7j8aV9r4eKj_YN4VB71BIDvu2ZfE&usqp=CAU',
              ),
              CommCircleAvatar(
                url:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWX7UsSatwCLMahLs2Pxv4TY7s0vZWAcV8qh3vkspwlTshm272X3UTCGHxUa3of6zM_9c&usqp=CAU',
              ),
              CommCircleAvatar(
                url:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyogu5ir7qAcouIc6a3rDR_cIHg3CRNrU5JQ&s',
              ),
              CommCircleAvatar(
                url:
                    'https://www.wowkeren.com/images/news/medium/2017/00186082.jpg',
              ),
              CommCircleAvatar(
                url:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpz1c5CLJ-G6nnvOVH3UOe8iEewpPB11lgww&s',
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "Stay connected with your favorite travelers and personalities. Follow their journeys and be inspired 🌟",
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
