import 'package:flutter/material.dart';

import '../pages/home/news_detail.dart';

class NewsCardsLarge extends StatelessWidget {
  final String imagePath;
  final String publisher;
  final String publisherPath;
  final String headline;
  final String datePublished;
  final String newsContent;

  const NewsCardsLarge({
    super.key,
    required this.imagePath,
    required this.publisher,
    required this.headline,
    required this.datePublished,
    required this.publisherPath,
    required this.newsContent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(left: 6, top: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewsDetail(
                  imagePath: imagePath,
                  publisher: publisher,
                  headline: headline,
                  datePublished: datePublished,
                  publisherPath: publisherPath,
                  newsContent: newsContent,
                ),
              ),
            );
          },
          child: Container(
            width: screenSize.width - 100,
            height: screenSize.width / 2,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  imagePath,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  width: screenSize.width - 100,
                  height: screenSize.width / 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xff151515).withOpacity(0.9),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            publisher,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 6, right: 12),
                            child: Icon(
                              Icons.verified_rounded,
                              size: 16,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            datePublished,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          headline,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
