import 'package:flutter/material.dart';

class DinoTheme {
  DinoTheme._();

  static const Color backgroundColor = Color(0xFFF7F7F7);
  static const Color textColor = Color(0xFF535353);
  static const Color accentColor = Color(0xFF757575);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: textColor,
        secondary: accentColor,
        surface: backgroundColor,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: textColor),
      ),
    );
  }
}
