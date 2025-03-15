import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final List<bool> isSelected;
  final List<String> selectionOps;
  final Function(int) switchSelected;
  const HeaderSection({
    super.key,
    required this.isSelected,
    required this.selectionOps,
    required this.switchSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Container(
      color: theme.colorScheme.tertiary,
      width: screenSize.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
            child: Text(
              'Go ahead and set up your account',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Text(
              'Sign in-up to experience your epic odyssey!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: screenSize.width,
            height: 100,
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Center(
              child: _toggleButton(
                isSelected: isSelected,
                theme: theme,
                screenSize: screenSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton({
    required List<bool> isSelected,
    required ThemeData theme,
    required Size screenSize,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ToggleButtons(
        isSelected: isSelected,
        borderWidth: 0,
        borderColor: Colors.transparent,
        selectedBorderColor: Colors.transparent,
        disabledBorderColor: Colors.transparent,
        color: Colors.transparent,
        fillColor: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        onPressed: (int index) => switchSelected(index),
        children: [
          for (int i = 0; i < selectionOps.length; i++)
            Container(
              color: theme.colorScheme.tertiary.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  width: screenSize.width / 2.5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected[i]
                        ? theme.colorScheme.onPrimary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      selectionOps[i],
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.tertiary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
