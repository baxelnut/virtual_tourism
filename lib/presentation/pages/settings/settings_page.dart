import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:virtual_tourism/app.dart';

import '../../../core/global_values.dart';
import '../../../core/theme/theme.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../services/firebase/auth/auth.dart';
import '../../widgets/utils/user_overview.dart';
import 'help_and_support.dart';
import 'privacy_and_policy.dart';
import 'settings_tiles.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback? onRefresh;
  const SettingsPage({
    super.key,
    this.onRefresh,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Auth _auth = Auth();
  bool notifAllowed = false;
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> _handleRefresh() async {
    try {
      await GlobalValues.reloadUser();
      await FirebaseAuth.instance.currentUser?.reload();

      if (!mounted) return;

      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MyApp(pageIndex: 4),
        ),
      );
      // ignore: avoid_print
      print("Page fully reloaded 🔄");
    } catch (error) {
      // ignore: avoid_print
      print("Error refreshing: $error 💀");
    }
  }

  void showAlertDialog(String title, String message) {
    final ThemeData theme = GlobalValues.theme(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK", style: theme.textTheme.titleMedium),
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

    final ThemeData theme = GlobalValues.theme(context);

    return Scaffold(
      body: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        height: 120,
        color: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.surface,
        animSpeedFactor: 4,
        borderWidth: 3,
        showChildOpacityTransition: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Center(
            child: ListView(
              children: [
                const SizedBox(height: 50),
                StreamBuilder<User?>(
                  stream:
                      FirebaseAuth.instance.userChanges().asBroadcastStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Text('User not found 💀');
                    final user = snapshot.data!;
                    return UserOverview(
                      isFull: true,
                      key: ValueKey(user.uid),
                    );
                  },
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
    final ThemeData theme = GlobalValues.theme(context);
    return Switch(
      thumbColor: WidgetStatePropertyAll(
        value ? const Color(0xffEFFFFB) : theme.colorScheme.onSurface,
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
