import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../core/global_values.dart';
import '../../../core/nuke_refresh.dart';
import '../../../services/firebase/api/destinations_service.dart';
import '../../../services/firebase/api/users_service.dart';
import '../../widgets/cards/fit_width_card.dart';
import 'tour_collections.dart';

class TourPage extends StatefulWidget {
  const TourPage({super.key});

  @override
  State<TourPage> createState() => _TourPageState();
}

class _TourPageState extends State<TourPage> {
  final DestinationsService _destinationsService = DestinationsService();
  final UsersService _usersService = UsersService();
  List<Map<String, dynamic>> tours0 = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTours();
  }

  Future<void> loadTours() async {
    final tours = await _destinationsService.fetchDestinations(
        collection: "verified_user_uploads");

    setState(() {
      tours0 = tours;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);
    final Size screenSize = GlobalValues.screenSize(context);

    return Scaffold(
      body: LiquidPullToRefresh(
        onRefresh: () async {
          await NukeRefresh.forceRefresh(context, 1);
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
              title: const Text('Tour'),
              centerTitle: true,
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const TourCollections(),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 20),
                    child: Text(
                      'All Post by Users',
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                  Column(
                    children: tours0.map((destinationData) {
                      return FutureBuilder<Map<String, dynamic>?>(
                        future: _usersService
                            .getUserData(destinationData['userId'] ?? ''),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return FitWidthCard(
                              userProfile: '',
                              destinationData: destinationData,
                            );
                          }

                          final userData = snapshot.data;
                          final userProfile = userData?['imageUrl'] ?? '';

                          return FitWidthCard(
                            userProfile: userProfile,
                            destinationData: destinationData,
                          );
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: screenSize.width / 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
