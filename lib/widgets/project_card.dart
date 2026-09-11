import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

import "../app/tokens.dart";
import "../data/project.dart";

/// Title and stack are always visible — never hidden behind a hover state,
/// because hover does not exist on the phones most visitors arrive on.
class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project});

  final Project project;

  Future<void> _open(BuildContext context) async {
    final url = project.url;
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Internal project — happy to walk through it.")),
      );
      return;
    }
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not open $url")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: Radii.allLg,
        onTap: () => _open(context),
        child: Padding(
          padding: const EdgeInsets.all(Gap.x4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Thumb(tint: project.tint),
              Gap.w4,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(project.name, style: theme.textTheme.titleLarge),
                        ),
                        if (project.url != null)
                          Icon(Icons.north_east_rounded,
                              size: 16, color: theme.colorScheme.onSurfaceVariant),
                      ],
                    ),
                    const SizedBox(height: Gap.x2),
                    Text(
                      project.blurb,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: Gap.x3),
                    Wrap(
                      spacing: Gap.x2,
                      runSpacing: Gap.x2,
                      children: [
                        for (final c in project.chips)
                          Chip(
                            label: Text(c),
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.tint});

  final Color tint;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 56,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: scheme.onSurface, borderRadius: Radii.allMd),
      child: AspectRatio(
        aspectRatio: 9 / 19.2,
        child: ClipRRect(
          borderRadius: Radii.allSm,
          child: Column(
            children: [
              Expanded(flex: 32, child: Container(color: tint)),
              Expanded(
                flex: 68,
                child: Container(
                  color: scheme.surface,
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final w in const [1.0, 0.72, 0.86]) ...[
                        FractionallySizedBox(
                          widthFactor: w,
                          child: Container(
                            height: 5,
                            decoration: BoxDecoration(
                              color: tint.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
