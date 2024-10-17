import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}
