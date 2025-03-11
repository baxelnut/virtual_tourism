import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

import 'core/global_values.dart';
import 'core/theme/theme.dart';
import 'core/theme/theme_provider.dart';
import 'presentation/pages/explore/explore_page.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/medals/medals_page.dart';
import 'presentation/pages/settings/settings_page.dart';
import 'presentation/pages/tour/tour_page.dart';
import 'services/firebase/auth/auth_page.dart';
import 'services/firebase/auth/verify_email_page.dart';

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
    final User? user = _auth.currentUser;

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
      home: Scaffold(
        body: StreamBuilder<User?>(
          stream: _auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return user != null && !user.emailVerified
                  ? const VerifyEmailPage()
                  : pages[pageIndex];
            }
            return const AuthPage();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: user != null
            ? _buildNavBar(
                theme,
                isDark,
                customTextStyle,
              )
            : null,
      ),
    );
  }

  Widget _buildNavBar(
    ThemeData theme,
    bool isDark,
    TextStyle customTextStyle,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff1289B4) : const Color(0xff1178A1),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff151515).withOpacity(0.6),
              spreadRadius: 3.5,
              blurRadius: 6.9,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          child: GNav(
            color: theme.colorScheme.onPrimary,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            selectedIndex: pageIndex,
            onTabChange: _changePage,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            gap: 10,
            tabBackgroundColor: theme.colorScheme.onPrimary,
            tabActiveBorder: const Border(
              top: BorderSide(
                color: Color(0xffB43D12),
                width: 1.69,
              ),
              bottom: BorderSide(
                color: Color(0xffB43D12),
                width: 1.69,
              ),
            ),
            activeColor: const Color(0xffB43D12),
            tabs: [
              _navButton(
                Icons.home_rounded,
                'Home',
                customTextStyle,
              ),
              _navButton(
                Icons.tour_rounded,
                'Tour',
                customTextStyle,
              ),
              _navButton(
                Icons.travel_explore_rounded,
                'Explore',
                customTextStyle,
              ),
              _navButton(
                Icons.military_tech_rounded,
                'Medals',
                customTextStyle,
              ),
              _navButton(
                Icons.person_2_rounded,
                'User',
                customTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  GButton _navButton(
    IconData icon,
    String text,
    TextStyle textStyle,
  ) {
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
