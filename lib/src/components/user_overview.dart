import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme/theme.dart';
import '../services/theme/theme_provider.dart';
import '../pages/settings/user_profile.dart';

class UserOverview extends StatefulWidget {
  final bool isFull;
  final Function(int)? onPageChange;

  const UserOverview({
    super.key,
    required this.isFull,
    this.onPageChange,
  });

  @override
  State<UserOverview> createState() => _UserOverviewState();
}

class _UserOverviewState extends State<UserOverview> {
  final User? user = FirebaseAuth.instance.currentUser;

  handleShowPict() {
    final theme = Theme.of(context);
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
          content: Text(
            'This is your profile picture',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
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

  _getImageProvider() {
    if (user?.photoURL != null &&
        user?.photoURL != '' &&
        user?.photoURL != 'assets/profile.png' &&
        user?.photoURL != 'not provided' &&
        user?.photoURL !=
            'gs://virtual-tourism-7625f.appspot.com/users/.default/profile.png' &&
        user?.photoURL != 'users/.default/profile.png') {
      return NetworkImage(user!.photoURL!);
    } else {
      return const AssetImage('assets/profile.png');
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
              user?.displayName ?? 'username',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              user?.email ?? 'user@email.com',
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
                        text: user?.displayName ?? 'username',
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
