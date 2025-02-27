import 'package:flutter/material.dart';
import '../../services/firebase/api/firebase_api.dart';

class ButtonWriteReview extends StatefulWidget {
  final dynamic destinationData;
  const ButtonWriteReview({
    super.key,
    this.destinationData,
  });

  @override
  State<ButtonWriteReview> createState() => _ButtonWriteReviewState();
}

class _ButtonWriteReviewState extends State<ButtonWriteReview> {
  final TextEditingController reviewController = TextEditingController();
  double ratingStars = 0.0;

  void showReviewModal(BuildContext context) {
    FirebaseApi firebaseApi = FirebaseApi();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
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
                      setState(() {
                        ratingStars = (index + 1).toDouble();
                      });
                    },
                    icon: Icon(
                      Icons.star,
                      color: index < ratingStars.toInt()
                          ? Colors.amber
                          : Colors.grey,
                    ),
                  );
                }),
              ),
              TextField(
                controller: reviewController,
                decoration: const InputDecoration(
                  hintText: 'Write your review here...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  firebaseApi.addReview(
                    collectionId: "verified_user_uploads",
                    destinationId: widget.destinationData['id'],
                    userId: widget.destinationData['userId'],
                    userName: widget.destinationData['userName'],
                    ratingStars: double.tryParse(ratingStars.toString()) ?? 0.0,
                    reviewComment: reviewController.text,
                  );

                  Navigator.pop(context);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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
