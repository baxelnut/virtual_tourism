import 'package:flutter/material.dart';

import '../auth.dart';

class AdditionalAction extends StatefulWidget {
  final List<bool> isSelected;
  final Function(int) switchSelected;
  const AdditionalAction({
    super.key,
    required this.isSelected,
    required this.switchSelected,
  });

  @override
  State<AdditionalAction> createState() => _AdditionalActionState();
}

class _AdditionalActionState extends State<AdditionalAction> {
  final Auth _auth = Auth();

  void showForgotPasswordDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Reset Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  "Enter your email to receive password reset instructions."),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                "Cancel",
                style: theme.textTheme.titleMedium,
              ),
            ),
            TextButton(
              onPressed: () async {
                String email = emailController.text.trim();

                Navigator.of(dialogContext).pop();

                if (email.isNotEmpty) {
                  try {
                    await _auth.resetPassword(email);
                    if (context.mounted) {
                      showAlertDialog(
                        context,
                        "Password reset email sent to $email",
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showAlertDialog(
                        context,
                        "Error: ${e.toString()}",
                      );
                    }
                  }
                } else {
                  if (context.mounted) {
                    showAlertDialog(
                      context,
                      "Please enter a valid email.",
                    );
                  }
                }
              },
              child: Text(
                "Send",
                style: theme.textTheme.titleMedium,
              ),
            ),
          ],
        );
      },
    );
  }

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
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              int index = widget.isSelected[0] ? 1 : 0;
              widget.switchSelected(index);
            },
            child: Text(
              widget.isSelected[0]
                  ? "Don't have an account?"
                  : "Already have an account?",
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.tertiary,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showForgotPasswordDialog(context);
            },
            child: Text(
              widget.isSelected[0] ? 'Forgot Password?' : '',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.tertiary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
