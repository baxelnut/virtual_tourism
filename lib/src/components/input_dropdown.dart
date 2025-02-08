import 'package:flutter/material.dart';

class InputDropdown extends StatefulWidget {
  final String title;
  final List<String> items;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const InputDropdown({
    super.key,
    required this.title,
    required this.items,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<InputDropdown> createState() => _InputDropdownState();
}

class _InputDropdownState extends State<InputDropdown> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant InputDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setState(() {
        _selectedValue = widget.initialValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ListTile(
        tileColor: theme.colorScheme.onSurface.withOpacity(0.1),
        minVerticalPadding: 10,
        dense: true,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          widget.title,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: DropdownButton<String>(
          value: _selectedValue,
          onChanged: (newValue) {
            setState(() {
              _selectedValue = newValue!;
            });
            widget.onChanged(newValue!);
          },
          items: widget.items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: SizedBox(
                width: 120,
                child: Text(
                  item,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
