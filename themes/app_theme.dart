import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Indian-inspired color palette
  static const Color primary = Color(0xFF00796B); // Teal green (close to Indian flag)
  static const Color accent = Color(0xFFFF9800); // Orange (from Indian flag)
  static const Color secondary = Color(0xFFF57C00); // Darker orange
  static const Color tertiary = Color(0xFF2196F3); // Blue (like the Ashoka Chakra)
  
  static const Color warmYellow = Color(0xFFFFC107);
  static const Color coolBlue = Color(0xFF0288D1);
  static const Color deepRed = Color(0xFFD32F2F);
  static const Color peacockBlue = Color(0xFF00ACC1);
  static const Color saffron = Color(0xFFFF6F00);
  static const Color indianPink = Color(0xFFE91E63);
  static const Color royalPurple = Color(0xFF673AB7);
  
  static const Color textLight = Color(0xFFF5F5F5);
  static const Color textDark = Color(0xFF212121);
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E1E1E);
  
  static const Color shadow = Color(0x40000000);
  
  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      onPrimary: textLight,
      onSecondary: textLight,
      onTertiary: textLight,
      background: backgroundLight,
      onBackground: textDark,
      surface: cardLight,
      onSurface: textDark,
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardTheme: CardTheme(
      color: cardLight,
      elevation: 4,
      shadowColor: shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      foregroundColor: textLight,
      elevation: 0,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: textLight,
        backgroundColor: primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    ),
    iconTheme: const IconThemeData(
      color: primary,
      size: 24,
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      onPrimary: textLight,
      onSecondary: textLight,
      onTertiary: textLight,
      background: backgroundDark,
      onBackground: textLight,
      surface: cardDark,
      onSurface: textLight,
    ),
    scaffoldBackgroundColor: backgroundDark,
    cardTheme: CardTheme(
      color: cardDark,
      elevation: 4,
      shadowColor: shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: cardDark,
      foregroundColor: textLight,
      elevation: 0,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: textLight,
        backgroundColor: primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    ),
    iconTheme: const IconThemeData(
      color: accent,
      size: 24,
    ),
  );
} 