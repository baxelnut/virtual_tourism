import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/theme/theme.dart';
import '../data/theme/theme_provider.dart';

class UserOverview extends StatefulWidget {
  final String username;
  final String imagePath;
  final bool isFull;
  final String email;
  const UserOverview(
      {super.key,
      required this.username,
      required this.imagePath,
      required this.isFull,
      required this.email});

  @override
  State<UserOverview> createState() => _UserOverviewState();
}

class _UserOverviewState extends State<UserOverview> {
  handleShowPict() {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: AspectRatio(
            aspectRatio: 1.0,
            child: Image.asset(
              widget.imagePath,
              fit: BoxFit.cover,
            ),
          ),
          content: const Text('This is your profile picture',
              textAlign: TextAlign.center),
        );
      },
    );
  }

  handleEditProfile() {
    return print('edit profile bro');
  }

  handleBookmarks() {
    return print('handle bookmarks blud');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark =
        Provider.of<ThemeProvider>(context).themeData == darkMode;
    // final screenSize = MediaQuery.of(context).size;
    if (widget.isFull) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: GestureDetector(
                onTap: () {
                  handleShowPict();
                },
                child: CircleAvatar(
                    radius: 50, backgroundImage: AssetImage(widget.imagePath)),
              ),
            ),
            Text(
              widget.username,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              widget.email,
              style: theme.textTheme.labelMedium,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary),
                  onPressed: () {
                    handleEditProfile();
                  },
                  child: Text(
                    'Edit Profile',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: theme.colorScheme.onSecondary),
                  )),
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: [
            Expanded(
                child: GestureDetector(
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(builder: (context) => const SettingsPage()),
                // );
                print('go to settings page');
              },
              child: Text.rich(
                TextSpan(
                  text: 'Hi, ',
                  style: theme.textTheme.bodyLarge,
                  children: [
                    TextSpan(
                      text: widget.username,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )),
            GestureDetector(
              onTap: () {
                handleBookmarks();
              },
              child:  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Icon(isDark
                    ? Icons.bookmarks_outlined
                    : Icons.bookmarks_rounded),
              ),
            ),
            GestureDetector(
              onTap: () {
                handleShowPict();
              },
              child:
                  CircleAvatar(backgroundImage: AssetImage(widget.imagePath)),
            ),
          ],
        ),
      );
    }
  }
}
