import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ButtonShare extends StatelessWidget {
  final Map<String, dynamic> destinationData;
  const ButtonShare({
    super.key,
    required this.destinationData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: () {
        final String destinationName =
            destinationData['destinationName'] ?? 'Unknown';
        final String shareText =
            '🚀 Explore "$destinationName" in VR! 🌍✨\nImmerse yourself in stunning eco-tours and discover nature like never before! 🌿🏕️\n🔗 Try it now!';
        Share.share(shareText);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            Icons.share_rounded,
            size: 20,
            color: theme.colorScheme.onPrimary,
          ),
          const SizedBox(width: 5),
          Text(
            'Share',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
