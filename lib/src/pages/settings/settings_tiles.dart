import 'package:flutter/material.dart';

class SettingsTiles extends StatelessWidget {
  final String heading;
  final List<IconData> leadingIcon;
  final List<String> title;
  // final List<String> subtitle;
  final List<Widget> trailingWidget;
  const SettingsTiles({
    super.key,
    required this.heading,
    required this.leadingIcon,
    required this.title,
    // required this.subtitle,
    required this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                side:
                    BorderSide(color: theme.colorScheme.onSurface, width: 0.15),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(i == 0 ? 25 : 0),
                  topRight: Radius.circular(i == 0 ? 25 : 0),
                  bottomLeft: Radius.circular(i == quantity - 1 ? 25 : 0),
                  bottomRight: Radius.circular(i == quantity - 1 ? 25 : 0),
                ),
              ),
              // dense: subtitle[i] != '',
              dense: false,
              onTap: () {
                print(title[i]);
              },
              leading: Icon(leadingIcon[i]),
              title: Text(
                title[i],
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              // subtitle: subtitle[i] != ''
              //     ? Text(
              //         subtitle[i],
              //         style: theme.textTheme.labelMedium,
              //       )
              //     : null,
              trailing: trailingWidget[i]),
      ],
    );
  }
}