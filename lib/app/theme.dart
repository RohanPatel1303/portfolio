import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "tokens.dart";

/// Display and headline face.
TextStyle _display(double size, {FontWeight weight = FontWeight.w700, double height = 1.05}) =>
    GoogleFonts.getFont(
      "Bricolage Grotesque",
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: size * -0.02,
    );

/// Body and label face.
TextStyle _body(double size, {FontWeight weight = FontWeight.w400, double height = 1.55}) =>
    GoogleFonts.getFont(
      "Instrument Sans",
      fontSize: size,
      fontWeight: weight,
      height: height,
    );

/// Code, dates, and anything tabular.
TextStyle mono(double size, {FontWeight weight = FontWeight.w400}) =>
    GoogleFonts.getFont("JetBrains Mono", fontSize: size, fontWeight: weight, height: 1.5);

/// Every entry here resolves a Google Fonts style, which is far too expensive
/// to redo per rebuild. Built once, colourless; `buildTheme` applies the
/// scheme's colours onto a copy.
final TextTheme _baseTextTheme = TextTheme(
  displayLarge: _display(57),
  displayMedium: _display(45),
  displaySmall: _display(36),
  headlineLarge: _display(32),
  headlineMedium: _display(28),
  headlineSmall: _display(24),
  titleLarge: _display(21, height: 1.15),
  titleMedium: _body(19, weight: FontWeight.w600, height: 1.3),
  titleSmall: _body(16, weight: FontWeight.w600, height: 1.3),
  bodyLarge: _body(17),
  bodyMedium: _body(15.5),
  bodySmall: _body(13.5, height: 1.45),
  labelLarge: _body(15, weight: FontWeight.w600, height: 1.2),
  labelMedium: _body(13.5, weight: FontWeight.w500, height: 1.2),
  labelSmall: mono(12.5),
);

/// `ColorScheme.fromSeed` runs the HCT tonal-palette algorithm, which is far
/// too expensive to call per rebuild — and it ran twice per rebuild here, once
/// for each brightness. Keyed on the only two inputs that change it. Bounded
/// in practice: `seedOptions` holds four colours, so this tops out at eight
/// entries.
final Map<(int, Brightness), ThemeData> _themeCache = {};

ThemeData buildTheme(Color seed, Brightness brightness) =>
    _themeCache.putIfAbsent(
      (seed.toARGB32(), brightness),
      () => _buildTheme(seed, brightness),
    );

ThemeData _buildTheme(Color seed, Brightness brightness) {
  final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);

  final text = _baseTextTheme.apply(
    bodyColor: scheme.onSurface,
    displayColor: scheme.onSurface,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    textTheme: text,
    // InkSparkle is a fragment shader. On web the first tap of a session pays
    // a shader compile that lands as a dropped frame right where the user is
    // looking. InkRipple is plain canvas work and costs nothing up front.
    splashFactory: InkRipple.splashFactory,

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: Gap.x5, vertical: Gap.x4),
        shape: const RoundedRectangleBorder(borderRadius: Radii.allMd),
        textStyle: text.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: Gap.x5, vertical: Gap.x4),
        shape: const RoundedRectangleBorder(borderRadius: Radii.allMd),
        textStyle: text.labelLarge,
        side: BorderSide(color: scheme.outlineVariant, width: 1.5),
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: Radii.allLg),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: scheme.surfaceContainerHighest,
      side: BorderSide.none,
      labelStyle: text.bodySmall,
      padding: const EdgeInsets.symmetric(horizontal: Gap.x3, vertical: Gap.x1),
      shape: const RoundedRectangleBorder(borderRadius: Radii.pill),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: Gap.x4, vertical: Gap.x4),
      border: OutlineInputBorder(
        borderRadius: Radii.allMd,
        borderSide: BorderSide(color: scheme.outlineVariant, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: Radii.allMd,
        borderSide: BorderSide(color: scheme.outlineVariant, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: Radii.allMd,
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: Radii.allMd,
        borderSide: BorderSide(color: scheme.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: Radii.allMd,
        borderSide: BorderSide(color: scheme.error, width: 2),
      ),
    ),

    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: scheme.surfaceContainerLow,
      indicatorColor: scheme.primary,
      selectedLabelTextStyle: text.labelMedium?.copyWith(color: scheme.onSurface),
      unselectedLabelTextStyle: text.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
      selectedIconTheme: IconThemeData(color: scheme.onPrimary, size: 20),
      unselectedIconTheme: IconThemeData(color: scheme.onSurfaceVariant, size: 20),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surfaceContainerLow,
      indicatorColor: scheme.primaryContainer,
      labelTextStyle: WidgetStatePropertyAll(text.labelMedium),
      height: 68,
    ),

    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: text.bodyMedium?.copyWith(color: scheme.onInverseSurface),
      shape: const RoundedRectangleBorder(borderRadius: Radii.allMd),
    ),

    dividerTheme: DividerThemeData(color: scheme.outlineVariant, space: 1),
  );
}
