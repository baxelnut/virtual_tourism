import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

import '../../../core/global_values.dart';
import '../../../services/firebase/api/storage_service.dart';
import 'content_tiles.dart';
import 'create_content_page.dart';

class YourContentPage extends StatefulWidget {
  const YourContentPage({super.key});

  @override
  State<YourContentPage> createState() => _YourContentPageState();
}

class _YourContentPageState extends State<YourContentPage>
    with SingleTickerProviderStateMixin {
  final String placeholderPath = GlobalValues.placeholderPath;
  final User? user = GlobalValues.user;

  late Future<List<Map<String, dynamic>>> _fetchDestinationsFuture;
  late TabController _tabController;

  final String collection = 'verified_user_uploads';
  late String typeShi = 'Photographic';

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();

    _fetchDestinationsFuture = fetchDestinations();

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          typeShi = _tabController.index == 0 ? "Photographic" : "Tour";
          _fetchDestinationsFuture = fetchDestinations();
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchDestinations() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(collection)
          .where('userId', isEqualTo: user!.uid)
          .where('type', isEqualTo: typeShi)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<String> getThumbnailUrl({
    required String destinationId,
    required String typeShi,
    required String category,
    required String subcategory,
  }) async {
    final originalPath =
        '$collection/$typeShi/$category/$subcategory/$destinationId';
    final thumbnailPath =
        '$collection/$typeShi/$category/$subcategory/${destinationId}_thumbnail';
    try {
      return await FirebaseStorage.instance.ref(thumbnailPath).getDownloadURL();
    } catch (e) {
      try {
        return await FirebaseStorage.instance
            .ref(originalPath)
            .getDownloadURL();
      } catch (e) {
        return '';
      }
    }
  }

  void _searchData(String keyword) async {
    if (keyword.isEmpty) {
      setState(() {
        _isSearching = false;
        _fetchDestinationsFuture = fetchDestinations();
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    List<Map<String, dynamic>> results = [];
    String lowerKeyword = keyword.toLowerCase();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(collection)
          .where('userId', isEqualTo: user!.uid)
          .where('type', isEqualTo: typeShi)
          .get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;

        if (data.containsKey('destinationName') &&
            data['destinationName'] is String) {
          String destinationName = data['destinationName'].toLowerCase();
          if (destinationName.contains(lowerKeyword)) {
            results.add(data);
          }
        }
      }

      setState(() {
        _searchResults = List.from(results);
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);
    final Size screenSize = GlobalValues.screenSize(context);

    return Scaffold(
      body: LiquidPullToRefresh(
        onRefresh: () async {
          setState(() {
            _fetchDestinationsFuture = fetchDestinations();
          });
        },
        height: 120,
        color: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.surface,
        animSpeedFactor: 4,
        borderWidth: 3,
        showChildOpacityTransition: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              title: const Text('Your Content'),
              centerTitle: true,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Column(
                  children: [
                    searchBar(
                      theme: theme,
                      controller: _searchController,
                    ),
                    const SizedBox(height: 16),
                    TabBar(
                      controller: _tabController,
                      labelColor: theme.colorScheme.onSurface,
                      unselectedLabelColor:
                          theme.colorScheme.onSurface.withOpacity(0.5),
                      indicatorColor: theme.colorScheme.secondary,
                      dividerColor:
                          theme.colorScheme.onSurface.withOpacity(0.5),
                      dividerHeight: 0.75,
                      tabs: const [
                        Tab(text: "Photographic"),
                        Tab(text: "Tour"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _fetchDestinationsFuture,
                      builder: (context, snapshot) {
                        if (_isSearching) {
                          return SizedBox(
                            height: screenSize.height - 500,
                            child: const Center(child: Text("Searching...")),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: screenSize.height - 350,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          );
                        } else if (snapshot.hasError) {
                          return SizedBox(
                            height: screenSize.width,
                            child:
                                Center(child: Text('Error: ${snapshot.error}')),
                          );
                        }

                        final destinations = _searchController.text.isNotEmpty
                            ? _searchResults
                            : snapshot.data ?? [];

                        if (destinations.isEmpty) {
                          return SizedBox(
                            height: screenSize.width,
                            child: const Center(
                                child: Text('No destinations found.')),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: destinations.length,
                          itemBuilder: (context, index) {
                            final destination = destinations[index];
                            return FutureBuilder<String>(
                              future: getThumbnailUrl(
                                destinationId: destination['id'],
                                category: destination['category'],
                                subcategory: destination['subcategory'],
                                typeShi: typeShi,
                              ),
                              builder: (context, imageSnapshot) {
                                if (imageSnapshot.hasError) {
                                  return ListTile(
                                    leading: Text(destination['country']),
                                    title: Text(destination['destinationName']),
                                    trailing: const Icon(Icons.broken_image,
                                        size: 50),
                                  );
                                }
                                return ContentTiles(
                                    destinationData: destination);
                              },
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Consumer<StorageService>(
        builder: (context, storageService, child) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreateContentPage(user: user),
                ),
              );
            },
            child: Icon(
              Icons.add_rounded,
              size: 35,
              color: theme.colorScheme.onPrimary,
            ),
          );
        },
      ),
    );
  }

  Widget searchBar({required ThemeData theme, required controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurface),
        hintText: "Search...",
        hintStyle:
            TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)),
        filled: true,
        fillColor: theme.colorScheme.onSurface.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                onPressed: () {
                  controller.clear();
                  _searchData('');
                },
              )
            : null,
      ),
      onChanged: (value) {
        _searchData(value.trim());
      },
    );
  }
}
