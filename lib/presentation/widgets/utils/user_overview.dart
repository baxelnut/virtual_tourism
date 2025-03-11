import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/global_values.dart';
import '../../../core/theme/theme.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../services/firebase/api/firebase_api.dart';
import '../../pages/admin/your_content_page.dart';
import '../../pages/bookmarks/bookmarks_page.dart';
import '../../pages/settings/user_profile.dart';

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
  bool isAdmin = false;
  final String defaultProfile = GlobalValues.defaultProfile;
  final user = GlobalValues.user;

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

  handleShowPict() {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: CircleAvatar(
            radius: 125,
            backgroundImage: NetworkImage(
              user?.photoURL ?? defaultProfile,
            ),
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BookmarksPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);
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
                  radius: 60,
                  backgroundImage: NetworkImage(
                    user?.photoURL ?? defaultProfile,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: GlobalValues.screenSize(context).width - 120,
                  child: Text(
                    user?.displayName ?? 'username',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
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
                // handleBookmarks();
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
                    backgroundImage: NetworkImage(
                      user?.photoURL ?? defaultProfile,
                    ),
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
