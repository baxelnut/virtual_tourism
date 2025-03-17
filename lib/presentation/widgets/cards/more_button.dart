import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

import '../../../core/global_values.dart';
import '../../../services/firebase/api/destinations_service.dart';

class MoreButton extends StatefulWidget {
  final bool isAdmin;
  final Map<String, dynamic> destinationData;
  const MoreButton({
    super.key,
    required this.isAdmin,
    required this.destinationData,
  });

  @override
  State<MoreButton> createState() => _MoreButtonState();
}

class _MoreButtonState extends State<MoreButton> {
  Future<bool> _showDeleteConfirmation() async {
    if (!mounted) return false;

    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Delete Destination"),
            content:
                const Text("Are you sure you want to delete this destination?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child:
                    const Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);

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
          bodyBuilder: (popoverContext) => Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.isAdmin
                ? [
                    _buildOption(
                      label: 'Edit',
                      icon: Icons.edit_rounded,
                      onTap: () {
                        if (popoverContext.mounted) {
                          Navigator.pop(popoverContext);
                        }
                      },
                    ),
                    _buildOption(
                      label: 'Delete',
                      icon: Icons.delete_rounded,
                      color: theme.colorScheme.error,
                      textColor: theme.colorScheme.onError,
                      onTap: () async {
                        if (!popoverContext.mounted) return;
                        Navigator.pop(popoverContext);

                        bool confirmDelete = await _showDeleteConfirmation();
                        if (!confirmDelete || !context.mounted) return;

                        try {
                          await Provider.of<DestinationsService>(context,
                                  listen: false)
                              .deleteDestination(
                            collectionId: "verified_user_uploads",
                            destinationData: widget.destinationData,
                          );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      '✅ Destination deleted successfully!')),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('❌ Failed to delete destination!')),
                            );
                          }
                        }
                      },
                    ),
                  ]
                : [
                    _buildOption(
                      label: 'Add to bookmark',
                      icon: Icons.bookmark_add_outlined,
                      onTap: () {
                        if (popoverContext.mounted) {
                          Navigator.pop(popoverContext);
                        }
                      },
                    ),
                    _buildOption(
                      label: 'Share',
                      icon: Icons.share_outlined,
                      onTap: () {
                        if (popoverContext.mounted) {
                          Navigator.pop(popoverContext);
                        }
                      },
                    ),
                    _buildOption(
                      label: 'Report',
                      icon: Icons.report_problem_outlined,
                      onTap: () {
                        if (popoverContext.mounted) {
                          Navigator.pop(popoverContext);
                        }
                      },
                    ),
                  ],
          ),
        );
      },
    );
  }

  Widget _buildOption({
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
