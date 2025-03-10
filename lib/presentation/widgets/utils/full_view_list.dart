import 'package:flutter/material.dart';
import '../../../core/global_values.dart';
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              widget.cardsTitle,
            ),
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
    );
  }
}
