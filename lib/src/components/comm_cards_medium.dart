import 'package:flutter/material.dart';

class CommCardsMedium extends StatelessWidget {
  const CommCardsMedium({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: SizedBox(
        width: screenSize.width / 1.5,
        height: screenSize.width / 3.5,
        child: ListTile(
          tileColor: Colors.amber,
          contentPadding: const EdgeInsets.all(4),
          leading: Container(
            width: 100,
            height: 100,
            color: Colors.blueAccent,
          ),
          title: Text(
            'LOREM IPSUM',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: const Color(0xffEFFFFB),
              shadows: [
                Shadow(
                  offset: const Offset(2.0, 2.0),
                  blurRadius: 5.0,
                  color: const Color(0xff151515).withOpacity(0.69),
                ),
              ],
            ),
            textAlign: TextAlign.start,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            'texttexetx',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xffEFFFFB),
              shadows: [
                Shadow(
                  offset: const Offset(2.0, 2.0),
                  blurRadius: 5.0,
                  color: const Color(0xff151515).withOpacity(0.69),
                ),
              ],
            ),
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
