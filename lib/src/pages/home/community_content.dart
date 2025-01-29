import 'package:flutter/material.dart';

import '../../components/cards_header.dart';
import '../../components/comm_cards_large.dart';
import '../../components/comm_cards_medium.dart';
import '../../components/comm_cards_small.dart';
import '../../components/comm_circle_avatar.dart';

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
        topChicken(),
        const SizedBox(height: 20),
        topCommunity(),
        const SizedBox(height: 20),
        yourFavourite(),
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
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Badaling_China_Great-Wall-of-China-01.jpg/360px-Badaling_China_Great-Wall-of-China-01.jpg',
                title: 'Lorem ipsum dolor sit amet',
                subtitle:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
              ),
              CommCardsMedium(
                imagePath:
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Badaling_China_Great-Wall-of-China-01.jpg/360px-Badaling_China_Great-Wall-of-China-01.jpg',
                title: 'LOREM IPSUM',
                subtitle:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
              ),
              CommCardsMedium(
                imagePath:
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Badaling_China_Great-Wall-of-China-01.jpg/360px-Badaling_China_Great-Wall-of-China-01.jpg',
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
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/View_of_Mount_Fuji_from_%C5%8Cwakudani_20211202.jpg/1200px-View_of_Mount_Fuji_from_%C5%8Cwakudani_20211202.jpg',
                title: 'Lorem Ipsum',
                subtitle:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
              ),
              CommCardsLarge(
                imagePath:
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/View_of_Mount_Fuji_from_%C5%8Cwakudani_20211202.jpg/1200px-View_of_Mount_Fuji_from_%C5%8Cwakudani_20211202.jpg',
                title: 'Lorem Ipsum',
                subtitle:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
              ),
              CommCardsLarge(
                imagePath:
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/View_of_Mount_Fuji_from_%C5%8Cwakudani_20211202.jpg/1200px-View_of_Mount_Fuji_from_%C5%8Cwakudani_20211202.jpg',
                title: 'Lorem Ipsum',
                subtitle:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
              ),
              CommCardsLarge(
                imagePath:
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/View_of_Mount_Fuji_from_%C5%8Cwakudani_20211202.jpg/1200px-View_of_Mount_Fuji_from_%C5%8Cwakudani_20211202.jpg',
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

  Widget yourFavourite() {
    return const Column(
      children: [
        SizedBox(height: 20),
        CardsHeader(cardsTitle: 'Your Favourite'),
        SizedBox(height: 10),
        SingleChildScrollView(
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
      ],
    );
  }
}
