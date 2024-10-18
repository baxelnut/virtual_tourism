import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'services/firebase/auth/auth_page.dart';
import 'services/firebase/auth/verify_email_page.dart';
import 'services/theme/theme.dart';
import 'services/theme/theme_provider.dart';
import 'pages/explore/explore_page.dart';
import 'pages/home/home_page.dart';
import 'pages/medals/medals_page.dart';
import 'pages/settings/settings_page.dart';
import 'pages/tour/tour_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _loadSelectedButton();
  }

  Future<void> _loadSelectedButton() async {
    List<bool> isSelected = [true, false];

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSelected = [prefs.getBool('isDarkMode') ?? true, !isSelected[0]];
    });
  }

  int pageIndex = 0;

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDark =
        Provider.of<ThemeProvider>(context).themeData == darkMode;
    final theme = Theme.of(context);
    TextStyle customTextStyle = GoogleFonts.outfit(
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDark ? const Color(0xffCE4919) : const Color(0xffB43D12)),
    );

    return MaterialApp(
      theme: themeProvider.themeData,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null && !user.emailVerified) {
                return const VerifyEmailPage(); // Redirect to VerifyEmailPage if not verified
              } else {
                switch (pageIndex) {
                  case 0:
                    return HomePage(onPageChange: (index) {
                      setState(() {
                        pageIndex = index;
                      });
                    });
                  case 1:
                    return const TourPage();
                  case 2:
                    return const ExplorePage();
                  case 3:
                    return const MedalsPage();
                  case 4:
                    return const SettingsPage();
                  default:
                    return HomePage(onPageChange: (index) {
                      setState(() {
                        pageIndex = index;
                      });
                    });
                }
              }
            } else {
              return const AuthPage();
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xff1289B4)
                        : const Color(0xff1178A1),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                    child: GNav(
                      color: theme.colorScheme.onPrimary,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      selectedIndex: pageIndex,
                      onTabChange: (index) {
                        setState(() {
                          pageIndex = index;
                        });
                      },
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      gap: 10,
                      tabBackgroundColor: theme.colorScheme.onPrimary,
                      tabActiveBorder: const Border(
                        top: BorderSide(color: Color(0xffB43D12), width: 1.69),
                        bottom:
                            BorderSide(color: Color(0xffB43D12), width: 1.69),
                      ),
                      activeColor: const Color(0xffB43D12),
                      tabs: [
                        GButton(
                            icon: Icons.home_rounded,
                            iconSize: 30,
                            text: 'Home',
                            textStyle: customTextStyle),
                        GButton(
                            icon: Icons.tour_rounded,
                            iconSize: 30,
                            text: 'Tour',
                            textStyle: customTextStyle),
                        GButton(
                            icon: Icons.travel_explore_rounded,
                            iconSize: 30,
                            text: 'Explore',
                            textStyle: customTextStyle),
                        GButton(
                            icon: Icons.military_tech_rounded,
                            iconSize: 30,
                            text: 'Medals',
                            textStyle: customTextStyle),
                        GButton(
                            icon: Icons.person_2_rounded,
                            iconSize: 30,
                            text: 'User',
                            textStyle: customTextStyle),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
