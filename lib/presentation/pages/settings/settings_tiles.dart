import 'package:flutter/material.dart';

import '../../../core/global_values.dart';

class SettingsTiles extends StatelessWidget {
  final String heading;
  final List<IconData> leadingIcon;
  final List<String> title;
  final List<Widget> trailingWidget;
  final List<VoidCallback> onTap;

  const SettingsTiles({
    super.key,
    required this.heading,
    required this.leadingIcon,
    required this.title,
    required this.trailingWidget,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);
    int quantity = title.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18, bottom: 12, top: 12),
          child: Text(heading, style: theme.textTheme.bodyMedium),
        ),
        for (var i = 0; i < quantity; i++)
          ListTile(
            tileColor: theme.colorScheme.onSurface.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: theme.colorScheme.onSurface,
                width: 0.15,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(i == 0 ? 25 : 0),
                topRight: Radius.circular(i == 0 ? 25 : 0),
                bottomLeft: Radius.circular(i == quantity - 1 ? 25 : 0),
                bottomRight: Radius.circular(i == quantity - 1 ? 25 : 0),
              ),
            ),
            dense: false,
            onTap: onTap[i],
            leading: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  leadingIcon[i],
                  size: 25,
                  color: title[i] == 'Logout' ? theme.colorScheme.error : null,
                ),
              ),
            ),
            title: Text(
              title[i],
              style: theme.textTheme.bodyLarge?.copyWith(
                color: title[i] == 'Logout' ? theme.colorScheme.error : null,
              ),
            ),
            trailing: trailingWidget[i],
          ),
      ],
    );
  }
}
