import 'package:flutter/material.dart';

class CardsLinear extends StatefulWidget {
  final String flag;
  final String country;
  const CardsLinear({super.key, required this.country, required this.flag});

  @override
  State<CardsLinear> createState() => _CardsLinearState();
}

class _CardsLinearState extends State<CardsLinear> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Stack(
        children: [
          Container(
            width: screenSize.width / 3,
            height: screenSize.width / 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/nusa_penida.jpeg',
                fit: BoxFit.cover,
                width: screenSize.width / 3,
                height: screenSize.width / 2,
              ),
            ),
          ),
          Container(
            width: screenSize.width / 3,
            height: screenSize.width / 2,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.black,
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.0, 0.5],
                tileMode: TileMode.clamp,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Text(
              '${widget.flag}\n${widget.country}',
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.surface,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
