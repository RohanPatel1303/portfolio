import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "package:rohan_portfolio/app/theme.dart";
import "package:rohan_portfolio/app/tokens.dart";
import "package:rohan_portfolio/main.dart";
import "package:rohan_portfolio/state/settings.dart";

void main() {
  group("theme memoisation", () {
    // testWidgets, not test: buildTheme resolves Google Fonts styles, which
    // starts an async font fetch. Without a binding that failure lands after
    // the test has completed and is reported against whichever test ran first.
    testWidgets("same seed and brightness returns the identical instance",
        (tester) async {
      final a = buildTheme(seedOptions.first.color, Brightness.light);
      final b = buildTheme(seedOptions.first.color, Brightness.light);
      expect(identical(a, b), isTrue,
          reason: "ColorScheme.fromSeed must not re-run per rebuild");
    });

    testWidgets("brightness and seed are both part of the key",
        (tester) async {
      final light = buildTheme(seedOptions.first.color, Brightness.light);
      final dark = buildTheme(seedOptions.first.color, Brightness.dark);
      final other = buildTheme(seedOptions.last.color, Brightness.light);

      expect(light.brightness, Brightness.light);
      expect(dark.brightness, Brightness.dark);
      expect(identical(light, dark), isFalse);
      expect(identical(light, other), isFalse);
      expect(light.colorScheme.primary, isNot(other.colorScheme.primary));
    });
  });

  testWidgets("the outgoing page fades out instead of sitting opaque",
      (tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const ProviderScope(child: PortfolioApp()));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text("See the apps"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("See the apps"));

    // Sample across the transition. The regression this guards against is the
    // outgoing route being left at 1.0 for the whole duration while the new
    // one fades in over it, which reads as ghosted text rather than as speed.
    // Track the lowest opacity reached by the page that is on its way out.
    // If the outgoing route were left opaque underneath — the bug — this would
    // never drop below 1.0.
    var outgoingLow = 1.0;
    var sawPartial = false;

    for (var t = 0; t < Motion.page.inMilliseconds; t += 20) {
      await tester.pump(const Duration(milliseconds: 20));
      for (final o in tester
          .widgetList<FadeTransition>(find.byType(FadeTransition))
          .map((f) => f.opacity.value)) {
        if (o > 0 && o < 1) sawPartial = true;
        if (o < outgoingLow) outgoingLow = o;
      }
    }

    expect(sawPartial, isTrue,
        reason: "nothing was ever mid-fade; the cross-fade is not running");
    expect(outgoingLow, lessThan(0.05),
        reason: "the outgoing page never faded out (low was $outgoingLow)");

    await tester.pumpAndSettle();
    expect(find.text("Enterprise apps, not demos"), findsOneWidget);
  });

  testWidgets("no scheme colour is animated at the widget level",
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PortfolioApp()));
    await tester.pumpAndSettle();

    final scheme = Theme.of(tester.element(find.byType(Scaffold).first))
        .colorScheme;

    // MaterialApp already lerps every one of these on a theme change. A second
    // ease on the same value is what made the seed switch look like it was
    // dragging. Raw colours (the seed swatches) and hover state are fine, so
    // this checks membership in the scheme rather than banning colour outright.
    final lerped = <Color>{
      scheme.primary,
      scheme.onPrimary,
      scheme.primaryContainer,
      scheme.surface,
      scheme.surfaceContainerLow,
      scheme.surfaceContainerHighest,
      scheme.onSurface,
      scheme.onSurfaceVariant,
    };

    for (final c in tester.widgetList<AnimatedContainer>(
      find.byType(AnimatedContainer),
    )) {
      final d = c.decoration;
      if (d is BoxDecoration && d.color != null) {
        expect(lerped, isNot(contains(d.color)),
            reason: "AnimatedContainer must not animate a scheme colour");
      }
    }
  });
}
