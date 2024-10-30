import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'src/app.dart';
import 'src/services/firebase/api/firebase_api.dart';
import 'src/services/firebase/firebase_options.dart';
import 'src/services/firebase/storage/storage_service.dart';
import 'src/services/theme/theme_provider.dart';

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
