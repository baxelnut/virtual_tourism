import 'package:flutter/material.dart';
import '../../components/cards/bookmarks_cards.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  List<Widget> _buildBookmarkCards(int count) {
    return List.generate(count, (index) => const BookmarksCards());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Wrap(
                children: _buildBookmarkCards(10),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
