import "package:flutter/material.dart";

import "../app/tokens.dart";
import "../data/experience.dart";

/// Work and study on one rail, newest first. Education entries get a
/// neutral marker so the two kinds stay distinguishable at a glance.
class TimelineView extends StatelessWidget {
  const TimelineView({super.key, required this.entries});

  final List<Experience> entries;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Positioned(
          left: 7,
          top: 8,
          bottom: 8,
          child: Container(width: 2, color: scheme.outlineVariant),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [for (final e in entries) _Entry(entry: e)],
        ),
      ],
    );
  }
}

class _Entry extends StatelessWidget {
  const _Entry({required this.entry});

  final Experience entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: Gap.x6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: entry.isEducation ? scheme.onSurface : scheme.primary,
                border: Border.all(color: scheme.surface, width: 3),
              ),
            ),
          ),
          Gap.w4,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.period,
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: scheme.onSurfaceVariant)),
                const SizedBox(height: Gap.x1),
                Text(entry.role, style: theme.textTheme.titleLarge?.copyWith(fontSize: 19)),
                Text(entry.org,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: scheme.onSurfaceVariant)),
                if (entry.bullets.isNotEmpty) ...[
                  const SizedBox(height: Gap.x3),
                  for (final b in entry.bullets)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Gap.x2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8, right: Gap.x3),
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: scheme.primary),
                            ),
                          ),
                          Expanded(
                            child: Text(b,
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(color: scheme.onSurfaceVariant)),
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
