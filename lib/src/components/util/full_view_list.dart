import 'package:flutter/material.dart';

import '../../pages/tour/tour_card.dart';

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
    final Size screenSize = MediaQuery.of(context).size;
    final String photoUrlPlaceholder =
        'https://firebasestorage.googleapis.com/v0/b/virtual-tourism-7625f.appspot.com/o/users%2Fprofile%2FSEBcLELFH0NJpknkR1sygVD65rT2.jpg?alt=media&token=ecb1c829-52bb-4d3a-8675-b99c2c1f38f0';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.cardsTitle,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.destinationData == null ||
                widget.destinationData!.isEmpty)
              SizedBox(
                height: screenSize.height - 100,
                child: Center(
                  child: Text(
                    'No data yet',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              )
            else
              ...widget.destinationData!.map(
                (data) => TourCard(
                  userProfile: photoUrlPlaceholder,
                  destinationData: data,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
