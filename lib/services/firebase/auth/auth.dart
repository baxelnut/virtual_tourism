import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/global_values.dart';
import '../api/users_service.dart';

class Auth {
  final UsersService _usersService = UsersService();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Auth() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      GlobalValues.user = user;
    });
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    await Future.delayed(Duration(milliseconds: 300));
    GlobalValues.user = null;
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) {
        throw Exception('User not found after login.');
      }

      final userData = await _usersService.getUserData(user.uid);

      if (userData == null) {
        await _usersService.createUserData(
          userUid: user.uid,
          isVerified: user.emailVerified,
          email: user.email,
          password: password,
          phoneNumber: user.phoneNumber,
          username: user.displayName,
          imageUrl: user.photoURL,
          admin: false,
        );
      } else if (userData['admin'] == null) {
        await _usersService.updateUserAdminStatus(user.uid, false);
      }
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
    final bool admin = false,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.sendEmailVerification();

      final user = FirebaseAuth.instance.currentUser;
      _usersService.createUserData(
        userUid: user!.uid,
        isVerified: user.emailVerified,
        email: user.email,
        password: password,
        phoneNumber: user.phoneNumber,
        username: user.displayName,
        imageUrl: user.photoURL,
        admin: false,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in was canceled.');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user == null) {
        throw Exception('User not found after sign-in.');
      }

      final userData = await _usersService.getUserData(user.uid);

      if (userData == null) {
        await _usersService.createUserData(
          userUid: user.uid,
          isVerified: user.emailVerified,
          email: user.email,
          password: '',
          phoneNumber: user.phoneNumber,
          username: user.displayName,
          imageUrl: user.photoURL,
          admin: false,
        );
      } else if (userData['admin'] == null) {
        await _usersService.updateUserAdminStatus(user.uid, false);
      }

      await currentUser?.reload();
      return user;
    } catch (e) {
      throw Exception('Failed to sign in with Google: ${e.toString()}');
    }
  }
}
