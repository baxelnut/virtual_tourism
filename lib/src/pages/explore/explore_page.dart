import 'package:flutter/material.dart';

import '../../components/cards_curved.dart';
import '../../components/cards_emerged.dart';
import '../../components/cards_header.dart';
import '../../components/cards_linear.dart';
import '../../components/chips_component.dart';
import '../home/user_overview.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          // must be applied to all pages
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UserOverview(username: 'Jeremiah'),
              const ChipsComponent(
                  listOfThangz: ['Places', 'Conservation', 'News']),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Where do we go now?',
                  style: theme.textTheme.displayLarge,
                ),
              ),
              const CardsHeader(cardsTitle: 'Top Picks'),
              const CardsCurved(
                title: 'LOREM IPSUM',
                subtitle:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
              ),
              const SizedBox(
                height: 50,
              ),
              const CardsLinear(),
              const SizedBox(
                height: 50,
              ),
              const CardsEmerged()
            ],
          ),
        ),
      ),
    );
  }
}
