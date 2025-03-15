import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app.dart';
import '../../../services/firebase/auth/auth.dart';

class AlternativeMethods extends StatefulWidget {
  final bool isLoading;
  final ValueChanged<bool> setLoading;

  const AlternativeMethods({
    super.key,
    required this.isLoading,
    required this.setLoading,
  });

  @override
  State<AlternativeMethods> createState() => _AlternativeMethodsState();
}

class _AlternativeMethodsState extends State<AlternativeMethods> {
  final Auth _auth = Auth();

  void showAlertDialog(BuildContext context, String message) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Notification"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "OK",
                style: theme.textTheme.titleMedium,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 1,
              width: screenSize.width / 5,
              color: theme.colorScheme.tertiary,
            ),
            Text(
              'OR',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.tertiary,
              ),
            ),
            Container(
              height: 1,
              width: screenSize.width / 5,
              color: theme.colorScheme.tertiary,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 20,
          runSpacing: 5,
          alignment: WrapAlignment.spaceEvenly,
          children: [
            _methodButton(
              methodName: 'Google',
              theme: theme,
            ),
            _methodButton(
              methodName: 'Facebook',
              theme: theme,
            ),
            _methodButton(
              methodName: 'Apple',
              theme: theme,
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _methodButton({
    required String methodName,
    required ThemeData theme,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.onPrimary,
        side: BorderSide(
          width: 1,
          color: theme.colorScheme.tertiary.withOpacity(0.5),
        ),
      ),
      onPressed: widget.isLoading
          ? null
          : () async {
              widget.setLoading(true);
              final BuildContext currentContext = context;

              switch (methodName) {
                case 'Google':
                  try {
                    User? user = await _auth.signInWithGoogle();
                    if (user != null && currentContext.mounted) {
                      showAlertDialog(
                        currentContext,
                        'Successfully signed in with Google',
                      );
                      Navigator.of(currentContext).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const MyApp(),
                        ),
                      );
                    }
                  } catch (e) {
                    if (currentContext.mounted) {
                      showAlertDialog(
                        currentContext,
                        'Google Sign-In failed: ${e.toString()}',
                      );
                    }
                  } finally {
                    if (mounted) {
                      widget.setLoading(false);
                    }
                  }
                  break;

                case 'Facebook':
                  if (currentContext.mounted) {
                    showAlertDialog(
                      currentContext,
                      'Facebook Sign-In is Coming Soon',
                    );
                  }
                  break;

                case 'Apple':
                  if (currentContext.mounted) {
                    showAlertDialog(
                      currentContext,
                      'Apple Sign-In is Coming Soon',
                    );
                  }
                  break;

                default:
                  if (currentContext.mounted) {
                    showAlertDialog(
                      currentContext,
                      'Unknown Sign-In method',
                    );
                  }
                  break;
              }
            },
      icon: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: SvgPicture.asset(
          'assets/icons/${methodName.toLowerCase()}.svg',
          width: 25,
          height: 25,
        ),
      ),
      label: Text(
        methodName,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.tertiary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
