// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReviewsService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user = FirebaseAuth.instance.currentUser;

  Future<double> getAverageRating({
    required String collectionId,
    required String destinationId,
  }) async {
    final doc = await FirebaseFirestore.instance
        .collection(collectionId)
        .doc(destinationId)
        .get();

    final Map<String, dynamic>? ratings = doc.data()?['rating'];

    if (ratings == null || ratings.isEmpty) return 0.0;

    final totalStars = ratings.values.fold<num>(0, (stars, review) {
      return stars + (review['ratingStars'] ?? 0);
    });

    return totalStars / ratings.length;
  }

  Future<void> addReview({
    required String collectionId,
    required String destinationId,
    required String userId,
    required String userName,
    required double ratingStars,
    String? reviewComment,
    String? photoUrl,
  }) async {
    final docRef = _firestore.collection(collectionId).doc(destinationId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      Map<String, dynamic> ratings = {};
      double newTotalStars = ratingStars;
      int newTotalRatings = 1;

      Map<String, dynamic> data = {};

      if (snapshot.exists) {
        data = snapshot.data() ?? {};
        ratings = Map<String, dynamic>.from(data['ratings'] ?? {});

        if (ratings.containsKey(userId)) {
          newTotalStars = (data['totalStars'] ?? 0) -
              (ratings[userId]['ratingStars'] as num) +
              ratingStars;
          newTotalRatings = (data['totalRatings'] ?? 0);
        } else {
          newTotalStars = (data['totalStars'] ?? 0) + ratingStars;
          newTotalRatings = (data['totalRatings'] ?? 0) + 1;
        }
      }

      int updatedTotalRatings = ratings.containsKey(userId)
          ? (data['totalRatings'] ?? 0)
          : newTotalRatings;

      double newAverageScore = double.parse(
          (newTotalStars / updatedTotalRatings).toStringAsFixed(1));

      final reviewData = {
        'userName': userName,
        'ratingStars': ratingStars,
        'reviewComment': reviewComment ?? '',
        'timestamp': FieldValue.serverTimestamp(),
        'photoUrl': photoUrl,
      };

      ratings[userId] = reviewData;
      transaction.set(
        docRef,
        {
          'ratings': ratings,
          'totalRatings': updatedTotalRatings,
          'totalStars': newTotalStars,
          'averageScore': newAverageScore,
        },
        SetOptions(merge: true),
      );
    });
  }

  Future<void> deleteReview({
    required String collectionId,
    required String destinationId,
    required String userId,
  }) async {
    final docRef = _firestore.collection(collectionId).doc(destinationId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) return;

      final data = snapshot.data()!;
      final currentTotal = (data['totalRatings'] ?? 0) as int;
      final currentAverage = (data['averageScore'] ?? 0.0) as double;

      if (currentTotal <= 1) {
        transaction.update(docRef, {
          'ratings.$userId': FieldValue.delete(),
          'totalRatings': 0,
          'averageScore': 0.0,
        });
        return;
      }

      final deletedRating =
          (data['ratings'][userId]['ratingStars'] ?? 0.0) as double;
      final newTotalRatings = currentTotal - 1;
      final newAverage =
          ((currentAverage * currentTotal) - deletedRating) / newTotalRatings;

      transaction.update(docRef, {
        'ratings.$userId': FieldValue.delete(),
        'totalRatings': newTotalRatings,
        'averageScore': newAverage,
      });
    });
  }

  Future<List<Map<String, dynamic>>> getReviews(String destinationId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('destinations')
          .doc(destinationId)
          .collection('reviews')
          .get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getDestinationReviews({
    required String collectionId,
    required String destinationId,
  }) async {
    try {
      QuerySnapshot reviewsSnapshot = await _firestore
          .collection(collectionId)
          .doc(destinationId)
          .collection('ratings')
          .get();

      return reviewsSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }

  Future<List<int>> fetchRatings(String destinationId) async {
    if (destinationId.isEmpty) {
      print("💀 ERROR: destinationId is empty!");
      return [];
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('verified_user_uploads')
        .doc(destinationId)
        .get();

    if (!snapshot.exists) {
      print("💀 No document found for destination: $destinationId");
      return [];
    }

    final data = snapshot.data();
    print("🔥 Fetched data: $data");

    if (data == null || !data.containsKey('ratings')) {
      print("💀 Ratings key missing.");
      return [];
    }

    final rawRatings = data['ratings'];

    List<int> ratings = [];
    if (rawRatings is Map) {
      ratings = rawRatings.values
          .map((review) => (review['ratingStars'] as num?)?.toInt() ?? 0)
          .toList();
    }

    print("✅ Processed ratings: $ratings");
    return ratings;
  }
}
