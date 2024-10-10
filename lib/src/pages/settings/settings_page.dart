import 'package:flutter/material.dart';

import '../../components/user_overview.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            UserOverview(
              username: 'Basil',
              imagePath: 'assets/profile.jpg',
              isFull: true,
              email: 'basiliustengang24@gmail.com',
            ),
          ],
        ),
      ),
    );
  }
}
