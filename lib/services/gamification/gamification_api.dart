// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class GamificationApi with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> announce({
    required final Map<String, dynamic> destinationData,
  }) async {
    try {
      // Initialize locale data for Indonesian
      await initializeDateFormatting('id_ID', null);

      final String userId = user?.uid ?? "Anonymous";
      final String username = user?.displayName ?? "username";
      final String userInfo = user?.toString() ?? "No data";
      final String artefactName =
          destinationData['artefact']?['name'] ?? "Virgin Oil (Extra)";
      final String destinationName =
          destinationData['destinationName'] ?? "destinationName";
      final String destinationId = destinationData['docId'] ?? 'NO ID?!';

      final String formattedDate =
          DateFormat('yyyyMMdd_HHmmss', 'id_ID').format(DateTime.now());

      await _firestore.collection("gamification").doc("user_news").set({
        "${formattedDate}_$userId": {
          "userId": userId,
          "username": username,
          "artefactName": artefactName,
          "destinationName": destinationName,
          "destinationId": destinationId,
          "announcement":
              '$username has obtained "$artefactName" at "$destinationName"',
          "destinationInfo": destinationData,
          "recorded": formattedDate,
          "userInfo": userInfo,
        },
      }, SetOptions(merge: true));

      print("Announcement updated at $formattedDate");
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> updateUserStats({
    required final Map<String, dynamic> destinationData,
  }) async {
    try {
      await initializeDateFormatting('id_ID', null);

      final String userId = user?.uid ?? "Anonymous";
      final String artefactName =
          destinationData['artefact']?['name'] ?? "Virgin Oil (Extra)";
      final String destinationName =
          destinationData['destinationName'] ?? "destinationName";
      final String destinationId = destinationData['docId'] ?? 'NO ID?!';

      final String formattedDate =
          DateFormat('yyyyMMdd_HHmmss', 'id_ID').format(DateTime.now());

      final String givenBy = destinationData['userName'] ?? "Dev";

      final info = {
        "artefactName": artefactName,
        "destinationId": destinationId,
        "destinationName": destinationName,
        "timeAcquired": formattedDate,
        "givenBy": givenBy,
      };

      await _firestore.collection("users").doc(userId).set({
        "artefactAcquired": {
          destinationId: info,
        },
      }, SetOptions(merge: true));

      print("User stats updated at $formattedDate");
    } catch (e) {
      print("Error: $e");
    }
  }
}
