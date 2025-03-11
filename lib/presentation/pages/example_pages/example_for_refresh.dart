import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:virtual_tourism/core/global_values.dart';

class Example4Refresh extends StatelessWidget {
  const Example4Refresh({super.key});

  Future<void> _handleRefresh() async {
    return await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);

    return Scaffold(
      body: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        height: 120,
        color: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.surface,
        animSpeedFactor: 2,
        borderWidth: 3,
        showChildOpacityTransition: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 46),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 46),
                child: Container(
                  height: MediaQuery.of(context).size.width / 2,
                  color: Colors.amber,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 46),
                child: Container(
                  height: MediaQuery.of(context).size.width / 2,
                  color: Colors.amber,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 46),
                child: Container(
                  height: MediaQuery.of(context).size.width / 2,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
