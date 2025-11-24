import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App color scheme
class AppColors {
  static const Color primary = Color(0xFF0066CC); // Strong blue
  static const Color primaryVariant = Color(0xFF004C99);
  static const Color secondary = Color(0xFFFFA726); // Warm orange
  static const Color background = Color(0xFFF6F8FA);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFB00020);
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.black87;
  static const Color onBackground = Colors.black87;
  static const Color onSurface = Colors.black87;
}

/// Centralized app theme definitions. Uses two Google Fonts:
/// - 'Poppins' for headings (clean, modern)
/// - 'Roboto' for body text (readable UI text)
class AppTheme {
  static final ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    error: AppColors.error,
    onError: Colors.white,
    background: AppColors.surface,
    onBackground: AppColors.onSurface,
    surface: AppColors.surface,
    onSurface: AppColors.onBackground,
  );

  static final ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryVariant,
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    error: AppColors.error,
    onError: Colors.black,
    background: const Color(0xFF121417),
    onBackground: Colors.white,
    surface: const Color(0xFF121417),
    onSurface: Colors.white,
  );

  // Text theme using Google Fonts. Poppins for headings, Roboto for body.
  static TextTheme _textTheme(ColorScheme colors) {
    final base = Typography.material2018().black;

    return TextTheme(
      displayLarge: GoogleFonts.poppins(
          textStyle: base.displayLarge?.copyWith(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        color: colors.onSurface,
      )),
      displayMedium: GoogleFonts.poppins(
          textStyle: base.displayMedium?.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: colors.onSurface,
      )),
      displaySmall: GoogleFonts.poppins(
          textStyle: base.displaySmall?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: colors.onSurface,
      )),
      headlineLarge: GoogleFonts.poppins(
          textStyle: base.headlineLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: colors.onSurface,
      )),
      headlineMedium: GoogleFonts.poppins(
          textStyle: base.headlineMedium?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: colors.onSurface,
      )),
      titleLarge: GoogleFonts.poppins(
          textStyle: base.titleLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colors.onSurface,
      )),
      titleMedium: GoogleFonts.poppins(
          textStyle: base.titleMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colors.onSurface,
      )),
      titleSmall: GoogleFonts.poppins(
          textStyle: base.titleSmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: colors.onSurface,
      )),
      bodyLarge: GoogleFonts.roboto(
          textStyle: base.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: colors.onSurface,
      )),
      bodyMedium: GoogleFonts.roboto(
          textStyle: base.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colors.onSurface,
      )),
      bodySmall: GoogleFonts.roboto(
          textStyle: base.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: colors.onSurface,
      )),
      labelLarge: GoogleFonts.roboto(
          textStyle: base.labelLarge?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: colors.onSurface,
      )),
      labelSmall: GoogleFonts.roboto(
          textStyle: base.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: colors.onSurface,
      )),
    );
  }

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      scaffoldBackgroundColor: _lightColorScheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: _lightColorScheme.primary,
        foregroundColor: _lightColorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _lightColorScheme.onPrimary),
      ),
      cardTheme: CardTheme(
        color: _lightColorScheme.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightColorScheme.primary,
          foregroundColor: _lightColorScheme.onPrimary,
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textTheme: _textTheme(_lightColorScheme),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _darkColorScheme,
      scaffoldBackgroundColor: _darkColorScheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: _darkColorScheme.primary,
        foregroundColor: _darkColorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _darkColorScheme.onPrimary),
      ),
      cardTheme: CardTheme(
        color: _darkColorScheme.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkColorScheme.primary,
          foregroundColor: _darkColorScheme.onPrimary,
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textTheme: _textTheme(_darkColorScheme),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1A1C1F),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
