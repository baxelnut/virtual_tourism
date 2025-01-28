import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.favorite_outline_rounded,
              size: 30,
            ),
          ),
          const SizedBox(width: 30),
        ],
      ),
    );
  }
}