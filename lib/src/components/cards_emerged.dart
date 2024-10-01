import 'package:flutter/material.dart';

class CardsEmerged extends StatefulWidget {
  const CardsEmerged({super.key});

  @override
  State<CardsEmerged> createState() => _CardsEmergedState();
}

class _CardsEmergedState extends State<CardsEmerged> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.red,
    );
  }
}