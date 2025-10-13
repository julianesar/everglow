import 'package:flutter/material.dart';

/// App theme configuration with "Quantum Glow" visual identity.
///
/// Provides a dark-themed design with:
/// - Charcoal Soul background (#111111)
/// - Liquid Gold primary color (#FFD700)
/// - Bio-Electric Cyan accent (#00FFFF)
/// - Satoshi font for headlines
/// - Lora font for body text
/// - Alabaster text color (#EAEAEA)
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Color palette
  static const Color _charcoalSoul = Color(0xFF111111);
  static const Color _liquidGold = Color(0xFFFFD700);
  static const Color _bioElectricCyan = Color(0xFF00FFFF);
  static const Color _alabaster = Color(0xFFEAEAEA);

  /// Returns the light theme configuration.
  ///
  /// Note: Despite the name "lightTheme", this implements a dark theme
  /// based on the "Quantum Glow" visual identity specification.
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Background colors
      scaffoldBackgroundColor: _charcoalSoul,

      // Primary color
      primaryColor: _liquidGold,

      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: _liquidGold,
        secondary: _bioElectricCyan,
        surface: _charcoalSoul,
        onPrimary: _charcoalSoul,
        onSecondary: _charcoalSoul,
        onSurface: _alabaster,
      ),

      // Text theme with custom fonts
      textTheme: const TextTheme(
        // Headlines - Satoshi font
        displayLarge: TextStyle(
          fontFamily: 'Satoshi',
          color: _alabaster,
          fontSize: 57,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Satoshi',
          color: _alabaster,
          fontSize: 45,
          fontWeight: FontWeight.w400,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Satoshi',
          color: _alabaster,
          fontSize: 36,
          fontWeight: FontWeight.w400,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Satoshi',
          color: _alabaster,
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Satoshi',
          color: _alabaster,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Satoshi',
          color: _alabaster,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Satoshi',
          color: _alabaster,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Satoshi',
          color: _alabaster,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Satoshi',
          color: _alabaster,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),

        // Body text - Lora font
        bodyLarge: TextStyle(
          fontFamily: 'Lora',
          color: _alabaster,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Lora',
          color: _alabaster,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Lora',
          color: _alabaster,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),

        // Labels - Satoshi font
        labelLarge: TextStyle(
          fontFamily: 'Satoshi',
          color: _alabaster,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Satoshi',
          color: _alabaster,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Satoshi',
          color: _alabaster,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),

      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: _charcoalSoul,
        foregroundColor: _alabaster,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Satoshi',
          color: _alabaster,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card theme
      cardTheme: const CardThemeData(
        color: _charcoalSoul,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _liquidGold,
          foregroundColor: _charcoalSoul,
          elevation: 2,
          textStyle: const TextStyle(
            fontFamily: 'Satoshi',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _bioElectricCyan,
          textStyle: const TextStyle(
            fontFamily: 'Satoshi',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _liquidGold,
          side: const BorderSide(color: _liquidGold, width: 1),
          textStyle: const TextStyle(
            fontFamily: 'Satoshi',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _charcoalSoul,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _alabaster, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _alabaster.withValues(alpha: 0.5), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _liquidGold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Lora',
          color: _alabaster,
        ),
        hintStyle: TextStyle(
          fontFamily: 'Lora',
          color: _alabaster.withValues(alpha: 0.6),
        ),
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: _alabaster,
        size: 24,
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: _alabaster.withValues(alpha: 0.2),
        thickness: 1,
        space: 1,
      ),
    );
  }
}
