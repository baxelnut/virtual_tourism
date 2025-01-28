import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/cards_emerged.dart';
import '../../components/cards_header.dart';
import '../../components/cards_linear.dart';
import '../../components/chips_component.dart';
import '../../components/comm_cards_large.dart';
import '../../components/comm_cards_medium.dart';
import '../../components/comm_cards_small.dart';
import '../../components/comm_circle_avatar.dart';
import '../../components/user_overview.dart';
import '../../services/destination_data.dart';

class HomePage extends StatefulWidget {
  final Function(int) onPageChange;
  const HomePage({super.key, required this.onPageChange});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _loadSelectedTab();
  }

  Future<void> _loadSelectedTab() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedTab =
          prefs.getInt('selectedTab') ?? 0; // Default to 0 if no value exists.
    });
  }

  Future<void> _saveSelectedTab(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedTab', index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              homeHeader(),
              _buildTabContent(),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }

  Widget homeHeader() {
    return Column(
      children: [
        const SizedBox(height: 10),
        UserOverview(
          isFull: false,
          onPageChange: widget.onPageChange,
        ),
        const SizedBox(height: 20),
        ChipsComponent(
          listOfThangz: const ['Places', 'Community', 'News'],
          selectedIndex: _selectedTab,
          onTabChange: (index) {
            setState(() {
              _selectedTab = index;
            });
            _saveSelectedTab(index);
          },
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 1: // Community
        return _buildCommunityContent();
      case 2: // News
        return _buildNewsContent();
      default: // Places (default tab)
        return _buildPlacesContent();
    }
  }

  Widget _buildPlacesContent() {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Text(
            'Where do we go now?',
            style: theme.textTheme.displayMedium,
          ),
        ),
        topCountries(),
        popularDestionation(context),
      ],
    );
  }

  Widget _buildCommunityContent() {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Text(
            'Welcome to the Community!',
            style: theme.textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
        ),
        CommCardsMedium(),
        topChicken(),
        yourFavChicken(),
        const CommCardsLarge(), // community cards large component. bruh.
        
      ],
    );
  }

  Widget _buildNewsContent() {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Latest News',
        style: theme.textTheme.displayMedium,
      ),
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

  Widget yourFavChicken() {
    return const Column(
      children: [
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

  Widget topCountries() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const CardsHeader(cardsTitle: 'Top Countries'),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: countriesList.map(
              (countryData) {
                return CardsLinear(
                  flag: countryData['flag']!,
                  country: countryData['country']!,
                  thumbnailPath: countryData['thumbnailPath']!,
                  imagePath: countryData['imagePath']!,
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }

  Widget popularDestionation(BuildContext context) {
    final double cardSize = MediaQuery.of(context).size.width / 2;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CardsHeader(cardsTitle: 'Popular'),
          const SizedBox(height: 10),
          SizedBox(
            height: cardSize,
            child: RotatedBox(
              quarterTurns: -1,
              child: ListWheelScrollView(
                itemExtent: cardSize,
                squeeze: 1.05,
                physics: const FixedExtentScrollPhysics(),
                children: popularList.map(
                  (popularData) {
                    return RotatedBox(
                      quarterTurns: 1,
                      child: CardsEmerged(
                        destinationData: popularData,
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
