import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/admin/your_content_page.dart';
import '../pages/settings/user_profile.dart';
import '../services/firebase/api/firebase_api.dart';
import '../services/theme/theme.dart';
import '../services/theme/theme_provider.dart';

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
  bool isAdmin = false;

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
      MaterialPageRoute(
        builder: (context) => UserProfile(
          isAdmin: isAdmin,
        ),
      ),
    );
  }

  handleBookmarks() {
    print('handle bookmarks');
  }

  _getImageProvider() {
    const invalidPhotoURLs = {
      'assets/profile.png',
      'not provided',
      'gs://virtual-tourism-7625f.appspot.com/users/.default/profile.png',
      'users/.default/profile.png',
    };

    if (user?.photoURL != null && !invalidPhotoURLs.contains(user?.photoURL)) {
      return NetworkImage(user!.photoURL!);
    } else {
      return const AssetImage('assets/profile.png');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAdminStatus();
  }

  Future<void> _loadAdminStatus() async {
    final prefs = await SharedPreferences.getInstance();

    bool cachedAdmin = prefs.getBool('admin_status') ?? false;
    setState(() {
      isAdmin = cachedAdmin;
    });

    final userData = await FirebaseApi().getUserData(user!.uid);
    bool adminFromFirestore = userData?['admin'] ?? false;

    if (adminFromFirestore != cachedAdmin) {
      setState(() {
        isAdmin = adminFromFirestore;
      });
      await prefs.setBool('admin_status', adminFromFirestore);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  user?.displayName ?? 'username',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Visibility(
                  visible: isAdmin,
                  child: const SizedBox(width: 8),
                ),
                Visibility(
                  visible: isAdmin,
                  child: const Icon(
                    Icons.verified_rounded,
                    size: 20,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            Text(
              user?.email ?? 'user@email.com',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                    ),
                    onPressed: () {
                      handleEditProfile();
                    },
                    child: Text(
                      'Edit profile',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(color: theme.colorScheme.onSecondary),
                    ),
                  ),
                  Visibility(
                    visible: isAdmin,
                    child: const SizedBox(
                      width: 12,
                    ),
                  ),
                  Visibility(
                    visible: isAdmin,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const YourContentPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Your content',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: theme.colorScheme.onPrimary),
                      ),
                    ),
                  ),
                ],
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: _getImageProvider(),
                  ),
                  if (isAdmin)
                    const Positioned(
                      bottom: 0,
                      right: 0,
                      child: Icon(
                        Icons.verified_rounded,
                        size: 16,
                        color: Colors.blue,
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      );
    }
  }
}
