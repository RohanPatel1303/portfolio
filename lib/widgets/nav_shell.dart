import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../app/tokens.dart";
import "../state/settings.dart";

class _Dest {
  final String path;
  final String label;
  final IconData icon;
  const _Dest(this.path, this.label, this.icon);
}

const _destinations = <_Dest>[
  _Dest("/", "Home", Icons.home_rounded),
  _Dest("/about", "About", Icons.account_circle_rounded),
  _Dest("/work", "Work", Icons.work_rounded),
  _Dest("/contact", "Contact", Icons.drafts_rounded),
];

/// Holds the persistent navigation around every route.
/// Rail on the right at >= 900px, bottom bar below that.
class NavShell extends ConsumerWidget {
  const NavShell({super.key, required this.child});

  final Widget child;

  int _indexFor(String location) {
    for (var i = _destinations.length - 1; i > 0; i--) {
      if (location.startsWith(_destinations[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;
    final index = _indexFor(location);
    final compact = Breakpoints.isCompact(context);

    final content = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: kContentWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Gap.x5),
          child: child,
        ),
      ),
    );

    if (compact) {
      return Scaffold(
        body: SafeArea(child: content),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) => context.go(_destinations[i].path),
          destinations: [
            for (final d in _destinations)
              NavigationDestination(icon: Icon(d.icon), label: d.label),
          ],
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          Expanded(child: SafeArea(child: content)),
          _Rail(index: index),
        ],
      ),
    );
  }
}

class _Rail extends ConsumerWidget {
  const _Rail({required this.index});

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mode = ref.watch(themeModeProvider);
    final isDark = mode == ThemeMode.dark;

    return Container(
      width: 190,
      color: theme.colorScheme.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(vertical: Gap.x6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Gap.x5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Rohan Patel", style: theme.textTheme.titleMedium),
                Text(
                  "Flutter developer",
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const Spacer(),
          for (var i = 0; i < _destinations.length; i++)
            _RailItem(
              dest: _destinations[i],
              selected: i == index,
              onTap: () => context.go(_destinations[i].path),
            ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Gap.x4),
            child: OutlinedButton.icon(
              onPressed: () => ref.read(themeModeProvider.notifier).state =
                  isDark ? ThemeMode.light : ThemeMode.dark,
              icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, size: 18),
              label: Text(isDark ? "Light" : "Dark"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: Gap.x3),
                textStyle: theme.textTheme.labelMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  const _RailItem({required this.dest, required this.selected, required this.onTap});

  final _Dest dest;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = selected ? scheme.onPrimary : scheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Gap.x3, vertical: Gap.x1),
      child: Material(
        color: selected ? scheme.primary : Colors.transparent,
        borderRadius: Radii.pill,
        child: InkWell(
          borderRadius: Radii.pill,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Gap.x3, vertical: Gap.x3),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected
                        ? scheme.onPrimary.withValues(alpha: 0.22)
                        : scheme.onSurface.withValues(alpha: 0.07),
                  ),
                  child: Icon(dest.icon, size: 18, color: fg),
                ),
                Gap.w3,
                Text(
                  dest.label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: fg),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
