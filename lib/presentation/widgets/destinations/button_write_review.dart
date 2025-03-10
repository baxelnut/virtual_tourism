import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/global_values.dart';
import '../../../services/firebase/api/firebase_api.dart';

class ButtonWriteReview extends StatefulWidget {
  final dynamic destinationData;
  final String theId;
  const ButtonWriteReview({
    super.key,
    this.destinationData,
    required this.theId,
  });

  @override
  State<ButtonWriteReview> createState() => _ButtonWriteReviewState();
}

class _ButtonWriteReviewState extends State<ButtonWriteReview> {
  final User? user = GlobalValues.user;
  final TextEditingController reviewController = TextEditingController();
  double ratingStars = 0.0;

  void showReviewModal(BuildContext context) {
    FirebaseApi firebaseApi = FirebaseApi();
    final ThemeData theme = GlobalValues.theme(context);
    final Size screenSize = GlobalValues.screenSize(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        double localRatingStars = 0.0;
        TextEditingController localReviewController =
            TextEditingController(text: reviewController.text);

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Write a Review',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(5, (int index) {
                      return IconButton(
                        onPressed: () {
                          setModalState(() {
                            localRatingStars = (index + 1).toDouble();
                          });
                        },
                        icon: Icon(
                          Icons.star,
                          color: index < localRatingStars.toInt()
                              ? Colors.amber
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                  TextField(
                    controller: localReviewController,
                    decoration: const InputDecoration(
                      hintText: 'Write your review here...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: screenSize.width,
                    child: ElevatedButton(
                      onPressed: () {
                        if (localRatingStars == 0.0) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Warning"),
                                content: const Text(
                                    "Please rate before submitting."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }

                        setState(() {
                          ratingStars = localRatingStars;
                          reviewController.text = localReviewController.text;
                        });

                        firebaseApi.addReview(
                          collectionId: "verified_user_uploads",
                          destinationId: widget.theId,
                          userId: user!.uid,
                          userName: user!.displayName!,
                          ratingStars: localRatingStars,
                          reviewComment: localReviewController.text,
                          photoUrl: user!.photoURL,
                        );

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 12),
                      ),
                      child: Text(
                        'Post',
                        style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);

    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 8, bottom: 12),
      child: ElevatedButton(
        onPressed: () {
          showReviewModal(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              Icons.rate_review_rounded,
              size: 20,
              color: theme.colorScheme.onPrimary,
            ),
            const SizedBox(width: 5),
            Text(
              'Review',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
