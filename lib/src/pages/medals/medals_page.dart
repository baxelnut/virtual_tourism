import 'package:flutter/material.dart';

class MedalsPage extends StatelessWidget {
  const MedalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme testing'),
        // backgroundColor: theme.colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: theme.colorScheme.primary,
              child: Center(
                  child: Text(
                'Primary (0xff1289B4)',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: theme.colorScheme.onPrimary),
              )),
            ),
            Container(
              height: 30,
              width: MediaQuery.of(context).size.width,
              color: theme.colorScheme.secondary,
              child: Center(
                  child: Text(
                'Secondary (0xffB43D12)',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: theme.colorScheme.onSecondary),
              )),
            ),
            Container(
              height: 30,
              width: MediaQuery.of(context).size.width,
              color: theme.colorScheme.onPrimary,
              child: Center(
                  child: Text(
                'On Primary (0xffEFFFFB)',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: theme.colorScheme.primary),
              )),
            ),
            Container(
              height: 30,
              width: MediaQuery.of(context).size.width,
              color: theme.colorScheme.onSecondary,
              child: Center(
                  child: Text(
                'On Secondary (0xffEFFFFB)',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: theme.colorScheme.secondary),
              )),
            ),
            Container(
              height: 30,
              width: MediaQuery.of(context).size.width,
              color: theme.colorScheme.surface,
              child: Center(
                  child: Text(
                'Surface (0xffEFFFFB)',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: theme.colorScheme.onSurface),
              )),
            ),
            Container(
              height: 30,
              width: MediaQuery.of(context).size.width,
              color: theme.colorScheme.onSurface,
              child: Center(
                  child: Text(
                'On Surface (0xff151515)',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: theme.colorScheme.surface),
              )),
            ),
            const Divider(),
            Text(
              'displayLarge',
              style: theme.textTheme.displayLarge,
            ),
            Text(
              'displayMedium',
              style: theme.textTheme.displayMedium,
            ),
            Text(
              'displaySmall',
              style: theme.textTheme.displaySmall,
            ),
            Text(
              'headlineLarge',
              style: theme.textTheme.headlineLarge,
            ),
            Text(
              'headlineMedium',
              style: theme.textTheme.headlineMedium,
            ),
            Text(
              'headlineSmall',
              style: theme.textTheme.headlineSmall,
            ),
            Text(
              'titleLarge',
              style: theme.textTheme.titleLarge,
            ),
            Text(
              'titleMedium',
              style: theme.textTheme.titleMedium,
            ),
            Text(
              'titleSmall',
              style: theme.textTheme.titleSmall,
            ),
            Text(
              'bodyLarge',
              style: theme.textTheme.bodyLarge,
            ),
            Text(
              'bodyMedium',
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              'bodySmall',
              style: theme.textTheme.bodySmall,
            ),
            Text(
              'labelLarge',
              style: theme.textTheme.labelLarge,
            ),
            Text(
              'labelMedium',
              style: theme.textTheme.labelMedium,
            ),
            Text(
              'labelSmall',
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}