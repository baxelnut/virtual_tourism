import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/theme_provider.dart';

class GlobalValues {
  static const String placeholderPath =
      'https://hellenic.org/wp-content/plugins/elementor/assets/images/placeholder.png';

  static ThemeData theme(BuildContext context) => Theme.of(context);

  static Size screenSize(BuildContext context) => MediaQuery.of(context).size;

  static ThemeProvider themeProvider(BuildContext context) =>
      Provider.of<ThemeProvider>(context, listen: false);
}
