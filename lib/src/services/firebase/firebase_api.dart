import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'storage/storage_service.dart';

class FirebaseApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storageService = StorageService();

  Future<void> createUserData({
    final String? userUid,
    final bool? isVerified,
    final String? email,
    final String? password,
    final String? phoneNumber,
    final String? username,
    final String? fullName,
    final String? gender,
    final String? birthday,
    final String? imageUrl,
  }) async {
    await _firestore.collection('users').doc(userUid).set({
      'userUid': userUid,
      'isVerified': isVerified,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber ?? '',
      'username': username ?? '',
      'fullName': fullName ?? '',
      'gender': gender ?? '',
      'birthday': birthday ?? '',
      'imageUrl': imageUrl ?? '',
      'created': DateTime.now(),
    });
  }

  Future<void> updateUserVerificationStatus({
    required String userUid,
    required bool isVerified,
  }) async {
    await _firestore
        .collection('users')
        .doc(userUid)
        .update({'isVerified': isVerified});
  }

  Future<String?> updateProfilePicture({
    required String userUid,
  }) async {
    try {
      String? updatedUrl =
          await _storageService.uploadProfilePicture(userUid: userUid);

      if (updatedUrl == null) {
        return null;
      }

      await _firestore
          .collection('users')
          .doc(userUid)
          .update({'imageUrl': updatedUrl});

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updatePhotoURL(updatedUrl);
        await user.reload();
      }

      return updatedUrl;
    } catch (e) {
      return null;
    }
  }
}
