import 'package:flutter/material.dart';

import '../../../core/global_values.dart';

class PrivacyAndPolicy extends StatelessWidget {
  const PrivacyAndPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);
    final Size screenSize = GlobalValues.screenSize(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Policy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your privacy is important to us. This policy explains how we collect, use, and protect your information.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 16),
              _buildSection(
                theme: theme,
                title: 'Information We Collect',
                content:
                    'We may collect information such as your name, email address, and device data to enhance your experience.',
              ),
              _buildSection(
                theme: theme,
                title: 'How We Use Your Information',
                content:
                    'We use collected data to improve app functionality, provide customer support, and enhance security.',
              ),
              _buildSection(
                theme: theme,
                title: 'Third-Party Services',
                content:
                    'We may use third-party services for analytics and advertising. These services have their own privacy policies.',
              ),
              _buildSection(
                theme: theme,
                title: 'Your Rights',
                content:
                    'You have the right to access, modify, or delete your personal data. Contact us for assistance.',
              ),
              _buildSection(
                theme: theme,
                title: 'Contact Us',
                content:
                    'If you have any questions about this policy, please contact us at support@virtualtourism.com.',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: SizedBox(
                  width: screenSize.width,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 12),
                    ),
                    child: Text(
                      'OK',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required ThemeData theme,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
