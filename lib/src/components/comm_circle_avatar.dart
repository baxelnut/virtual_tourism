import 'package:flutter/material.dart';

class CommCircleAvatar extends StatelessWidget {
  final String url;
  const CommCircleAvatar({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(url),
      ),
    );
  }
}
