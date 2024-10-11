import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/user_overview.dart';
import '../../data/theme/theme.dart';
import '../../data/theme/theme_provider.dart';
import 'settings_tiles.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifAllowed = false;
  bool languageEN = true;

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
        'title': ['Dark mode', 'Push notification', 'Language', 'Manage permission'],
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
        ]
      },
      {
        'heading': 'About',
        'leadingIcon': [
          Icons.help_rounded,
          Icons.star_rate_rounded,
          Icons.check_rounded,
        ],
        'title': ['Help', 'Rate app', 'Version'],
        'trailingWidget': [
          const Icon(Icons.chevron_right_rounded),
          const Icon(Icons.chevron_right_rounded),
          const Text('1.0.0'),
        ]
      },

      {
        'heading': '',
        'leadingIcon': [
          Icons.logout_rounded
        ],
        'title': ['Logout'],
        'trailingWidget': [
          const SizedBox(),
        ]
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
                  username: 'Basil',
                  imagePath: 'assets/profile.jpg',
                  isFull: true,
                  email: 'basiliustengang24@gmail.com',
                ),
                for (var thang in listOfThangz)
                  SettingsTiles(
                    heading: thang['heading'],
                    leadingIcon: List<IconData>.from(thang['leadingIcon']),
                    title: List<String>.from(thang['title']),
                    // subtitle: List<String>.from(thang['subtitle']),
                    trailingWidget: List<Widget>.from(thang['trailingWidget']),
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
