import 'package:flutter/material.dart';

class CommCardsSmall extends StatelessWidget {
  final String title;
  final String imagePath;

  const CommCardsSmall({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: InkWell(
        onTap: () {
          print("$title: ouch");
        },
        child: Stack(
          children: [
            Container(
              width: screenSize.width / 3.5,
              height: screenSize.width / 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                  width: screenSize.width / 3.5,
                  height: screenSize.width / 3,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              width: screenSize.width / 3.5,
              height: screenSize.width / 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.secondary.withOpacity(0.69),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: const [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            SizedBox(
              width: screenSize.width / 3.5,
              height: screenSize.width / 3,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(2.0, 2.0),
                            blurRadius: 6,
                            color: theme.colorScheme.primary.withOpacity(0.8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                        child: Text(
                          title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.surface,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// class CommCardsSmall extends StatelessWidget {
//   const CommCardsSmall({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final ThemeData theme = Theme.of(context);
//     final Size screenSize = MediaQuery.of(context).size;

//     return Container(
//       width: screenSize.width / 3.5,
//       height: screenSize.width / 3,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(18),
//         image: const DecorationImage(
//           image: NetworkImage(
//             'https://d1ef7ke0x2i9g8.cloudfront.net/hong-kong/_large700/2143830/LC-Sign-Tony-interview-Big-Hitter-header.webp',
//           ),
//           fit: BoxFit.cover,
//         ),
       
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(width: 1),
//             Container(
//               decoration: BoxDecoration(
//                 color: theme.colorScheme.onSurface,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     offset: const Offset(2.0, 2.0),
//                     blurRadius: 4,
//                     color: theme.colorScheme.primary.withOpacity(0.69),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
//                 child: Text(
//                   'Tony',
//                   style: theme.textTheme.bodyMedium?.copyWith(
//                     color: theme.colorScheme.surface,
//                     fontWeight: FontWeight.w900,
//                   ),
//                   textAlign: TextAlign.center,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
