import 'package:flutter/material.dart';

import '../../components/medals_cards.dart';

class MedalsPage extends StatelessWidget {
  const MedalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Medals')),
      ),
      body: const Column(
        children: [
          MedalsCards(
            title: 'Passports',
            progress: '0/100',
            medalName: 'this is your medal',
          ),
        ],
      ),
    );
  }
}
