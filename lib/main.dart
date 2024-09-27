import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'src/data/firebase/firebase_options.dart';
import 'src/data/theme/theme_provider.dart';
import 'src/app.dart';

void main() async {
  await dotenv.load(fileName: ".env");
//   try {
//   await dotenv.load(fileName: ".env");
// } catch (e) {
//   print('Error loading .env file: $e');
// }

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}
