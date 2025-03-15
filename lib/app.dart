import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

import 'core/global_values.dart';
import 'core/theme/theme.dart';
import 'core/theme/theme_provider.dart';
import 'presentation/pages/auth/auth_page.dart';
import 'presentation/pages/auth/verify_email_page.dart';
import 'presentation/pages/explore/explore_page.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/medals/medals_page.dart';
import 'presentation/pages/settings/settings_page.dart';
import 'presentation/pages/tour/tour_page.dart';

class MyApp extends StatefulWidget {
  final int? pageIndex;
  const MyApp({
    super.key,
    this.pageIndex,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late int pageIndex;

  @override
  void initState() {
    super.initState();
    pageIndex = widget.pageIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = GlobalValues.themeProvider(context);
    final ThemeData theme = themeProvider.themeData;
    final bool isDark =
        Provider.of<ThemeProvider>(context).themeData == darkMode;

    final List<Widget> pages = [
      HomePage(onPageChange: _changePage),
      const TourPage(),
      const ExplorePage(),
      const MedalsPage(),
      const SettingsPage(),
    ];

    final customTextStyle = GoogleFonts.outfit(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: isDark ? const Color(0xffCE4919) : const Color(0xffB43D12),
    );

    return MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          final User? user = snapshot.data;
          final bool isLoggedIn = user != null;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {});
          });

          return Scaffold(
            body: isLoggedIn
                ? (!user.emailVerified
                    ? const VerifyEmailPage()
                    : pages[pageIndex])
                : const AuthPage(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: isLoggedIn
                ? _buildNavBar(theme, isDark, customTextStyle)
                : null,
          );
        },
      ),
    );
  }

  Widget _buildNavBar(ThemeData theme, bool isDark, TextStyle customTextStyle) {
    final Color navBarColor =
        isDark ? const Color(0xff1289B4) : const Color(0xff1178A1);
    final Color borderColor = const Color(0xffB43D12);
    final Color shadowColor = Colors.black.withOpacity(0.6);

    final List<Map<String, dynamic>> navItems = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.tour_rounded, 'label': 'Tour'},
      {'icon': Icons.travel_explore_rounded, 'label': 'Explore'},
      {'icon': Icons.military_tech_rounded, 'label': 'Medals'},
      {'icon': Icons.person_2_rounded, 'label': 'User'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: navBarColor,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              spreadRadius: 3.5,
              blurRadius: 6.9,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: GNav(
            color: theme.colorScheme.onPrimary,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            selectedIndex: pageIndex,
            onTabChange: _changePage,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            gap: 10,
            tabBackgroundColor: theme.colorScheme.onPrimary,
            tabActiveBorder: Border(
              top: BorderSide(color: borderColor, width: 1.69),
              bottom: BorderSide(color: borderColor, width: 1.69),
            ),
            activeColor: borderColor,
            tabs: navItems
                .map((item) =>
                    _navButton(item['icon'], item['label'], customTextStyle))
                .toList(),
          ),
        ),
      ),
    );
  }

  GButton _navButton(IconData icon, String text, TextStyle textStyle) {
    return GButton(
      icon: icon,
      iconSize: 30,
      text: text,
      textStyle: textStyle,
    );
  }

  void _changePage(int index) {
    setState(() {
      pageIndex = index;
    });
  }
}
