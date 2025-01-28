import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/cards_emerged.dart';
import '../../components/cards_header.dart';
import '../../components/cards_linear.dart';
import '../../components/chips_component.dart';
import '../../components/user_overview.dart';
import '../../services/destination_data.dart';
// import 'top_picks.dart';

class HomePage extends StatefulWidget {
  final Function(int) onPageChange;
  const HomePage({super.key, required this.onPageChange});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  // 0: Places, 1: Community, 2: News
  int _selectedTab = 0;

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
        const SizedBox(height: 20),
        UserOverview(
          isFull: false,
          onPageChange: widget.onPageChange,
        ),
        const SizedBox(height: 20),
        ChipsComponent(
          listOfThangz: const ['Places', 'Community', 'News'],
          onTabChange: (index) {
            setState(() {
              _selectedTab = index;
            });
          },
        ),
        const SizedBox(height: 20),
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
    final theme = Theme.of(context);

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
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Text(
            'Welcome to the Community!',
            style: theme.textTheme.displayMedium,
          ),
        ),
        Container(
          width: 100,
          height: 100,
          color: Colors.amber, 
        ),
      ],
    );
  }

  Widget _buildNewsContent() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Latest News',
        style: theme.textTheme.displayMedium,
      ),
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
