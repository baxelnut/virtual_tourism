import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

class MoreButton extends StatelessWidget {
  final bool isAdmin;
  const MoreButton({
    super.key,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      icon: const Icon(Icons.more_vert_rounded),
      onPressed: () {
        showPopover(
          width: 225,
          context: context,
          backgroundColor: theme.colorScheme.surface,
          shadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 4,
              offset: const Offset(0, -4),
            ),
          ],
          bodyBuilder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: isAdmin
                ? [
                    _buildOption(
                      context,
                      label: 'Edit',
                      icon: Icons.edit_rounded,
                      onTap: () {
                        Navigator.pop(context);
                        // edit logic
                      },
                    ),
                    _buildOption(
                      context,
                      label: 'Delete',
                      icon: Icons.delete_rounded,
                      color: theme.colorScheme.error,
                      textColor: theme.colorScheme.onError,
                      onTap: () async {
                        Navigator.pop(context);
                        // delete logic
                      },
                    ),
                  ]
                : [
                    _buildOption(
                      context,
                      label: 'Add to bookmark',
                      icon: Icons.bookmark_add_outlined,
                      onTap: () async {
                        Navigator.pop(context);
                        // add to bookmark logic
                      },
                    ),
                    _buildOption(
                      context,
                      label: 'Share',
                      icon: Icons.share_outlined,
                      onTap: () async {
                        Navigator.pop(context);
                        // share logic
                      },
                    ),
                    _buildOption(
                      context,
                      label: 'Report',
                      icon: Icons.report_problem_outlined,
                      onTap: () async {
                        Navigator.pop(context);
                        // report logic
                      },
                    ),
                  ],
          ),
        );
      },
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
    Color? textColor,
  }) {
    final ThemeData theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      tileColor: color ?? theme.colorScheme.surface,
      onTap: onTap,
      title: Text(
        label,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: textColor ?? theme.colorScheme.onSurface,
        ),
      ),
      trailing: Icon(
        icon,
        color: textColor ?? theme.colorScheme.onSurface,
      ),
    );
  }
}
