import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../../core/global_values.dart';
import '../../../core/nuke_refresh.dart';
import '../cards/fit_width_card.dart';

class FullViewList extends StatefulWidget {
  final String cardsTitle;
  final List<Map<String, dynamic>>? destinationData;

  const FullViewList({
    super.key,
    required this.cardsTitle,
    this.destinationData,
  });

  @override
  State<FullViewList> createState() => _FullViewListState();
}

class _FullViewListState extends State<FullViewList> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);
    final String bazelPath = GlobalValues.bazelPath;

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
              title: Text(widget.cardsTitle),
              floating: true,
              snap: true,
            ),
            widget.destinationData == null || widget.destinationData!.isEmpty
                ? SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        'No data yet',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return FitWidthCard(
                          userProfile: bazelPath,
                          destinationData: widget.destinationData![index],
                        );
                      },
                      childCount: widget.destinationData!.length,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
