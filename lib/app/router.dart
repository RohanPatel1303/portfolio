import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "../pages/about_page.dart";
import "../pages/contact_page.dart";
import "../pages/home_page.dart";
import "../pages/work_page.dart";
import "../widgets/nav_shell.dart";
import "tokens.dart";

final GoRouter appRouter = GoRouter(
  initialLocation: "/",
  routes: [
    ShellRoute(
      builder: (context, state, child) => NavShell(child: child),
      routes: [
        GoRoute(path: "/", pageBuilder: _fade(const HomePage())),
        GoRoute(path: "/about", pageBuilder: _fade(const AboutPage())),
        GoRoute(path: "/work", pageBuilder: _fade(const WorkPage())),
        GoRoute(path: "/contact", pageBuilder: _fade(const ContactPage())),
      ],
    ),
  ],
);

/// A short cross-fade between routes. Anything longer reads as lag.
///
/// Both halves matter. Fading the incoming page in while leaving the outgoing
/// one fully opaque underneath stacks two sets of text over the same pixels
/// for the whole transition, which reads as ghosting rather than as speed —
/// so the outgoing page is faded out via [secondary] as well.
///
/// The two are staggered with [Interval]s rather than with separate durations
/// because the outgoing page's fade is driven by the *incoming* route's clock;
/// there is no second duration to set. Old clears over the first half, new
/// arrives across the second.
Page<void> Function(BuildContext, GoRouterState) _fade(Widget child) {
  return (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: child,
        transitionDuration: Motion.page,
        reverseTransitionDuration: Motion.page,
        transitionsBuilder: (context, animation, secondary, page) {
          // CurveTween.animate, not CurvedAnimation: transitionsBuilder runs
          // once per frame, and a CurvedAnimation registers a listener that
          // would need disposing. This form holds no subscription.
          final enter = _enterOpacity.animate(animation);
          final exit = _exitOpacity.animate(secondary);

          return FadeTransition(
            opacity: exit,
            child: FadeTransition(
              opacity: enter,
              child: SlideTransition(
                position: _enterSlide.animate(animation),
                // The fade needs a saveLayer every frame. On a boundary the
                // rasterised page can be reused across the transition instead
                // of being re-recorded.
                child: RepaintBoundary(child: page),
              ),
            ),
          );
        },
      );
}

final Animatable<double> _enterOpacity = CurveTween(
  curve: const Interval(0.25, 1, curve: Motion.enter),
);

/// Inverted: `secondary` runs 0 -> 1 as this page leaves, so opacity has to
/// run the other way.
final Animatable<double> _exitOpacity = Tween<double>(begin: 1, end: 0).chain(
  CurveTween(curve: const Interval(0, 0.55, curve: Motion.exit)),
);

final Animatable<Offset> _enterSlide = Tween<Offset>(
  begin: const Offset(0, Motion.pageSlide),
  end: Offset.zero,
).chain(CurveTween(curve: const Interval(0.25, 1, curve: Motion.enter)));
