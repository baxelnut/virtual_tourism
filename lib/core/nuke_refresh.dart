// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../app.dart';

// This is to force things. Not recommended.
class NukeRefresh {
  static User? user = FirebaseAuth.instance.currentUser;

  static Future<void> reloadUser() async {
    if (user != null) {
      await user!.reload();
      user = FirebaseAuth.instance.currentUser;
    }
  }

  static Future<void> forceRefresh(BuildContext context,
      [int? pageIndex]) async {
    try {
      await reloadUser();
      await FirebaseAuth.instance.currentUser?.reload();

      if (!context.mounted) return;

      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MyApp(
            pageIndex: pageIndex, // Optionally navigate to which index.
          ),
        ),
      );

      print("Page forcefully reloaded 🔄");
    } catch (error) {
      print("Error refreshing: $error 💀");
    }
  }
}
