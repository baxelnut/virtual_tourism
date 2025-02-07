import 'package:flutter/material.dart';

class InputSection extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  const InputSection({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
  });

  @override
  State<InputSection> createState() => _InputSectionState();
}

class _InputSectionState extends State<InputSection> {
  bool obscurial = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: theme.colorScheme.tertiary.withOpacity(0.5),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        leading: Icon(
          widget.icon,
          color: theme.colorScheme.tertiary,
          size: 20,
        ),
        title: TextField(
          controller: widget.controller,
          obscureText: widget.hintText.toLowerCase().contains('password')
              ? obscurial
              : false,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.tertiary,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.tertiary,
            ),
          ),
        ),
        trailing: Visibility(
          visible: widget.hintText.toLowerCase().contains('password'),
          child: GestureDetector(
            onTap: () {
              setState(() {
                obscurial = !obscurial;
              });
            },
            child: Icon(
              obscurial
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              color: theme.colorScheme.tertiary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
