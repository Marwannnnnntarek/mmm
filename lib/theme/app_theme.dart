import 'package:flutter/material.dart';

class SlaColors {
  SlaColors._();

  static const primaryPurple = Color(0xFF5B1691);
  static const secondaryPurple = Color(0xFF8A4DFF);
  static const darkNavy = Color(0xFF0D1B3D);
  static const orange = Color(0xFFFF6A00);
  static const yellow = Color(0xFFFFC107);
  static const redOrange = Color(0xFFE63900);

  static const background = Color(0xFFF7F5FF);
  static const inputBorder = Color(0xFFCDC4E8);
  static const textSecondary = Color(0xFF6B5F8A);
  static const disabledBg = Color(0xFFCDC4E8);
}

class SlaGradients {
  SlaGradients._();

  static const header = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [SlaColors.darkNavy, SlaColors.primaryPurple],
  );

  static const welcomeBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [SlaColors.darkNavy, Color(0xFF3A0F7C)],
  );

  static const button = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [SlaColors.primaryPurple, SlaColors.secondaryPurple],
  );

  static const heroButton = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [SlaColors.primaryPurple, SlaColors.orange],
  );
}

ThemeData buildSlaTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: SlaColors.primaryPurple,
      brightness: Brightness.light,
    ).copyWith(
      primary: SlaColors.primaryPurple,
      onPrimary: Colors.white,
      secondary: SlaColors.secondaryPurple,
      tertiary: SlaColors.orange,
      error: SlaColors.redOrange,
      surface: Colors.white,
      onSurface: SlaColors.darkNavy,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: SlaColors.background,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: SlaColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: SlaColors.primaryPurple, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: SlaColors.redOrange),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: SlaColors.redOrange, width: 2),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      labelStyle: const TextStyle(
        color: SlaColors.textSecondary,
        fontSize: 14,
      ),
      hintStyle: const TextStyle(color: Color(0xFFB0A8C8)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: SlaColors.primaryPurple,
        foregroundColor: Colors.white,
        disabledBackgroundColor: SlaColors.disabledBg,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 3,
        shadowColor: SlaColors.primaryPurple.withValues(alpha: 0.4),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? SlaColors.primaryPurple
              : null,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.white
              : SlaColors.darkNavy,
        ),
      ),
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? SlaColors.primaryPurple
            : null,
      ),
      thumbColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.selected) ? Colors.white : null,
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: SlaColors.primaryPurple,
    ),
    dialogTheme: const DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: SlaColors.darkNavy,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      behavior: SnackBarBehavior.floating,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: SlaColors.darkNavy,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: SlaColors.darkNavy,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: SlaColors.darkNavy,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: SlaColors.darkNavy,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: SlaColors.darkNavy,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(color: SlaColors.darkNavy),
      bodyMedium: TextStyle(color: SlaColors.darkNavy),
    ),
  );
}
