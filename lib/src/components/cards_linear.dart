import 'package:flutter/material.dart';

class CardsLinear extends StatefulWidget {
  const CardsLinear({super.key});

  @override
  State<CardsLinear> createState() => _CardsLinearState();
}

class _CardsLinearState extends State<CardsLinear> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/nusa_penida.jpeg',
              fit: BoxFit.cover,
              width: 100,
              height: 120,
            ),
          ),
        ),
        Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Text('Nusa Penidaaaaaaaa',
          overflow: TextOverflow.clip,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: theme.colorScheme.surface)),
        ),
      ],
    );
  }
}
