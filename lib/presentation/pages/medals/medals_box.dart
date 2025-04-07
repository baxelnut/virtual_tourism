import 'package:flutter/material.dart';

import '../../../core/global_values.dart';
import '../../../services/gamification/gamification_service.dart';

class MedalsBox extends StatefulWidget {
  final String medalName;
  final bool isObtained;
  const MedalsBox({
    super.key,
    required this.medalName,
    required this.isObtained,
  });

  @override
  State<MedalsBox> createState() => _MedalsBoxState();
}

class _MedalsBoxState extends State<MedalsBox> {
  final GamificationService gamificationService = GamificationService();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);

    return Container(
      height: 110,
      width: 110,
      decoration: BoxDecoration(
        color: widget.isObtained
            ? theme.colorScheme.primary
            : theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          widget.medalName,
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
