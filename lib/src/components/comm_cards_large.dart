import 'package:flutter/material.dart';

class CommCardsLarge extends StatelessWidget {
  const CommCardsLarge({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width - 180,
      height: screenSize.width - 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        image: const DecorationImage(
          image: NetworkImage(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/View_of_Mount_Fuji_from_%C5%8Cwakudani_20211202.jpg/1200px-View_of_Mount_Fuji_from_%C5%8Cwakudani_20211202.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lorem Ipsum',
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
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
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
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
