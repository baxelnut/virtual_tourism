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
  late Future<Map<String, List<Map<String, dynamic>>>> medalsFuture;

  final GamificationService _gamificationService = GamificationService();

  @override
  void initState() {
    super.initState();
    medalsFuture = _gamificationService.fetchAllMedals();
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
              child: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
                future: medalsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: screenSize.height - 120,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return SizedBox(
                      height: screenSize.height - 120,
                      child: Center(child: Text('Error: ${snapshot.error}')),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return SizedBox(
                      height: screenSize.height - 120,
                      child: const Center(child: Text('No data available.')),
                    );
                  } else {
                    final medalsData = snapshot.data!;

                    final passports = medalsData['passports'] ?? [];
                    final artefacts = medalsData['artefacts'] ?? [];
                    final trivia = medalsData['trivias'] ?? []; 

                    return Column(
                      children: [
                        MedalsSection(title: "Passports", medals: passports),
                        MedalsSection(title: "Artefacts", medals: artefacts),
                        MedalsSection(title: "Trivia", medals: trivia),
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
