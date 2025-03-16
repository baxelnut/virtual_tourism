// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UtilsService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user = FirebaseAuth.instance.currentUser;

  Future<Map<String, bool>> fetchPassport() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('medals').doc('passport').get();

      if (snapshot.exists && snapshot.data() != null) {
        return snapshot
            .data()!
            .map((key, value) => MapEntry(key, value as bool));
      } else {
        return {};
      }
    } catch (e) {
      print('Error fetching countries: $e');
      return {};
    }
  }

  Future<void> updatePassportStatus(String country, bool visited) async {
    try {
      await _firestore.collection('medals').doc('passport').update({
        country: visited,
      });
      notifyListeners();
    } catch (e) {
      print('Error updating country status: $e');
    }
  }

  Future<void> updateVisitedState(String countryName, bool visited) async {
    try {
      await _firestore
          .collection('medals')
          .doc('passport')
          .update({countryName: visited});
      notifyListeners();
    } catch (e) {
      print('Error updating visited state: $e');
      rethrow;
    }
  }
}
