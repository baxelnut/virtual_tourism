import 'package:flutter/material.dart';

import '../../components/cards_header.dart';
import '../../components/chips_component.dart';
import '../home/user_overview.dart';

class TourPage extends StatelessWidget {
  const TourPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ChipsComponent()'),
            Divider(),
            UserOverview(
              username: '_username_',
            ),
            UserOverview(
              username: 'bazelnut',
            ),
            UserOverview(
              username: 'Jeremiah',
            ),
            Text('ChipsComponent()'),
            Divider(),
            ChipsComponent(
              listOfThangz: ['Places', 'Conservation', 'News'],
            ),
            SizedBox(
              height: 50,
            ),
            Text('CardsHeader()'),
            Divider(),
            CardsHeader(
              cardsTitle: 'Top Picks',
            ),
            CardsHeader(
              cardsTitle: 'Top Countries',
            ),
            CardsHeader(
              cardsTitle: 'Popular',
            ),
          ],
        ),
      ),
    );
  }
}
