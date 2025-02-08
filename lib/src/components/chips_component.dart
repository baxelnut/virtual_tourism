import 'package:flutter/material.dart';

class ChipsComponent extends StatefulWidget {
  final List<String> listOfThangz;
  final Function(int) onTabChange;
  final int selectedIndex;

  const ChipsComponent({
    super.key,
    required this.listOfThangz,
    required this.onTabChange,
    required this.selectedIndex,
  });

  @override
  State<ChipsComponent> createState() => _ChipsComponentState();
}

class _ChipsComponentState extends State<ChipsComponent> {
  int? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant ChipsComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      setState(() {
        _value = widget.selectedIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List<Widget>.generate(
          widget.listOfThangz.length,
          (int index) {
            final bool isSelected = _value == index;
            return ChoiceChip(
              padding: const EdgeInsets.symmetric(vertical: 0),
              selectedColor: theme.colorScheme.secondary,
              backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
              labelStyle: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: isSelected
                    ? theme.colorScheme.onSecondary
                    : theme.colorScheme.onSurface,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
              label: Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  widget.listOfThangz[index],
                ),
              ),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) {
                  setState(() {
                    _value = index;
                  });
                  widget.onTabChange(index);
                }
              },
            );
          },
        ).toList(),
      ),
    );
  }
}
