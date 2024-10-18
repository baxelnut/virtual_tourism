import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme/theme.dart';
import '../services/theme/theme_provider.dart';
import '../pages/settings/user_profile.dart';

class UserOverview extends StatefulWidget {
  final String username;
  final String imagePath;
  final bool isFull;
  final String email;
  final Function(int)? onPageChange;

  const UserOverview({
    super.key,
    required this.username,
    required this.imagePath,
    required this.isFull,
    required this.email,
    this.onPageChange,
  });

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
            child: Image(
              image: _getImageProvider(),
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
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const UserProfile()),
    );
  }

  handleBookmarks() {
    print('handle bookmarks');
  }

  ImageProvider<Object> _getImageProvider() {
    if (widget.imagePath.isEmpty) {
      return const AssetImage('assets/profile.png');
    } else {
      return NetworkImage(widget.imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark =
        Provider.of<ThemeProvider>(context).themeData == darkMode;

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
                  radius: 50,
                  backgroundImage: _getImageProvider(),
                ),
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
                  backgroundColor: theme.colorScheme.secondary,
                ),
                onPressed: () {
                  handleEditProfile();
                },
                child: Text(
                  'Edit Profile',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.onSecondary),
                ),
              ),
            ),
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
                onTap: () => widget.onPageChange!(4),
                child: Text.rich(
                  TextSpan(
                    text: 'Hi, ',
                    style: theme.textTheme.bodyLarge,
                    children: [
                      TextSpan(
                        text: widget.username,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                handleBookmarks();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Icon(
                  isDark ? Icons.bookmarks_outlined : Icons.bookmarks_rounded,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                handleShowPict();
              },
              child: CircleAvatar(
                backgroundImage: _getImageProvider(),
              ),
            ),
          ],
        ),
      );
    }
  }
}
