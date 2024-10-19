import 'package:firebase_auth/firebase_auth.dart';

import '../api/firebase_api.dart';


class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseApi _firebaseApi = FirebaseApi();

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> register({
    required final String email,
    required String password,
    final bool isVerified = false,
    final String? phoneNumber,
    final String? username,
    final String? fullName,
    final String? gender,
    final String? birthday,
    final String? imageUrl,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.sendEmailVerification();

      final user = FirebaseAuth.instance.currentUser;
      _firebaseApi.createUserData(
        userUid: user!.uid,
        isVerified: user.emailVerified,
        email: user.email,
        password: password,
        phoneNumber: user.phoneNumber,
        username: user.displayName,
        imageUrl: user.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }
}
