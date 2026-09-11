import "package:flutter/widgets.dart";

/// 4pt spacing scale. Every gap and padding in the app comes from here.
abstract final class Gap {
  static const double x1 = 4;
  static const double x2 = 8;
  static const double x3 = 12;
  static const double x4 = 16;
  static const double x5 = 24;
  static const double x6 = 32;
  static const double x7 = 48;
  static const double x8 = 64;

  static const SizedBox h2 = SizedBox(height: x2);
  static const SizedBox h3 = SizedBox(height: x3);
  static const SizedBox h4 = SizedBox(height: x4);
  static const SizedBox h5 = SizedBox(height: x5);
  static const SizedBox h6 = SizedBox(height: x6);
  static const SizedBox h7 = SizedBox(height: x7);
  static const SizedBox h8 = SizedBox(height: x8);

  static const SizedBox w2 = SizedBox(width: x2);
  static const SizedBox w3 = SizedBox(width: x3);
  static const SizedBox w4 = SizedBox(width: x4);
  static const SizedBox w5 = SizedBox(width: x5);
}

abstract final class Radii {
  static const Radius sm = Radius.circular(8);
  static const Radius md = Radius.circular(14);
  static const Radius lg = Radius.circular(20);
  static const Radius xl = Radius.circular(28);

  static const BorderRadius allSm = BorderRadius.all(sm);
  static const BorderRadius allMd = BorderRadius.all(md);
  static const BorderRadius allLg = BorderRadius.all(lg);
  static const BorderRadius allXl = BorderRadius.all(xl);
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
}

abstract final class Motion {
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration medium = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 320);
  static const Curve ease = Curves.easeOutCubic;

  /// Route cross-fade. Shorter than [slow] because the nav shell does not
  /// move: only the content column swaps, so the eye has nothing to follow
  /// and any extra duration is read as lag rather than as motion.
  static const Duration page = Duration(milliseconds: 220);

  /// Whole-[ColorScheme] lerp on seed or brightness change. Slower on
  /// purpose: it is a large simultaneous colour change and a fast one reads
  /// as a flash.
  static const Duration theme = Duration(milliseconds: 300);

  /// Decelerate for things arriving, accelerate for things leaving.
  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;

  /// Incoming-page rise, as a fraction of page height. Small on purpose — it
  /// is a hint of direction, not a journey.
  static const double pageSlide = 0.015;

  /// Dwell time on each [PhoneFrame] screen before it auto-advances.
  /// Long enough to read the screen, short enough that a visitor who never
  /// touches it still sees both within one glance at the hero.
  static const Duration phoneAutoAdvance = Duration(seconds: 4);
}

/// Material window size classes.
abstract final class Breakpoints {
  static const double compact = 600;
  static const double medium = 900;
  static const double expanded = 1240;

  static bool isCompact(BuildContext c) =>
      MediaQuery.sizeOf(c).width < medium;
}

/// Max width of the reading column.
const double kContentWidth = 960;
