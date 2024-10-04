import 'package:flutter/material.dart';

class CardsCurved extends StatefulWidget {
  final String destination;
  final String description;
  final String imagePath;
  const CardsCurved(
      {super.key,
      required this.destination,
      required this.description,
      required this.imagePath});

  @override
  State<CardsCurved> createState() => _CardsCurvedState();
}

class _CardsCurvedState extends State<CardsCurved> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Container(
        width: screenSize.width / 1.9,
        height: screenSize.height / 2.5,
        decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(360),
                topRight: Radius.circular(360),
                bottomLeft: Radius.circular(90),
                bottomRight: Radius.circular(90))),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: CircleAvatar(
                radius: screenSize.width / 4,
                backgroundImage: AssetImage(widget.imagePath),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Text(
                widget.destination,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: SizedBox(
                height: 50,
                child: Text(
                  widget.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
