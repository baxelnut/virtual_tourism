import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(0xff1289B4),
    secondary: Color(0xffB43D12),
    onPrimary: Color(0xffEFFFFB),
    onSecondary: Color(0xffEFFFFB),
    surface: Color(0xffEFFFFB),
    onSurface: Color(0xff151515),
    // error: Color(0xffFF5539),
    // onError: Color(0xffEFFFFB),
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.outfit(
      textStyle: const TextStyle(fontWeight: FontWeight.normal),
    ),
    displayMedium: GoogleFonts.outfit(
      textStyle: const TextStyle(fontWeight: FontWeight.normal),
    ),
    displaySmall: GoogleFonts.outfit(
      textStyle: const TextStyle(fontWeight: FontWeight.normal),
    ),
    headlineLarge: GoogleFonts.outfit(
      textStyle: const TextStyle(fontWeight: FontWeight.normal),
    ),
    headlineMedium: GoogleFonts.outfit(
      textStyle: const TextStyle(fontWeight: FontWeight.normal),
    ),
    headlineSmall: GoogleFonts.outfit(
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
    titleLarge: GoogleFonts.italiana(
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
    titleMedium: GoogleFonts.italiana(
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
    titleSmall: GoogleFonts.italiana(
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
    bodyLarge: GoogleFonts.spaceGrotesk(
      textStyle: const TextStyle(fontWeight: FontWeight.normal),
    ),
    bodyMedium: GoogleFonts.spaceGrotesk(
      textStyle: const TextStyle(fontWeight: FontWeight.normal),
    ),
    bodySmall: GoogleFonts.spaceGrotesk(
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
    labelLarge: GoogleFonts.spaceGrotesk(
      textStyle: const TextStyle(fontWeight: FontWeight.normal),
    ),
    labelMedium: GoogleFonts.spaceGrotesk(
      textStyle: const TextStyle(fontWeight: FontWeight.normal),
    ),
    labelSmall: GoogleFonts.spaceGrotesk(
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  // dividerColor: Colors.transparent,
);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.light(
    primary: Color(0xff1289B4),
    secondary: Color(0xffB43D12),
    onPrimary: Color(0xffEFFFFB),
    onSecondary: Color(0xffEFFFFB),
    surface: Color(0xffEFFFFB),
    onSurface: Color(0xff151515),
    // error: Color(0xffF12200),
    // onError: Color(0xffEFFFFB),
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.outfit(
      textStyle: const TextStyle(fontWeight: FontWeight.normal),
    ),
    displayMedium: GoogleFonts.outfit(
      textStyle: const TextStyle(fontWeight: FontWeight.normal),
    ),
    displaySmall: GoogleFonts.outfit(
      textStyle: const TextStyle(fontWeight: FontWeight.normal),
    ),
    headlineLarge: GoogleFonts.outfit(
      textStyle: const TextStyle(fontWeight: FontWeight.normal),
    ),
    headlineMedium: GoogleFonts.outfit(
      textStyle: const TextStyle(fontWeight: FontWeight.normal),
    ),
    headlineSmall: GoogleFonts.outfit(
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
    titleLarge: GoogleFonts.italiana(
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
    titleMedium: GoogleFonts.italiana(
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
    titleSmall: GoogleFonts.italiana(
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
    bodyLarge: GoogleFonts.spaceGrotesk(
      textStyle: const TextStyle(fontWeight: FontWeight.normal),
    ),
    bodyMedium: GoogleFonts.spaceGrotesk(
      textStyle: const TextStyle(fontWeight: FontWeight.normal),
    ),
    bodySmall: GoogleFonts.spaceGrotesk(
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
    labelLarge: GoogleFonts.spaceGrotesk(
      textStyle: const TextStyle(fontWeight: FontWeight.normal),
    ),
    labelMedium: GoogleFonts.spaceGrotesk(
      textStyle: const TextStyle(fontWeight: FontWeight.normal),
    ),
    labelSmall: GoogleFonts.spaceGrotesk(
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  // dividerColor: Colors.transparent,
);
