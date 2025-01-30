import 'package:flutter/material.dart';
import 'package:virtual_tourism/src/components/load_image.dart';

import '../pages/home/news_detail.dart';

class NewsTiles extends StatelessWidget {
  final String imagePath;
  final String publisher;
  final String publisherPath;
  final String topic;
  final String headline;
  final String datePublished;
  final String newsContent;
  const NewsTiles({
    super.key,
    required this.imagePath,
    required this.publisher,
    required this.headline,
    required this.datePublished,
    required this.topic,
    required this.publisherPath,
    required this.newsContent,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
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
        child: SizedBox(
          height: 140,
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LoadImage(
                    imagePath: imagePath,
                    width: 120,
                    height: 120,
                  )),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      topic,
                      style: theme.textTheme.labelMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        headline,
                        style: theme.textTheme.headlineSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: NetworkImage(publisherPath),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "$publisher • $datePublished",
                            style: theme.textTheme.labelMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
