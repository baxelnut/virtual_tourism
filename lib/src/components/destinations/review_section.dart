import 'package:flutter/material.dart';

import 'button_donate.dart';
import 'button_share.dart';
import 'button_shop.dart';
import 'button_write_review.dart';
import 'rating_average.dart';
import 'rating_indicator_bar.dart';
import 'rating_reviewer_qty.dart';
import 'rating_stars.dart';
import 'review_tiles.dart';

class ReviewSection extends StatefulWidget {
  final Map<String, dynamic> destinationData;
  const ReviewSection({
    super.key,
    required this.destinationData,
  });

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    final List<int> ratings = [89, 21, 13, 10, 5];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 20,
            top: 50,
            left: 20,
            right: 20,
          ),
          child: Text(
            'Rating & Reviews',
            style: theme.textTheme.headlineSmall,
          ),
        ),
        _ratingStat(
          screenSize: screenSize,
          theme: theme,
          ratings: ratings,
        ),
        _actionButtons(
          theme: theme,
        ),
        _reviewWidget(
          numOfComment: '208',
          screenSize: screenSize,
          theme: theme,
          context: context,
        ),
      ],
    );
  }

  Widget _ratingStat({
    required Size screenSize,
    required ThemeData theme,
    required List<int> ratings,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(
        width: screenSize.width,
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RatingAverage(
              ratings: ratings,
            ),
            Row(
              children: [
                const RatingStars(),
                const SizedBox(width: 8),
                RatingIndicatorBar(
                  ratings: ratings,
                ),
              ],
            ),
            RatingReviewerQty(
              ratings: ratings,
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButtons({
    required ThemeData theme,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5, top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 30),
            ButtonWriteReview(
              destinationData: widget.destinationData,
            ),
            ButtonShare(
              destinationData: widget.destinationData,
            ),
            ButtonDonate(
              destinationData: widget.destinationData,
            ),
            ButtonShop(
              destinationData: widget.destinationData,
            ),
            const SizedBox(width: 30),
          ],
        ),
      ),
    );
  }

  Widget _reviewWidget({
    required String numOfComment,
    required Size screenSize,
    required ThemeData theme,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Reviews',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(width: 10),
                Text(
                  numOfComment,
                  style: theme.textTheme.labelLarge,
                ),
              ],
            ),
            subtitle: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
              style: theme.textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(
              Icons.more_horiz,
              color: theme.colorScheme.onSurface,
              size: 22,
            ),
            tileColor: theme.colorScheme.onSurface.withOpacity(0.2),
            textColor: theme.colorScheme.onSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            minTileHeight: 100,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            'Reviews',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 12),
                          Divider(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          _commentSection(theme),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  });
            },
          ),
        ],
      ),
    );
  }

  Widget _commentSection(ThemeData theme) {
    return const Column(
      children: [
        ReviewTiles(
          userProfile:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSC_vMfeGWA4KtFPNYeTBc26CCwScfuU2Ouxw&s',
          userName: '50 Cent',
          userRating: 5,
          userComment:
              'Yo, this app is fire! 💯 Definitely puttin’ my homies on this one. No cap. ❤️',
          datePosted: '30 Jan 2025',
        ),
        ReviewTiles(
          userProfile:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Snoop_Dogg_2019_by_Glenn_Francis.jpg/330px-Snoop_Dogg_2019_by_Glenn_Francis.jpg',
          userName: 'Snoopy Doggy',
          userRating: 3,
          userComment:
              'Man, this app straight doo-doo. 😂 I’ma pass this to my ops, let them struggle while I stay chillin’. 🔫 (On baked AF tho… 🌿🔥)',
          datePosted: '30 Jan 2025',
        ),
        ReviewTiles(
          userProfile:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/Elon_Musk_Royal_Society_crop.jpg/330px-Elon_Musk_Royal_Society_crop.jpg',
          userName: 'Elon Musk',
          userRating: 5,
          userComment:
              'This app is quite literally revolutionary. Highly recommend for optimal efficiency. Also, Dogecoin integration when? 🚀🐶',
          datePosted: '30 Jan 2025',
        ),
        ReviewTiles(
          userProfile:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeGVUGslmHUWyeqopY1PThHAnuQ8XL0E2RYw&s',
          userName: 'Batman',
          userRating: 5,
          userComment:
              'This app… is what this city needs. But I must test it… in the shadows. 🦇',
          datePosted: '30 Jan 2025',
        ),
      ],
    );
  }
}
