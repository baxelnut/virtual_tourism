import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../core/global_values.dart';
import '../../../core/nuke_refresh.dart';
import '../../../services/gamification/gamification_service.dart';
import 'medals_section.dart';

class MedalsPage extends StatefulWidget {
  const MedalsPage({super.key});

  @override
  State<MedalsPage> createState() => _MedalsPageState();
}

class _MedalsPageState extends State<MedalsPage> {
  late Future<Map<String, bool>> countriesFuture;

  final GamificationService gamificationService = GamificationService();

  @override
  void initState() {
    super.initState();
    countriesFuture = fetchPassport();
  }

  Future<Map<String, bool>> fetchPassport() async {
    try {
      final data = await gamificationService.fetchPassport();
      return data;
    } catch (e) {
      print('Error fetching passport data: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = GlobalValues.screenSize(context);
    final ThemeData theme = GlobalValues.theme(context);

    return Scaffold(
      body: LiquidPullToRefresh(
        onRefresh: () async {
          await NukeRefresh.forceRefresh(context, 3);
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
              title: const Text('Medals'),
              centerTitle: true,
            ),
            SliverToBoxAdapter(
              child: FutureBuilder<Map<String, bool>>(
                future: countriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: screenSize.height - 120,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return SizedBox(
                      height: screenSize.height - 120,
                      child: Center(
                        child: Text('Error: ${snapshot.error}'),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return SizedBox(
                      height: screenSize.height - 120,
                      child: Center(
                        child: Text('No data available.'),
                      ),
                    );
                  } else {
                    final countries = snapshot.data!;

                    return Column(
                      children: [
                        MedalsSection(
                          title: "Passports",
                          medals: countries,
                        ),
                        SizedBox(height: screenSize.width / 4),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
