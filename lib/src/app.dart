import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

import 'data/theme/theme_provider.dart';
import 'pages/badges/badges_page.dart';
import 'pages/home/home_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int pageIndex = 0; // Index of the current page

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    TextStyle customTextStyle = GoogleFonts.outfit(
      textStyle: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xffB43D12)),
    );
    return MaterialApp(
      theme: themeProvider.themeData,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Builder(
          builder: (context) {
            switch (pageIndex) {
              case 0:
                return const HomePage();
              case 1:
                return const Placeholder();
              case 2:
                return const Placeholder();
              case 3:
                return const BadgesPage();
              case 4:
                return const Placeholder();
              default:
                return const HomePage();
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xff1289B4),
              borderRadius: BorderRadius.circular(28),
              // border: Border.all(color: Colors.black),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
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
                onTabChange: (index) {
                  setState(() {
                    pageIndex = index;
                  });
                },
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                gap: 10,
                tabBackgroundColor:
                    theme.colorScheme.onPrimary, // .withOpacity(0.5)
                tabActiveBorder: const Border(
                  top: BorderSide(color: Color(0xffB43D12), width: 1.69),
                  bottom: BorderSide(color: Color(0xffB43D12), width: 1.69),
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
                      icon: Icons.search_rounded,
                      iconSize: 30,
                      text: 'Search',
                      textStyle: customTextStyle),
                  GButton(
                      icon: Icons.badge_rounded,
                      iconSize: 30,
                      text: 'Badges',
                      textStyle: customTextStyle),
                  GButton(
                      icon: Icons.settings_rounded,
                      iconSize: 30,
                      text: 'Settings',
                      textStyle: customTextStyle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
