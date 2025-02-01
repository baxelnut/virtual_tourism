import 'package:flutter/material.dart';

class ReviewSection extends StatelessWidget {
  const ReviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final List<int> ratings = [23, 5, 4, 2, 0];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Rating & Reviews',
                  style: theme.textTheme.headlineSmall,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                  ),
                  child: Icon(
                    Icons.comment,
                    size: 22,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          _buildRatingStat(
            screenSize,
            theme,
            ratings,
          ),
          _buildReviewWidget(
            screenSize,
            theme,
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewWidget(
    Size screenSize,
    ThemeData theme,
    BuildContext context,
  ) {
    return Column(
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(top: 50, bottom: 10),
        //   child: Text(
        //     'X reviews',
        //     style: theme.textTheme.titleMedium,
        //   ),
        // ),
        // const Divider(),
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
                '208',
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
                    child: SizedBox(
                      height: screenSize.height,
                      child: Column(
                        children: [
                          _commentSection(theme),
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
      ],
    );
  }

  Widget _buildRatingStat(
    Size screenSize,
    ThemeData theme,
    List<int> ratings,
  ) {
    return SizedBox(
      width: screenSize.width,
      height: 130,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildAverageScore(theme, ratings),
          Row(
            children: [
              _buildStarsOrder(),
              const SizedBox(width: 8),
              _buildIndicatorBar(theme: theme, ratings: ratings),
            ],
          ),
          _buildReviewerQty(theme, ratings),
        ],
      ),
    );
  }

  Widget _buildAverageScore(ThemeData theme, List<int> ratings) {
    final totalRatings = ratings.reduce((a, b) => a + b);
    final starMap = {0: 5, 1: 4, 2: 3, 3: 2, 4: 1};
    int weightedSum = 0;

    for (int i = 0; i < ratings.length; i++) {
      weightedSum += starMap[i]! * ratings[i];
    }

    final averageScore = totalRatings > 0 ? weightedSum / totalRatings : 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          averageScore.toStringAsFixed(1),
          style: theme.textTheme.displayMedium,
        ),
        Text(
          '$totalRatings ratings',
          style: theme.textTheme.labelMedium,
        ),
      ],
    );
  }

  Widget _buildStarsOrder() {
    return Column(
      children: List.generate(
        5,
        (index) {
          final starCount = 5 - index;
          return Row(
            children: [
              ...List.generate(index, (_) => const SizedBox(width: 22)),
              ...List.generate(
                starCount,
                (_) => const Icon(
                  Icons.star_rate,
                  size: 22,
                  color: Colors.amber,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildReviewerQty(ThemeData theme, List<int> ratings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(ratings.length, (index) {
        return Text(
          ratings[index] > 999 ? '999+' : ratings[index].toString(),
          style: theme.textTheme.titleMedium,
        );
      }),
    );
  }

  Widget _buildIndicatorBar({
    required ThemeData theme,
    required List<int> ratings,
  }) {
    final totalRatings = ratings.reduce((a, b) => a + b);
    final percentages = ratings
        .map((count) => totalRatings > 0 ? (count / totalRatings) * 100 : 0.0)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(5, (index) {
        final percentage = percentages[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(
            width: 100 * (percentage / 100),
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(60),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _commentSection(ThemeData theme) {
    return Column(
      children: [
        _buildComment(
          userProfile:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSC_vMfeGWA4KtFPNYeTBc26CCwScfuU2Ouxw&s',
          userName: '50 Cent',
          userRating: 5,
          userComment:
              'Yo, this app is fire! 💯 Definitely puttin’ my homies on this one. No cap. ❤️',
          datePosted: '30 Jan 2025',
          isLiked: true,
          theme: theme,
        ),
        _buildComment(
          userProfile:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Snoop_Dogg_2019_by_Glenn_Francis.jpg/330px-Snoop_Dogg_2019_by_Glenn_Francis.jpg',
          userName: 'Snoopy Doggy',
          userRating: 3,
          userComment:
              'Man, this app straight doo-doo. 😂 I’ma pass this to my ops, let them struggle while I stay chillin’. 🔫 (On baked AF tho… 🌿🔥)',
          datePosted: '30 Jan 2025',
          isLiked: false,
          theme: theme,
        ),
        _buildComment(
          userProfile:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/Elon_Musk_Royal_Society_crop.jpg/330px-Elon_Musk_Royal_Society_crop.jpg',
          userName: 'Elon Musk',
          userRating: 5,
          userComment:
              'This app is quite literally revolutionary. Highly recommend for optimal efficiency. Also, Dogecoin integration when? 🚀🐶',
          datePosted: '30 Jan 2025',
          isLiked: false,
          theme: theme,
        ),
        _buildComment(
          userProfile:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeGVUGslmHUWyeqopY1PThHAnuQ8XL0E2RYw&s',
          userName: 'Batman',
          userRating: 5,
          userComment:
              'This app… is what this city needs. But I must test it… in the shadows. 🦇',
          datePosted: '30 Jan 2025',
          isLiked: true,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildComment({
    required String userProfile,
    required String userName,
    required int userRating,
    required String userComment,
    required String datePosted,
    required bool isLiked,
    required ThemeData theme,
  }) {
    return Column(
      children: [
        ListTile(
          dense: true,
          leading: Icon(
            isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
            size: 12,
            color: isLiked ? Colors.red : theme.colorScheme.onSurface,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                userName,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.end,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: List.generate(
                  userRating,
                  (index) => const Icon(
                    Icons.star_rate,
                    size: 18,
                    color: Colors.amber,
                  ),
                ),
              )
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                userComment,
                style: theme.textTheme.labelMedium,
                textAlign: TextAlign.end,
              ),
              const SizedBox(height: 8),
              Text(
                datePosted,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
          trailing: CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(userProfile),
          ),
        ),
      ],
    );
  }
}
