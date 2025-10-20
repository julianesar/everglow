import 'package:flutter/material.dart';

/// App theme configuration with "Charcoal & Gold" visual identity.
///
/// This theme provides a modern, vibrant aesthetic with:
/// - Deep Charcoal background (#121212) - sophisticated, almost black
/// - Everglow Gold accent (#F5B800) - vibrant, energetic
/// - Soft Off-White text (#FAFAFA) - clean, excellent contrast
/// - Inter font family for all text (headlines, body, buttons)
/// - Modern, clean aesthetic with rounded components
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Charcoal & Gold Color Palette
  static const Color _deepCharcoal = Color(0xFF121212);
  static const Color _everglowGold = Color(0xFFF5B800);
  static const Color _softWhite = Color(0xFFFAFAFA);
  static const Color _cardBackground = Color(0xFF1A1A1A);

  /// Returns the theme configuration with "Charcoal & Gold" visual identity.
  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Background colors
      scaffoldBackgroundColor: _deepCharcoal,

      // Primary color
      primaryColor: _everglowGold,

      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: _everglowGold,
        secondary: _everglowGold,
        surface: _deepCharcoal,
        onPrimary: _deepCharcoal,
        onSecondary: _deepCharcoal,
        onSurface: _softWhite,
        error: Color(0xFFCF6679),
        onError: _deepCharcoal,
      ),

      // Text theme with Inter font family
      textTheme: const TextTheme(
        // Display styles
        displayLarge: TextStyle(
          fontFamily: 'Inter',
          color: _softWhite,
          fontSize: 57,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          height: 1.12,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Inter',
          color: _softWhite,
          fontSize: 45,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.25,
          height: 1.16,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Inter',
          color: _softWhite,
          fontSize: 36,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          height: 1.22,
        ),

        // Headline styles
        headlineLarge: TextStyle(
          fontFamily: 'Inter',
          color: _softWhite,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          height: 1.25,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Inter',
          color: _softWhite,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          height: 1.29,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Inter',
          color: _softWhite,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          height: 1.33,
        ),

        // Title styles
        titleLarge: TextStyle(
          fontFamily: 'Inter',
          color: _softWhite,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 1.27,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Inter',
          color: _softWhite,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
          height: 1.50,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Inter',
          color: _softWhite,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          height: 1.43,
        ),

        // Body text
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          color: _softWhite,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          height: 1.50,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Inter',
          color: _softWhite,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          height: 1.43,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Inter',
          color: _softWhite,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          height: 1.33,
        ),

        // Labels (buttons, UI elements)
        labelLarge: TextStyle(
          fontFamily: 'Inter',
          color: _softWhite,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          height: 1.43,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Inter',
          color: _softWhite,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          height: 1.33,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Inter',
          color: _softWhite,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          height: 1.45,
        ),
      ),

      // AppBar theme with Everglow Gold accents
      appBarTheme: const AppBarTheme(
        backgroundColor: _deepCharcoal,
        foregroundColor: _everglowGold,
        iconTheme: IconThemeData(color: _everglowGold),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          color: _everglowGold,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: _cardBackground,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Elevated button theme - Fully rounded with Everglow Gold
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _everglowGold,
          foregroundColor: _deepCharcoal,
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(56),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          minimumSize: const Size(120, 48),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _everglowGold,
          textStyle: const TextStyle(
            fontFamily: 'Inter',
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
          foregroundColor: _everglowGold,
          side: const BorderSide(color: _everglowGold, width: 1.5),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(56),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          minimumSize: const Size(120, 48),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _cardBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: _softWhite.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: _softWhite.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _everglowGold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFCF6679), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFCF6679), width: 2),
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          color: _softWhite,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: TextStyle(
          fontFamily: 'Inter',
          color: _softWhite.withValues(alpha: 0.5),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Icon theme
      iconTheme: const IconThemeData(color: _softWhite, size: 24),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: _everglowGold.withValues(alpha: 0.2),
        thickness: 1,
        space: 1,
      ),
    );
  }

  /// Returns a contextual gradient color based on the day number.
  ///
  /// This allows UI components (like DayScreen headers) to use dynamic
  /// colors that vary by day while maintaining the overall visual identity.
  ///
  /// - Day 1: Warm amber (#E67E22)
  /// - Day 2: Soft teal (#1ABC9C)
  /// - Day 3+: Everglow Gold (#F5B800)
  static Color getGradientColorForDay(int dayNumber) {
    switch (dayNumber) {
      case 1:
        return const Color(0xFFE67E22); // Warm amber
      case 2:
        return const Color(0xFF1ABC9C); // Soft teal
      case 3:
        return _everglowGold; // Everglow Gold
      default:
        return _everglowGold; // Everglow Gold (default)
    }
  }
}
