import 'package:flutter/material.dart';

class ChipsComponent extends StatefulWidget {
  final List<String> listOfThangz;
  const ChipsComponent({super.key, required this.listOfThangz});

  @override
  State<ChipsComponent> createState() => _ChipsComponentState();
}

class _ChipsComponentState extends State<ChipsComponent> {
  int? _value = 0;

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
              labelStyle: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
              label: Text(widget.listOfThangz[index]),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  _value = selected ? index : null;
                });
              },
            );
          },
        ).toList(),
      ),
    );
  }
}
