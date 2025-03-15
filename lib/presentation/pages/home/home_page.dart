import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/global_values.dart';
import '../../../core/nuke_refresh.dart';
import '../../widgets/utils/chips_component.dart';
import '../../widgets/utils/user_overview.dart';
import 'community_content.dart';
import 'news_content.dart';
import 'places_content.dart';

class HomePage extends StatefulWidget {
  final Function(int) onPageChange;
  const HomePage({
    super.key,
    required this.onPageChange,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = GlobalValues.user;

  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _loadSelectedTab();
  }

  Future<void> _loadSelectedTab() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedTab = prefs.getInt('selectedTab') ?? 0;
    });
  }

  Future<void> _saveSelectedTab(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedTab', index);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);

    return Scaffold(
      body: LiquidPullToRefresh(
        onRefresh: () async {
          await NukeRefresh.forceRefresh(context);
        },
        height: 120,
        color: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.surface,
        animSpeedFactor: 4,
        borderWidth: 3,
        showChildOpacityTransition: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50, top: 35),
          child: ListView(
            children: [
              homeHeader(),
              _buildTabContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget homeHeader() {
    return Column(
      children: [
        const SizedBox(height: 10),
        UserOverview(
          isFull: false,
          onPageChange: widget.onPageChange,
        ),
        const SizedBox(height: 20),
        ChipsComponent(
          listOfThangz: const ['Places', 'Community', 'News'],
          selectedIndex: _selectedTab,
          onTabChange: (index) {
            setState(() {
              _selectedTab = index;
            });
            _saveSelectedTab(index);
          },
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 1:
        return const CommunityContent();
      case 2:
        return const NewsContent();
      default:
        return const PlacesContent();
    }
  }
}
