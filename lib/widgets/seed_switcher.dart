import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../app/tokens.dart";
import "../state/settings.dart";

/// Four taps, four themes. The whole app rebuilds from whichever is active,
/// which is the point being demonstrated.
class SeedSwitcher extends ConsumerWidget {
  const SeedSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final active = ref.watch(seedColorProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (final option in seedOptions)
              Padding(
                padding: const EdgeInsets.only(right: Gap.x3),
                child: Semantics(
                  button: true,
                  selected: option.color == active,
                  label: "${option.name} theme",
                  child: InkWell(
                    borderRadius: Radii.allMd,
                    onTap: () =>
                        ref.read(seedColorProvider.notifier).state = option.color,
                    child: AnimatedContainer(
                      duration: Motion.fast,
                      curve: Motion.ease,
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: option.color,
                        borderRadius: Radii.allMd,
                        border: Border.all(
                          color: option.color == active
                              ? theme.colorScheme.onSurface
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        Gap.h3,
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Text(
            "Pick a seed colour. Everything rebuilds from it, the way "
            "ColorScheme.fromSeed does.",
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}
