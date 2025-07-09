import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemeData {
  static ThemeData getThemeData(bool isDarkMode) => ThemeData(
    brightness: isDarkMode ? Brightness.dark : Brightness.light,
    textTheme: TextTheme(
      titleLarge: GoogleFonts.montserratAlternates().copyWith(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      titleMedium: GoogleFonts.montserratAlternates().copyWith(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      titleSmall: GoogleFonts.montserratAlternates().copyWith(
        fontSize: 18,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      primary: isDarkMode ? Colors.blueGrey : Colors.blue,
      secondary: isDarkMode ? Colors.teal : Colors.green,
      surface: isDarkMode ? Colors.grey[850]! : Colors.grey[200]!,
    ),
    cardColor:
        isDarkMode
            ? Colors.grey[800]
            : const Color.fromARGB(255, 241, 241, 241),
    buttonTheme: ButtonThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    ),
  );
}
