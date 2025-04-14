import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/global_values.dart';
import '../actions/button_donate.dart';
import '../actions/button_share.dart';
import '../actions/button_shop.dart';
import '../actions/button_write_review.dart';
import 'rating_average.dart';
import 'rating_indicator_bar.dart';
import 'rating_reviewer_qty.dart';
import 'rating_stars.dart';
import 'review_tiles.dart';

class ReviewSection extends StatefulWidget {
  final Map<String, dynamic> destinationData;
  final String theId;
  const ReviewSection({
    super.key,
    required this.destinationData,
    required this.theId,
  });

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  @override
  void initState() {
    super.initState();
    processRatings();
  }

  List<int> processRatings() {
    Map<String, dynamic> rawRatings = widget.destinationData['ratings'] ?? {};
    List<int> ratings = List.generate(5, (_) => 0);
    for (var ratingData in rawRatings.values) {
      if (ratingData is Map && ratingData.containsKey('ratingStars')) {
        int star = (ratingData['ratingStars'] as num).toInt();
        if (star >= 1 && star <= 5) {
          ratings[5 - star]++;
        }
      }
    }
    return ratings;
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp is! Timestamp) return '-';

    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return DateFormat('d MMMM yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);
    final Size screenSize = GlobalValues.screenSize(context);

    int totalRatings = widget.destinationData['totalRatings'] ?? 0;

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
          child: Text('Rating & Reviews', style: theme.textTheme.headlineSmall),
        ),
        _ratingStat(
          screenSize: screenSize,
          theme: theme,
          ratings: processRatings(),
          totalRatings: totalRatings,
        ),
        _actionButtons(theme: theme),
        _reviewWidget(
          ratings: widget.destinationData['ratings'],
          screenSize: screenSize,
          theme: theme,
        ),
      ],
    );
  }

  Widget _ratingStat({
    required Size screenSize,
    required ThemeData theme,
    required List<int> ratings,
    required int totalRatings,
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
              collectionId: 'verified_user_uploads',
              destinationId: widget.theId,
              destinationData: widget.destinationData,
            ),
            Row(
              children: [
                const RatingStars(),
                const SizedBox(width: 8),
                RatingIndicatorBar(
                  ratings: ratings,
                  totalRatings: totalRatings,
                )
              ],
            ),
            RatingReviewerQty(ratings: ratings),
          ],
        ),
      ),
    );
  }

  Widget _actionButtons({required ThemeData theme}) {
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
              theId: widget.theId,
            ),
            ButtonShare(destinationData: widget.destinationData),
            ButtonDonate(destinationData: widget.destinationData),
            ButtonShop(destinationData: widget.destinationData),
            const SizedBox(width: 30),
          ],
        ),
      ),
    );
  }

  Widget _reviewWidget({
    required Map<String, dynamic>? ratings,
    required Size screenSize,
    required ThemeData theme,
  }) {
    int numOfComments = ratings?.length ?? 0;
    String randomComment = 'No reviews yet.';

    if (numOfComments > 0) {
      final List<String> allComments = ratings!.values
          .map((review) => review['reviewComment']?.toString() ?? '')
          .where((comment) => comment.isNotEmpty)
          .toList();

      if (allComments.isNotEmpty) {
        // allComments.shuffle();
        randomComment = allComments.last;
      }
    }

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
                  numOfComments.toString(),
                  style: theme.textTheme.labelLarge,
                ),
              ],
            ),
            subtitle: Text(
              randomComment,
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
            minTileHeight: 80,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (BuildContext context) {
                  return SizedBox(
                    height: screenSize.height / 2,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            'Reviews',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 12),
                          Divider(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                          ),
                          _commentSection(theme),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _commentSection(ThemeData theme) {
    final dynamic rawReviews = widget.destinationData['ratings'];

    final List<Map<String, dynamic>> reviews = rawReviews is Map
        ? rawReviews.entries.map((e) {
            final reviewData = e.value as Map<String, dynamic>;
            reviewData['userUid'] = e.key;
            return reviewData;
          }).toList()
        : [];

    final String defaultProfile = GlobalValues.defaultProfile;

    if (reviews.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 120),
        child: const Text('No reviews yet. Be the first to leave a review!'),
      );
    }

    List<String> userUids = reviews
        .map((r) => r['userUid']?.toString())
        .where((uid) => uid != null && uid.isNotEmpty)
        .cast<String>()
        .toList();

    if (userUids.isEmpty) {
      return const Text('Failed to load user data.');
    }

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: userUids)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return SizedBox(
            width: 300,
            height: 300,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        Map<String, String> userImageMap = {
          for (var doc in snapshot.data!.docs)
            doc.id:
                ((doc.data() as Map<String, dynamic>?)?['imageUrl'] as String?)
                            ?.trim()
                            .isNotEmpty ==
                        true
                    ? (doc.data() as Map<String, dynamic>)['imageUrl']
                    : defaultProfile
        };

        return Column(
          children: reviews.map((review) {
            final userImageUrl =
                (userImageMap[review['userUid']]?.trim().isNotEmpty == true)
                    ? userImageMap[review['userUid']]
                    : defaultProfile;

            return ReviewTiles(
              userProfile: review['photoUrl'] ?? userImageUrl,
              userName: review['userName'] ?? 'Anonymous',
              userRating: (review['ratingStars'] ?? 5).toInt(),
              userComment: review['reviewComment'] ?? '',
              datePosted: _formatTimestamp(review['timestamp']),
            );
          }).toList(),
        );
      },
    );
  }
}
