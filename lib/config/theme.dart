import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens from the IsItVeg design system (Stitch export).
/// Material 3 tonal palette on a lavender-tinted neutral scale.
class AppColors {
  // Surfaces (light)
  static const Color background = Color(0xFFFCF8FF);
  static const Color surface = Color(0xFFFCF8FF);
  static const Color surfaceDim = Color(0xFFDAD7F3);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF5F2FF);
  static const Color surfaceContainer = Color(0xFFEFECFF);
  static const Color surfaceContainerHigh = Color(0xFFE8E5FF);
  static const Color surfaceContainerHighest = Color(0xFFE2E0FC);

  // Content (light)
  static const Color onSurface = Color(0xFF1A1A2E);
  static const Color onSurfaceVariant = Color(0xFF40493D);
  static const Color outline = Color(0xFF707A6C);
  static const Color outlineVariant = Color(0xFFBFCABA);

  // Brand — veg green
  static const Color primary = Color(0xFF0D631B);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF2E7D32);
  static const Color onPrimaryContainer = Color(0xFFCBFFC2);
  static const Color primaryFixed = Color(0xFFA3F69C);
  static const Color inversePrimary = Color(0xFF88D982);
  static const Color surfaceTint = Color(0xFF1B6D24);

  // Non-veg red
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
  static const Color secondary = Color(0xFFB51A1E);

  // Uncertain amber
  static const Color tertiary = Color(0xFF774C00);
  static const Color tertiaryContainer = Color(0xFF986200);
  static const Color tertiaryFixedDim = Color(0xFFFFB957);

  /// Verdict card fill for the "Uncertain" state.
  static const Color uncertain = Color(0xFFF9A825);

  static const Color inverseSurface = Color(0xFF2F2E43);
  static const Color inverseOnSurface = Color(0xFFF2EFFF);

  // Surfaces (dark) — deep navy scale, never pure black
  static const Color backgroundDark = Color(0xFF1A1A2E);
  static const Color surfaceDark = Color(0xFF1A1A2E);
  static const Color surfaceContainerLowestDark = Color(0xFF16162A);
  static const Color surfaceContainerLowDark = Color(0xFF1E2A47);
  static const Color surfaceContainerDark = Color(0xFF222E4C);
  static const Color surfaceContainerHighDark = Color(0xFF283454);
  static const Color surfaceContainerHighestDark = Color(0xFF2F3B5C);
  static const Color onSurfaceDark = Color(0xFFF2EFFF);
  static const Color onSurfaceVariantDark = Color(0xFFC3C7D6);
  static const Color outlineDark = Color(0xFF8C93A6);
  static const Color outlineVariantDark = Color(0xFF3C4664);
  static const Color errorDark = Color(0xFFFFB4AC);
  static const Color onErrorDark = Color(0xFF690005);
  static const Color errorContainerDark = Color(0xFF93000A);
  static const Color onErrorContainerDark = Color(0xFFFFDAD6);
}

/// 8px base grid.
class AppSpacing {
  static const double xs = 4;
  static const double base = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double containerMargin = 16;
  static const double gutter = 12;
  static const double maxContentWidth = 600;
}

class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double full = 999;
}

/// Inter type scale from the design system.
class AppText {
  static TextStyle displayLg(Color color) => GoogleFonts.inter(
        fontSize: 32,
        height: 40 / 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.64,
        color: color,
      );

  static TextStyle displayLgMobile(Color color) => GoogleFonts.inter(
        fontSize: 28,
        height: 36 / 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.28,
        color: color,
      );

  static TextStyle headlineMd(Color color) => GoogleFonts.inter(
        fontSize: 22,
        height: 30 / 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: color,
      );

  static TextStyle titleLg(Color color) => GoogleFonts.inter(
        fontSize: 20,
        height: 28 / 20,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle bodyLg(Color color) => GoogleFonts.inter(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle bodySm(Color color) => GoogleFonts.inter(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle labelCaps(Color color) => GoogleFonts.inter(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: color,
      );
}

/// Per-brightness token lookup so widgets can stay theme-agnostic.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color outline;
  final Color outlineVariant;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color primary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color tertiary;
  final Color uncertain;

  const AppPalette({
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.outline,
    required this.outlineVariant,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.primary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.tertiary,
    required this.uncertain,
  });

  static const AppPalette light = AppPalette(
    surfaceContainerLowest: AppColors.surfaceContainerLowest,
    surfaceContainerLow: AppColors.surfaceContainerLow,
    surfaceContainer: AppColors.surfaceContainer,
    surfaceContainerHigh: AppColors.surfaceContainerHigh,
    surfaceContainerHighest: AppColors.surfaceContainerHighest,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    onSurface: AppColors.onSurface,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    primary: AppColors.primary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    tertiary: AppColors.tertiary,
    uncertain: AppColors.uncertain,
  );

  static const AppPalette dark = AppPalette(
    surfaceContainerLowest: AppColors.surfaceContainerLowestDark,
    surfaceContainerLow: AppColors.surfaceContainerLowDark,
    surfaceContainer: AppColors.surfaceContainerDark,
    surfaceContainerHigh: AppColors.surfaceContainerHighDark,
    surfaceContainerHighest: AppColors.surfaceContainerHighestDark,
    outline: AppColors.outlineDark,
    outlineVariant: AppColors.outlineVariantDark,
    onSurface: AppColors.onSurfaceDark,
    onSurfaceVariant: AppColors.onSurfaceVariantDark,
    primary: AppColors.inversePrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    error: AppColors.errorDark,
    onError: AppColors.onErrorDark,
    errorContainer: AppColors.errorContainerDark,
    onErrorContainer: AppColors.onErrorContainerDark,
    tertiary: AppColors.tertiaryFixedDim,
    uncertain: AppColors.uncertain,
  );

  @override
  AppPalette copyWith() => this;

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) =>
      t < 0.5 ? this : (other as AppPalette? ?? this);
}

extension AppPaletteX on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}

