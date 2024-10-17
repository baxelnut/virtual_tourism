import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../app.dart';
import '../firebase_api.dart';
import 'auth.dart';
import 'auth_page.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final Auth _auth = Auth();
  final FirebaseApi _firebaseApi = FirebaseApi();
  bool isEmailVerified = false;
  Timer? timer;
  bool canResend = false;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
        await checkEmailVerification();
      });
    }
  }

  Future<void> sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      setState(() => canResend = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResend = true);
    }
  }

  Future<void> checkEmailVerification() async {
    await FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      setState(() {
        isEmailVerified = true;
      });

      timer?.cancel();
      navigateToMyApp();
    }
  }

  void navigateToMyApp() {
    final user = FirebaseAuth.instance.currentUser;
    _firebaseApi.updateUserVerificationStatus(
        userUid: user!.uid, isVerified: user.emailVerified);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MyApp()),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isEmailVerified
                    ? 'Your email has been verified. Redirecting...'
                    : 'A verification email has been sent. Please kindly check your email!',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (!isEmailVerified)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: theme.colorScheme.primary,
                  ),
                  icon: Icon(Icons.email_rounded,
                      color: theme.colorScheme.onPrimary),
                  label: Text(
                    'Resend Email',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  onPressed: canResend ? sendVerificationEmail : () {},
                ),
              if (!isEmailVerified)
                TextButton(
                  child: Text(
                    'Cancel',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  onPressed: () {
                    _auth.logout();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const AuthPage()),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
