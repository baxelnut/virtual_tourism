import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/theme_provider.dart';

class GlobalValues {
  static const String defaultProfile =
      'https://firebasestorage.googleapis.com/v0/b/virtual-tourism-7625f.appspot.com/o/users%2F.default%2Fprofile.png?alt=media&token=3471ca29-03b2-4bd7-a3fe-20dcc1810559';

  // temp
  static const String bazelPath =
      'https://firebasestorage.googleapis.com/v0/b/virtual-tourism-7625f.appspot.com/o/users%2F.default%2Fprofile3.jpg?alt=media&token=3d6e8de5-5d16-440d-ae5f-fc7013be3ebb';

  static const String placeholderPath =
      'https://hellenic.org/wp-content/plugins/elementor/assets/images/placeholder.png';

  static ThemeData theme(BuildContext context) => Theme.of(context);

  static Size screenSize(BuildContext context) => MediaQuery.of(context).size;

  static ThemeProvider themeProvider(BuildContext context) =>
      Provider.of<ThemeProvider>(context, listen: false);

  static User? user = FirebaseAuth.instance.currentUser;
}
