import 'package:flutter/material.dart';

import '../../../core/global_values.dart';

class InputSection extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final Color decorationColor;
  final int maxLength;
  final int? maxLines;
  final bool isReadOnly;
  const InputSection({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.decorationColor,
    required this.maxLength,
    required this.maxLines,
    required this.isReadOnly,
  });

  @override
  State<InputSection> createState() => _InputSectionState();
}

class _InputSectionState extends State<InputSection> {
  bool obscurial = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: widget.decorationColor.withOpacity(0.5),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        leading: Icon(
          widget.icon,
          color: widget.decorationColor,
          size: 20,
        ),
        title: TextField(
          readOnly: widget.isReadOnly,
          controller: widget.controller,
          obscureText: widget.hintText.toLowerCase().contains('password')
              ? obscurial
              : false,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: widget.decorationColor,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: widget.decorationColor,
            ),
            counterText: "",
            counter: null,
          ),
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
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
              color: widget.decorationColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
