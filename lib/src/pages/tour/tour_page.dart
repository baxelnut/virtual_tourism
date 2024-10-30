import 'package:flutter/material.dart';

import 'example_page.dart';

class TourPage extends StatelessWidget {
  const TourPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Example Page'),
        ),
      ),
      body: const ExamplePage(),
    );
  }
}
