import 'package:flutter/material.dart';

/// Global theme mode controller (defaults to Vice Synthwave Dark Mode).
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.dark);

class AppColors {
  // Vice Synthwave palette from DESIGN.md
  static const Color canvas = Color(0xFF0C0E17);
  static const Color surface = Color(0xFF11131C);
  static const Color cardLow = Color(0xFF181B28);
  static const Color cardHigh = Color(0xFF1E2235);
  static const Color cardHighest = Color(0xFF282933);

  static const Color neonPink = Color(0xFFFF2A85);
  static const Color neonPinkBright = Color(0xFFFF4A8E);
  static const Color neonPinkSoft = Color(0xFFFFB1C5);
  static const Color synthPurple = Color(0xFF8B5CF6);
  static const Color synthPurpleSoft = Color(0xFFD0BCFF);
  static const Color laserCyan = Color(0xFF4CD7F6);
  static const Color laserCyanDark = Color(0xFF06B6D4);

  static const Color gpsGreen = Color(0xFF10B981);
  static const Color gpsAmber = Color(0xFFF59E0B);
  static const Color gpsRed = Color(0xFFEF4444);

  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color glassBorder = Color(0x18FFFFFF);
}

class AppTheme {
  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.neonPinkSoft,
      onPrimary: Color(0xFF65002F),
      primaryContainer: AppColors.neonPink,
      onPrimaryContainer: Colors.white,
      secondary: AppColors.synthPurpleSoft,
      onSecondary: Color(0xFF3C0091),
      secondaryContainer: Color(0xFF3A1A78),
      onSecondaryContainer: Color(0xFFE9DDFF),
      tertiary: AppColors.laserCyan,
      onTertiary: Color(0xFF003640),
      tertiaryContainer: Color(0xFF004E5C),
      onTertiaryContainer: Color(0xFFACEDFF),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      outline: Color(0xFF64748B),
      outlineVariant: Color(0xFF2E3248),
      surfaceContainerLowest: AppColors.canvas,
      surfaceContainerLow: AppColors.cardLow,
      surfaceContainer: AppColors.cardLow,
      surfaceContainerHigh: AppColors.cardHigh,
      surfaceContainerHighest: AppColors.cardHighest,
      inverseSurface: Color(0xFFE1E1EF),
      onInverseSurface: Color(0xFF2E303A),
      inversePrimary: AppColors.neonPink,
      surfaceTint: AppColors.neonPink,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.canvas,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.canvas,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardLow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardLow,
        hintStyle: const TextStyle(color: Color(0xFF64748B)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF2E3248)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF2E3248)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.neonPink, width: 1.8),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.canvas,
        indicatorColor: AppColors.neonPink.withValues(alpha: 0.18),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.neonPink : AppColors.textSecondary,
          );
        }),
      ),
    );
  }

  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFBA005C),
      onPrimary: Colors.white,
      primaryContainer: AppColors.neonPink,
      onPrimaryContainer: Colors.white,
      secondary: Color(0xFF571BC1),
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFE9DDFF),
      onSecondaryContainer: Color(0xFF23005C),
      tertiary: Color(0xFF00677C),
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFACEDFF),
      onTertiaryContainer: Color(0xFF001F26),
      error: Color(0xFFBA1A1A),
      onError: Colors.white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF93000A),
      surface: Color(0xFFF6F7FB),
      onSurface: Color(0xFF11131C),
      onSurfaceVariant: Color(0xFF475569),
      outline: Color(0xFF94A3B8),
      outlineVariant: Color(0xFFCBD5E1),
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: Color(0xFFF1F5F9),
      surfaceContainer: Color(0xFFE2E8F0),
      surfaceContainerHigh: Color(0xFFDCE3F0),
      surfaceContainerHighest: Color(0xFFCBD5E1),
      inverseSurface: Color(0xFF11131C),
      onInverseSurface: Color(0xFFF1F5F9),
      inversePrimary: AppColors.neonPinkSoft,
      surfaceTint: AppColors.neonPink,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.neonPink, width: 1.8),
        ),
      ),
    );
  }
}
