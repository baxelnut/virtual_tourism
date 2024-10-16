import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/auth.dart';
import '../../components/user_overview.dart';
import '../../services/theme/theme.dart';
import '../../services/theme/theme_provider.dart';
import 'settings_tiles.dart';
import 'user_profile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifAllowed = false;
  bool languageEN = true;

  final Auth _auth = Auth();
  final user = FirebaseAuth.instance.currentUser;

  void handleOnTap() {
    print('fuck');
  }

  handleEditProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => UserProfile()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Provider.of<ThemeProvider>(context).themeData == darkMode;

    final List<Map<String, dynamic>> listOfThangz = [
      {
        'heading': 'Preference',
        'leadingIcon': [
          isDark ? Icons.dark_mode : Icons.dark_mode_outlined,
          notifAllowed
              ? Icons.notifications_on
              : Icons.notifications_off_outlined,
          Icons.language_rounded,
          Icons.admin_panel_settings_rounded,
        ],
        'title': [
          'Dark mode',
          'Push notification',
          'Language',
          'Manage permission'
        ],
        'trailingWidget': [
          buildSwitch(
              context: context,
              value: isDark,
              onChanged: (value) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              }),
          buildSwitch(
              context: context,
              value: notifAllowed,
              onChanged: (value) {
                setState(() => notifAllowed = !notifAllowed);
              }),
          const Icon(Icons.g_translate_rounded),
          const Icon(Icons.chevron_right_rounded),
        ],
        'function': [
          () => handleOnTap(),
          () => handleOnTap(),
          () => handleOnTap(),
          () => handleOnTap(),
        ],
      },
      {
        'heading': 'Account',
        'leadingIcon': [
          Icons.info_outline_rounded,
          Icons.email_rounded,
          Icons.lock_outline_rounded
        ],
        'title': ['Privacy policy', 'Change email', 'Change password'],
        'trailingWidget': [
          const Icon(Icons.chevron_right_rounded),
          const Icon(Icons.chevron_right_rounded),
          const Icon(Icons.chevron_right_rounded),
        ],
        'function': [
          () => handleOnTap(),
          () => handleOnTap(),
          () => handleOnTap(),
        ],
      },
      {
        'heading': 'About',
        'leadingIcon': [
          Icons.help_rounded,
          Icons.star_rate_rounded,
          Icons.check_rounded,
        ],
        'title': ['Help & support', 'Rate app', 'Version'],
        'trailingWidget': [
          const Icon(Icons.chevron_right_rounded),
          const Icon(Icons.chevron_right_rounded),
          const Text('1.0.0'),
        ],
        'function': [
          () => handleOnTap(),
          () => handleOnTap(),
          () => handleOnTap(),
        ],
      },
      {
        'heading': '',
        'leadingIcon': [Icons.logout_rounded],
        'title': ['Logout'],
        'trailingWidget': [
          const SizedBox(),
        ],
        'function': [() => _auth.signOut()],
      },
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 50),
                UserOverview(
                  username: user?.displayName,
                  imagePath: 'assets/profile.png',
                  isFull: true,
                  email: user?.email,
                ),
                for (var thang in listOfThangz)
                  SettingsTiles(
                    heading: thang['heading'],
                    leadingIcon: List<IconData>.from(thang['leadingIcon']),
                    title: List<String>.from(thang['title']),
                    trailingWidget: List<Widget>.from(thang['trailingWidget']),
                    onTap: thang['function'],
                  ),
                const SizedBox(height: 125)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSwitch(
      {required BuildContext context,
      required bool value,
      required ValueChanged<bool> onChanged}) {
    final theme = Theme.of(context);
    return Switch(
      thumbColor: WidgetStatePropertyAll(
        value ? const Color(0xffEFFFFB) : theme.colorScheme.onSurface,
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
