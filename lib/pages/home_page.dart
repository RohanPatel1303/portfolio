import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "../app/tokens.dart";
import "../widgets/phone_frame.dart";
import "../widgets/seed_switcher.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = Breakpoints.isCompact(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Gap.x8),
        child: compact
            ? const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: PhoneFrame(width: 220)),
                  Gap.h7,
                  _Intro(),
                ],
              )
            : const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 6, child: _Intro()),
                  SizedBox(width: Gap.x7),
                  Expanded(flex: 4, child: Center(child: PhoneFrame())),
                ],
              ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: Gap.x4, vertical: Gap.x2),
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: Radii.pill,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xFF1B7A54)),
              ),
              Gap.w2,
              Text("Open to mobile roles",
                  style: theme.textTheme.labelMedium
                      ?.copyWith(color: scheme.onPrimaryContainer)),
            ],
          ),
        ),
        Gap.h4,
        Text(
          "I build Flutter apps that run real operations.",
          style: theme.textTheme.displaySmall,
        ),
        Gap.h5,
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Text.rich(
            TextSpan(
              style: theme.textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
              children: [
                const TextSpan(text: "Mobile developer in Richmond, Virginia. "),
                TextSpan(
                  text: "Three production apps on Google Play",
                  style: TextStyle(
                      color: scheme.onSurface, fontWeight: FontWeight.w600),
                ),
                const TextSpan(
                  text: " — approval workflows, HR, and delivery tracking — plus the "
                      "Kotlin platform-channel plugins that let them talk to barcode "
                      "scanners and thermal printers on the warehouse floor.",
                ),
              ],
            ),
          ),
        ),
        Gap.h6,
        Wrap(
          spacing: Gap.x3,
          runSpacing: Gap.x3,
          children: [
            FilledButton(
              onPressed: () => context.go("/work"),
              child: const Text("See the apps"),
            ),
            OutlinedButton(
              onPressed: () => context.go("/contact"),
              child: const Text("Get in touch"),
            ),
          ],
        ),
        Gap.h7,
        const SeedSwitcher(),
      ],
    );
  }
}
