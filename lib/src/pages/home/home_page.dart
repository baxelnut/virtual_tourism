import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/chips_component.dart';
import '../../components/user_overview.dart';
import 'community_content.dart';
import 'news_content.dart';
import 'places_content.dart';

class HomePage extends StatefulWidget {
  final Function(int) onPageChange;
  const HomePage({super.key, required this.onPageChange});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
