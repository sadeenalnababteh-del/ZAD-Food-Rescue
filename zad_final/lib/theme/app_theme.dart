import 'package:flutter/material.dart';
class ZadColors {
  static const primary = Color(0xFF0D631B);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF2E7D32);
  static const onPrimaryContainer = Color(0xFFCBFFC2);
  static const primaryFixed = Color(0xFFA3F69C);
  static const primaryFixedDim = Color(0xFF88D982);
  static const inversePrimary = Color(0xFF88D982);
  static const secondary = Color(0xFFB6171E);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFDA3433);
  static const onSecondaryContainer = Color(0xFFFFFBFF);
  static const secondaryFixed = Color(0xFFFFDAD6);
  static const secondaryFixedDim = Color(0xFFFFB3AC);
  static const tertiary = Color(0xFF923357);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFFB14B6F);
  static const onTertiaryContainer = Color(0xFFFFEDF0);
  static const tertiaryFixed = Color(0xFFFFD9E2);
  static const tertiaryFixedDim = Color(0xFFFFB1C7);
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);
  static const background = Color(0xFFF9F9FC);
  static const onBackground = Color(0xFF1A1C1E);
  static const surface = Color(0xFFF9F9FC);
  static const onSurface = Color(0xFF1A1C1E);
  static const surfaceDim = Color(0xFFDADADC);
  static const surfaceBright = Color(0xFFF9F9FC);
  static const surfaceVariant = Color(0xFFE2E2E5);
  static const onSurfaceVariant = Color(0xFF40493D);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF3F3F6);
  static const surfaceContainer = Color(0xFFEEEEF0);
  static const surfaceContainerHigh = Color(0xFFE8E8EA);
  static const surfaceContainerHighest = Color(0xFFE2E2E5);
  static const inverseSurface = Color(0xFF2F3133);
  static const inverseOnSurface = Color(0xFFF0F0F3);
  static const outline = Color(0xFF707A6C);
  static const outlineVariant = Color(0xFFBFCABA);
  static const surfaceTint = Color(0xFF1B6D24);
}
class ZadTextStyles {
  static const headlineXl = TextStyle(
    fontSize: 32,
    height: 1.25,
    letterSpacing: -0.64,
    fontWeight: FontWeight.w700,
  );
  static const headlineLg = TextStyle(
    fontSize: 24,
    height: 1.33,
    letterSpacing: -0.24,
    fontWeight: FontWeight.w700,
  );
  static const headlineMd = TextStyle(
    fontSize: 20,
    height: 1.4,
    fontWeight: FontWeight.w600,
  );
  static const bodyLg = TextStyle(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );
  static const bodyMd = TextStyle(
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w400,
  );
  static const labelLg = TextStyle(
    fontSize: 14,
    height: 1.43,
    letterSpacing: 0.14,
    fontWeight: FontWeight.w600,
  );
  static const labelMd = TextStyle(
    fontSize: 12,
    height: 1.33,
    letterSpacing: 0.48,
    fontWeight: FontWeight.w600,
  );
  static const labelSm = TextStyle(
    fontSize: 11,
    height: 1.45,
    letterSpacing: 0.55,
    fontWeight: FontWeight.w500,
  );
}
ThemeData zadLightTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: ZadColors.background,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: ZadColors.primary,
      onPrimary: ZadColors.onPrimary,
      primaryContainer: ZadColors.primaryContainer,
      onPrimaryContainer: ZadColors.onPrimaryContainer,
      secondary: ZadColors.secondary,
      onSecondary: ZadColors.onSecondary,
      secondaryContainer: ZadColors.secondaryContainer,
      onSecondaryContainer: ZadColors.onSecondaryContainer,
      tertiary: ZadColors.tertiary,
      onTertiary: ZadColors.onTertiary,
      tertiaryContainer: ZadColors.tertiaryContainer,
      onTertiaryContainer: ZadColors.onTertiaryContainer,
      error: ZadColors.error,
      onError: ZadColors.onError,
      errorContainer: ZadColors.errorContainer,
      onErrorContainer: ZadColors.onErrorContainer,
      surface: ZadColors.surface,
      onSurface: ZadColors.onSurface,
      surfaceContainerHighest: ZadColors.surfaceContainerHighest,
      onSurfaceVariant: ZadColors.onSurfaceVariant,
      outline: ZadColors.outline,
      outlineVariant: ZadColors.outlineVariant,
      inverseSurface: ZadColors.inverseSurface,
      onInverseSurface: ZadColors.inverseOnSurface,
      inversePrimary: ZadColors.inversePrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: ZadColors.surface,
      foregroundColor: ZadColors.onSurface,
      elevation: 0,
      scrolledUnderElevation: 1,
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: ZadColors.primary,
        letterSpacing: -0.24,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: ZadColors.surfaceContainer,
      indicatorColor: ZadColors.primaryContainer,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: ZadColors.onPrimaryContainer);
        }
        return const IconThemeData(color: ZadColors.onSurfaceVariant);
      }),
      labelTextStyle: WidgetStateProperty.all(
        ZadTextStyles.labelSm.copyWith(fontFamily: 'Inter'),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ZadColors.primary,
        foregroundColor: ZadColors.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: ZadTextStyles.labelLg.copyWith(fontFamily: 'Inter'),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ZadColors.primary,
        side: const BorderSide(color: ZadColors.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: ZadTextStyles.labelLg.copyWith(fontFamily: 'Inter'),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ZadColors.surfaceContainerLow,
      border: const UnderlineInputBorder(
        borderSide: BorderSide(color: ZadColors.outline),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: ZadColors.outline),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: ZadColors.primary, width: 2),
      ),
      labelStyle: ZadTextStyles.labelMd.copyWith(
        color: ZadColors.onSurfaceVariant,
        fontFamily: 'Inter',
      ),
      hintStyle: ZadTextStyles.bodyMd.copyWith(
        color: ZadColors.onSurfaceVariant,
        fontFamily: 'Inter',
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    cardTheme: CardThemeData(
      color: ZadColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: ZadColors.outlineVariant),
      ),
      margin: EdgeInsets.zero,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ZadColors.primary,
      foregroundColor: ZadColors.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: ZadColors.outlineVariant,
      thickness: 1,
      space: 0,
    ),
  );
}