import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final List<bool> isSelected;
  final List<String> selectionOps;
  final Function(BuildContext context) handleAuthentication;
  const AuthButton({
    super.key,
    required this.isSelected,
    required this.selectionOps,
    required this.handleAuthentication,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          fixedSize: Size(screenSize.width, 50),
          backgroundColor: theme.colorScheme.primary),
      onPressed: () => handleAuthentication(context),
      child: Text(
        isSelected[0] ? selectionOps[0] : selectionOps[1],
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