class AppTheme {
  static TextTheme _textTheme(Color onSurface, Color onSurfaceVariant) {
    return TextTheme(
      displayLarge: AppText.displayLg(onSurface),
      displayMedium: AppText.displayLgMobile(onSurface),
      headlineMedium: AppText.headlineMd(onSurface),
      titleLarge: AppText.titleLg(onSurface),
      bodyLarge: AppText.bodyLg(onSurface),
      bodyMedium: AppText.bodySm(onSurfaceVariant),
      labelSmall: AppText.labelCaps(onSurfaceVariant),
    );
  }

  static ThemeData light() {
    const scheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      tertiary: AppColors.tertiary,
      onTertiary: Colors.white,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      surfaceContainerLowest: AppColors.surfaceContainerLowest,
      surfaceContainerLow: AppColors.surfaceContainerLow,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      inverseSurface: AppColors.inverseSurface,
      onInverseSurface: AppColors.inverseOnSurface,
      inversePrimary: AppColors.inversePrimary,
    );
    return _build(scheme, AppPalette.light, AppColors.background);
  }

  static ThemeData dark() {
    const scheme = ColorScheme.dark(
      primary: AppColors.inversePrimary,
      onPrimary: Color(0xFF002204),
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: Color(0xFFFFB4AC),
      onSecondary: Color(0xFF410003),
      tertiary: AppColors.tertiaryFixedDim,
      onTertiary: Color(0xFF2A1800),
      error: AppColors.errorDark,
      onError: AppColors.onErrorDark,
      errorContainer: AppColors.errorContainerDark,
      onErrorContainer: AppColors.onErrorContainerDark,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.onSurfaceDark,
      onSurfaceVariant: AppColors.onSurfaceVariantDark,
      surfaceContainerLowest: AppColors.surfaceContainerLowestDark,
      surfaceContainerLow: AppColors.surfaceContainerLowDark,
      surfaceContainer: AppColors.surfaceContainerDark,
      surfaceContainerHigh: AppColors.surfaceContainerHighDark,
      surfaceContainerHighest: AppColors.surfaceContainerHighestDark,
      outline: AppColors.outlineDark,
      outlineVariant: AppColors.outlineVariantDark,
      inverseSurface: AppColors.inverseOnSurface,
      onInverseSurface: AppColors.inverseSurface,
      inversePrimary: AppColors.primary,
    );
    return _build(scheme, AppPalette.dark, AppColors.backgroundDark);
  }

  static ThemeData _build(
    ColorScheme scheme,
    AppPalette palette,
    Color background,
  ) {
    final textTheme = _textTheme(scheme.onSurface, scheme.onSurfaceVariant);

    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      extensions: [palette],
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurfaceVariant,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        toolbarHeight: 64,
        titleTextStyle: AppText.headlineMd(palette.primary),
        iconTheme: IconThemeData(color: scheme.onSurfaceVariant),
        actionsIconTheme: IconThemeData(color: scheme.onSurfaceVariant),
        surfaceTintColor: Colors.transparent,
        shape: Border(
          bottom: BorderSide(color: palette.outlineVariant, width: 1),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: palette.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: palette.outlineVariant),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          minimumSize: const Size(double.infinity, 56),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: const StadiumBorder(),
          textStyle:
              AppText.labelCaps(scheme.onPrimary).copyWith(letterSpacing: 1.2),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.primary,
          side: BorderSide(color: palette.primary, width: 2),
          minimumSize: const Size(double.infinity, 56),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: const StadiumBorder(),
          textStyle: AppText.titleLg(palette.primary),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primary,
          textStyle: AppText.bodySm(palette.primary)
              .copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: palette.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: palette.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: palette.primary, width: 2),
        ),
        hintStyle:
            AppText.bodyLg(scheme.onSurfaceVariant.withValues(alpha: 0.5)),
        contentPadding: const EdgeInsets.all(AppSpacing.md),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        titleTextStyle: AppText.titleLg(scheme.onSurface),
        contentTextStyle: AppText.bodySm(scheme.onSurfaceVariant),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: AppText.bodySm(scheme.onInverseSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
      ),
      dividerTheme:
          DividerThemeData(color: palette.outlineVariant, thickness: 1),
      progressIndicatorTheme:
          ProgressIndicatorThemeData(color: palette.primary),
    );
  }
}
