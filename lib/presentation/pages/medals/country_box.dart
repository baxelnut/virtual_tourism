import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/global_values.dart';
import '../../../services/firebase/api/utils_service.dart';

class CountryBox extends StatefulWidget {
  final String countryName;
  final bool initialVisited;
  final ValueChanged<bool> onVisitedChanged;
  const CountryBox({
    super.key,
    required this.countryName,
    required this.initialVisited,
    required this.onVisitedChanged,
  });

  @override
  CountryBoxState createState() => CountryBoxState();
}

class CountryBoxState extends State<CountryBox> {
  late bool visited;

  @override
  void initState() {
    super.initState();
    visited = widget.initialVisited;
  }

  void toggleVisited() async {
    setState(() {
      visited = !visited;
    });

    widget.onVisitedChanged(visited);

    final utilsService = Provider.of<UtilsService>(context, listen: false);
    try {
      await utilsService.updateVisitedState(widget.countryName, visited);
    } catch (e) {
      setState(() {
        visited = !visited;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating state: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);

    return GestureDetector(
      onTap: toggleVisited,
      child: Container(
        height: 110,
        width: 110,
        decoration: BoxDecoration(
          color:
              visited ? theme.colorScheme.primary : theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            widget.countryName,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
