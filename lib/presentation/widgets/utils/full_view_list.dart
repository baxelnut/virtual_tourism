import 'package:flutter/material.dart';
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
    final ThemeData theme = Theme.of(context);
    final String photoUrlPlaceholder =
        'https://firebasestorage.googleapis.com/v0/b/virtual-tourism-7625f.appspot.com/o/users%2Fprofile%2FSEBcLELFH0NJpknkR1sygVD65rT2.jpg?alt=media&token=ecb1c829-52bb-4d3a-8675-b99c2c1f38f0';

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
                        userProfile: photoUrlPlaceholder,
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
