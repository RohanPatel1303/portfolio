import "package:flutter/material.dart";

import "../app/tokens.dart";
import "../data/project.dart";
import "../widgets/project_card.dart";
import "../widgets/section_header.dart";

class WorkPage extends StatefulWidget {
  const WorkPage({super.key});

  @override
  State<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  ProjectTag? _filter;

  List<Project> get _visible => _filter == null
      ? projects
      : projects.where((p) => p.tags.contains(_filter)).toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compact = Breakpoints.isCompact(context);
    final visible = _visible;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: "Work",
            subtitle: "Three apps live on Google Play, plus internal tools and one "
                "built for myself. Every one had a constraint that made the obvious "
                "approach wrong.",
          ),

          Container(
            padding: const EdgeInsets.all(Gap.x5),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: Radii.allLg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Enterprise apps, not demos", style: theme.textTheme.titleLarge),
                Gap.h3,
                Text(
                  "These run on factory floors and delivery routes, on ruggedized "
                  "handsets with bad signal and gloved thumbs. That shapes everything: "
                  "offline-first storage, generous touch targets, and hardware that has "
                  "to work the first time because there is no second attempt at the "
                  "loading dock.",
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),

          const SectionHeader("Projects", note: "Filter by technology"),

          Wrap(
            spacing: Gap.x2,
            runSpacing: Gap.x2,
            children: [
              _FilterChip(
                label: "All",
                selected: _filter == null,
                onSelected: () => setState(() => _filter = null),
              ),
              for (final tag in ProjectTag.values)
                _FilterChip(
                  label: tag.label,
                  selected: _filter == tag,
                  onSelected: () => setState(() => _filter = tag),
                ),
            ],
          ),
          Gap.h5,

          if (visible.isEmpty)
            _Empty(onClear: () => setState(() => _filter = null))
          else if (compact)
            Column(
              children: [
                for (final p in visible)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Gap.x4),
                    child: ProjectCard(project: p),
                  ),
              ],
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visible.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: Gap.x4,
                crossAxisSpacing: Gap.x4,
                mainAxisExtent: 300,
              ),
              itemBuilder: (context, i) => ProjectCard(project: visible[i]),
            ),

          Gap.h8,
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      showCheckmark: false,
      backgroundColor: Colors.transparent,
      selectedColor: scheme.primary,
      labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
          ),
      side: BorderSide(
        color: selected ? scheme.primary : scheme.outlineVariant,
        width: 1.5,
      ),
      shape: const RoundedRectangleBorder(borderRadius: Radii.pill),
    );
  }
}

/// An empty screen is an invitation to act, not an apology.
class _Empty extends StatelessWidget {
  const _Empty({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: Gap.x8, horizontal: Gap.x5),
      decoration: BoxDecoration(
        borderRadius: Radii.allLg,
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 1.5),
      ),
      child: Column(
        children: [
          Text("Nothing matches that filter yet",
              style: theme.textTheme.titleMedium),
          Gap.h3,
          OutlinedButton(onPressed: onClear, child: const Text("Show everything")),
        ],
      ),
    );
  }
}
