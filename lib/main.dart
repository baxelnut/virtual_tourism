import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/theme/theme_provider.dart';
import 'services/firebase/api/firebase_api.dart';
import 'services/firebase/firebase_options.dart';
import 'services/firebase/storage/storage_service.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;

  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAppCheck.instance.activate();

  final storageService = StorageService();
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  final firebaseApi = FirebaseApi();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<StorageService>.value(value: storageService),
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        Provider<FirebaseApi>.value(value: firebaseApi),
      ],
      child: const MyApp(),
    ),
  );
}
