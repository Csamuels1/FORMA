import 'package:flutter/material.dart';

class FormaTheme {
  static ThemeData light() {
    const surface = Color(0xFFF7F7F4);
    const charcoal = Color(0xFF111827);
    const panel = Color(0xFFFFFFFF);
    const accent = Color(0xFF22C55E);
    const blue = Color(0xFF2563EB);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: charcoal,
      brightness: Brightness.light,
    ).copyWith(
      primary: charcoal,
      onPrimary: Colors.white,
      secondary: blue,
      onSecondary: Colors.white,
      tertiary: accent,
      onTertiary: Colors.white,
      surface: panel,
      onSurface: charcoal,
      surfaceContainerHighest: const Color(0xFFEDEDE8),
      onSurfaceVariant: const Color(0xFF4B5563),
      primaryContainer: const Color(0xFFE5E7EB),
      onPrimaryContainer: charcoal,
      secondaryContainer: const Color(0xFFDCEAFE),
      onSecondaryContainer: charcoal,
      tertiaryContainer: const Color(0xFFDCFCE7),
      onTertiaryContainer: charcoal,
      outline: const Color(0xFFD1D5DB),
      inverseSurface: charcoal,
      onInverseSurface: Colors.white,
      inversePrimary: accent,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surface,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
          color: charcoal,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: charcoal,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: charcoal,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.45,
          color: charcoal,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.45,
          color: charcoal,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: panel,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }
}
