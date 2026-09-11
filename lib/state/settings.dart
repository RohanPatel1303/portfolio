import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

/// The four seed colours offered by the switcher on the home page.
/// Everything else in the app is derived from whichever one is active.
const List<SeedOption> seedOptions = [
  SeedOption("Pink", Color(0xFFFF3D7F)),
  SeedOption("Marigold", Color(0xFFFFC53D)),
  SeedOption("Teal", Color(0xFF00C2A8)),
  SeedOption("Violet", Color(0xFF6C4CFF)),
];

class SeedOption {
  final String name;
  final Color color;
  const SeedOption(this.name, this.color);
}

final seedColorProvider = StateProvider<Color>((ref) => seedOptions.first.color);

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);
