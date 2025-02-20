import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../admin/content_tiles.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  List<String> collections = [
    "verified_user_uploads",
    "medals",
    "destinations",
    "custom_destinations",
    "case_study_destinations",
    "example_destinations",
  ];

  @override
  void initState() {
    super.initState();
    _fetchCollections();
  }

  Future<void> _fetchCollections() async {
    try {
      DocumentSnapshot metadataDoc = await FirebaseFirestore.instance
          .collection('metadata')
          .doc('collections')
          .get();

      if (metadataDoc.exists) {
        List<dynamic> fetchedCollections = metadataDoc['collectionNames'];
        setState(() {
          collections = fetchedCollections
              .cast<String>()
              .where((c) => c != 'users')
              .toList();
        });
      }
    } catch (e) {
      showAlertDialog("Error fetching collections: $e");
    }
  }

  void _searchData(String keyword) async {
    if (keyword.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    List<Map<String, dynamic>> results = [];
    String lowerKeyword = keyword.toLowerCase();

    try {
      for (String collection in collections) {
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection(collection).get();

        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String destinationName =
              (data['destinationName'] ?? '').toLowerCase();

          if (destinationName.contains(lowerKeyword)) {
            results.add({
              'collection': collection,
              'id': doc.id,
              ...data,
            });
          }
        }
      }

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      showAlertDialog(e.toString());
      setState(() {
        _isSearching = false;
      });
    }
  }

  void showAlertDialog(String message) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: theme.colorScheme.surface,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Search...",
                  border: InputBorder.none,
                ),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                onChanged: (value) => _searchData(value.trim()),
              ),
            ),
            floating: true,
            snap: true,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                  icon: Icon(
                    _searchController.text.isEmpty ? Icons.search : Icons.close,
                    color: theme.colorScheme.onSurface,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _searchData('');
                  },
                ),
              ),
            ],
          ),
          _searchResults.isNotEmpty
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var data = _searchResults[index];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: ContentTiles(
                              destinationData: data,
                            ),
                          ),
                          if (index == _searchResults.length - 1)
                            const SizedBox(height: 120),
                        ],
                      );
                    },
                    childCount: _searchResults.length,
                  ),
                )
              : SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: screenSize.width / 3),
                      child: _isSearching
                          ? const CircularProgressIndicator()
                          : const Text('No results found'),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
