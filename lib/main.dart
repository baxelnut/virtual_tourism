import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/theme/theme_provider.dart';
import 'services/firebase/api/destinations_service.dart';
import 'services/firebase/api/reviews_service.dart';
import 'services/firebase/api/storage_service.dart';
import 'services/firebase/api/users_service.dart';
import 'services/firebase/api/utils_service.dart';
import 'services/firebase/firebase_options.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;

  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAppCheck.instance.activate();

  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  final destinationService = DestinationsService();
  final reviewService = ReviewsService();
  final storageService = StorageService();
  final usersService = UsersService();
  final utilsService = UtilsService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DestinationsService>.value(
            value: destinationService),
        ChangeNotifierProvider<ReviewsService>.value(value: reviewService),
        ChangeNotifierProvider<StorageService>.value(value: storageService),
        ChangeNotifierProvider<UsersService>.value(value: usersService),
        ChangeNotifierProvider<UtilsService>.value(value: utilsService),
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
      ],
      child: const MyApp(),
    ),
  );
}
