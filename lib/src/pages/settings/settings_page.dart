import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/util/user_overview.dart';
import '../../services/firebase/auth/auth.dart';
import '../../services/theme/theme.dart';
import '../../services/theme/theme_provider.dart';
import 'help_and_support.dart';
import 'privacy_and_policy.dart';
import 'settings_tiles.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifAllowed = false;

  final Auth _auth = Auth();
  final user = FirebaseAuth.instance.currentUser;

  void showAlertDialog(String title, String message) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "OK",
                style: theme.textTheme.titleMedium,
              ),
            ),
          ],
        );
      },
    );
  }

  void handleOnTap() {
    print('fuck');
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
          'Manage permission',
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
          () => showAlertDialog('Coming Soon :(',
              'This feature is still in development. We\'re working hard to bring it to you soon. Stay tuned!'),
          () => handleOnTap(),
        ],
      },
      {
        'heading': 'Account',
        'leadingIcon': [
          Icons.info_outline_rounded,
          Icons.email_rounded,
          Icons.lock_outline_rounded,
        ],
        'title': [
          'Privacy policy',
          'Change email',
          'Change password',
        ],
        'trailingWidget': [
          const Icon(Icons.chevron_right_rounded),
          const Icon(Icons.chevron_right_rounded),
          const Icon(Icons.chevron_right_rounded),
        ],
        'function': [
          () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PrivacyAndPolicy(),
                ),
              ),
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
        'title': [
          'Help & support',
          'Rate app',
          'Version',
        ],
        'trailingWidget': [
          const Icon(Icons.chevron_right_rounded),
          const Text(''),
          const Text('1.0.0'),
        ],
        'function': [
          () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HelpAndSupport(),
                ),
              ),
          () {},
          () {},
        ],
      },
      {
        'heading': '',
        'leadingIcon': [Icons.logout_rounded],
        'title': [
          'Logout',
        ],
        'trailingWidget': [
          const SizedBox(),
        ],
        'function': [() => _auth.logout()],
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
                const UserOverview(
                  isFull: true,
                ),
                for (var thang in listOfThangz)
                  SettingsTiles(
                    heading: thang['heading'],
                    leadingIcon: List<IconData>.from(thang['leadingIcon']),
                    title: List<String>.from(thang['title']),
                    trailingWidget: List<Widget>.from(thang['trailingWidget']),
                    onTap: thang['function'],
                  ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSwitch({
    required BuildContext context,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
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
