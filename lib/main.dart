import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "app/router.dart";
import "app/theme.dart";
import "app/tokens.dart";
import "state/settings.dart";

void main() => runApp(const ProviderScope(child: PortfolioApp()));

class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seed = ref.watch(seedColorProvider);
    final mode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: "Rohan Patel - Flutter developer",
      debugShowCheckedModeBanner: false,
      theme: buildTheme(seed, Brightness.light),
      darkTheme: buildTheme(seed, Brightness.dark),
      themeMode: mode,
      // The whole ColorScheme is lerped here, once, which is why nothing
      // downstream animates a scheme colour itself. The default is 200ms of
      // Curves.linear; a seed swap is a large simultaneous colour change and
      // needs both a little longer and an actual ease to not read as a flash.
      themeAnimationDuration: Motion.theme,
      themeAnimationCurve: Motion.ease,
      routerConfig: appRouter,
    );
  }
}
