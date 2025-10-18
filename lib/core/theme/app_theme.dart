import 'package:flutter/material.dart';

/// App theme configuration with "Silent Luxury" visual identity.
///
/// Inspired by six-star regenerative medicine retreats, this theme provides:
/// - Deep Charcoal background (#121212) - sophisticated, almost black
/// - Subtle Gold accent (#B89A6A) - elegant, not brilliant
/// - Soft Cream text (#F5F5F0) - warm, off-white for reduced eye strain
/// - Lora Serif for elegant headlines
/// - Satoshi Sans-Serif for clean body text and buttons
/// - Minimalist, refined aesthetic
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Silent Luxury Color Palette
  static const Color _deepCharcoal = Color(0xFF121212);
  static const Color _subtleGold = Color(0xFFB89A6A);
  static const Color _softCream = Color(0xFFF5F5F0);
  static const Color _mutedGrey = Color(0xFF4A4A4A);

  /// Returns the light theme configuration.
  ///
  /// Note: Despite the name "lightTheme", this implements a dark theme
  /// based on the "Silent Luxury" visual identity specification.
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Background colors
      scaffoldBackgroundColor: _deepCharcoal,

      // Primary color
      primaryColor: _subtleGold,

      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: _subtleGold,
        secondary: _mutedGrey,
        surface: _deepCharcoal,
        onPrimary: _deepCharcoal,
        onSecondary: _softCream,
        onSurface: _softCream,
      ),

      // Text theme with custom fonts
      textTheme: const TextTheme(
        // Headlines - Lora Serif (elegant, luxury aesthetic)
        displayLarge: TextStyle(
          fontFamily: 'Lora',
          color: _softCream,
          fontSize: 57,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
          height: 1.12,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Lora',
          color: _softCream,
          fontSize: 45,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.25,
          height: 1.16,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Lora',
          color: _softCream,
          fontSize: 36,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 1.22,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Lora',
          color: _softCream,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          height: 1.25,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Lora',
          color: _softCream,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          height: 1.29,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Lora',
          color: _softCream,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          height: 1.33,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Lora',
          color: _softCream,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 1.27,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Lora',
          color: _softCream,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
          height: 1.50,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Lora',
          color: _softCream,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          height: 1.43,
        ),

        // Body text - Satoshi Sans-Serif (clean, modern, readable)
        bodyLarge: TextStyle(
          fontFamily: 'Satoshi',
          color: _softCream,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          height: 1.50,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Satoshi',
          color: _softCream,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          height: 1.43,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Satoshi',
          color: _softCream,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          height: 1.33,
        ),

        // Labels - Satoshi Sans-Serif (buttons, UI elements)
        labelLarge: TextStyle(
          fontFamily: 'Satoshi',
          color: _softCream,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          height: 1.43,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Satoshi',
          color: _softCream,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          height: 1.33,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Satoshi',
          color: _softCream,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          height: 1.45,
        ),
      ),

      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: _deepCharcoal,
        foregroundColor: _softCream,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Lora',
          color: _softCream,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: Color(0xFF1A1A1A), // Slightly lighter than background for depth
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: _subtleGold.withValues(alpha: 0.1), width: 1),
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _subtleGold,
          foregroundColor: _deepCharcoal,
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: const TextStyle(
            fontFamily: 'Satoshi',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          minimumSize: const Size(120, 48),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _subtleGold,
          textStyle: const TextStyle(
            fontFamily: 'Satoshi',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _subtleGold,
          side: const BorderSide(color: _subtleGold, width: 1.5),
          textStyle: const TextStyle(
            fontFamily: 'Satoshi',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          minimumSize: const Size(120, 48),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF1A1A1A),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _mutedGrey.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _mutedGrey.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _subtleGold, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCF6679), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCF6679), width: 1.5),
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Satoshi',
          color: _softCream,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: TextStyle(
          fontFamily: 'Satoshi',
          color: _softCream.withValues(alpha: 0.5),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Icon theme
      iconTheme: const IconThemeData(color: _softCream, size: 24),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: _subtleGold.withValues(alpha: 0.15),
        thickness: 1,
        space: 1,
      ),
    );
  }
}
