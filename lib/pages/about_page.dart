import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

import "../app/tokens.dart";
import "../data/experience.dart";
import "../widgets/section_header.dart";
import "../widgets/timeline_view.dart";

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: "About",
            subtitle: "Two years of shipping Dart, a Master's in Computer Science, "
                "and a preference for the problems that do not have a package on "
                "pub.dev yet.",
            trailing: OutlinedButton.icon(
              onPressed: () => _downloadCv(context),
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text("Download CV"),
            ),
          ),

          const SectionHeader("Skills", note: "What I reach for"),
          Wrap(
            spacing: Gap.x3,
            runSpacing: Gap.x3,
            children: [for (final s in skills) _SkillTile(label: s)],
          ),

          const SectionHeader("Experience and education", note: "Newest first"),
          const TimelineView(entries: timeline),

          const SectionHeader("Certifications", note: "Verified on Coursera"),
          for (final c in certifications) _CertTile(cert: c),

          Gap.h8,
          Text(
            "Richmond, Virginia",
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          Gap.h8,
        ],
      ),
    );
  }
}

// The PDF lives in web/, not lib/assets/, so it's served as a static file
// at the site root rather than needing rootBundle + blob-URL plumbing.
//
// Deliberately navigates the current tab (no webOnlyWindowName: "_blank"):
// mobile Safari and Chrome silently block window.open() popups triggered
// from an async callback once the user-gesture context lapses across the
// await, so "_blank" worked on desktop but quietly failed on mobile.
Future<void> _downloadCv(BuildContext context) async {
  final uri = Uri.base.resolve("Rohan_Patel_Resume.pdf");
  final opened = await launchUrl(uri);
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Couldn't open the CV. Try again shortly.")),
    );
  }
}

/// Issuer and date sit in the subtitle rather than a tooltip so they are
/// readable on touch devices. Tapping opens Coursera's public verify page.
class _CertTile extends StatelessWidget {
  const _CertTile({required this.cert});

  final Certification cert;

  Future<void> _open(BuildContext context) async {
    final uri = Uri.parse(cert.verifyUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not open ${cert.verifyUrl}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: Gap.x3),
      shape: const RoundedRectangleBorder(borderRadius: Radii.allMd),
      leading: Icon(Icons.workspace_premium_outlined, color: scheme.primary),
      title: Text(cert.title),
      subtitle: Text("${cert.issuer} · ${cert.date}"),
      trailing: Icon(Icons.open_in_new_rounded, color: scheme.onSurfaceVariant),
      onTap: () => _open(context),
    );
  }
}

class _SkillTile extends StatefulWidget {
  const _SkillTile({required this.label});

  final String label;

  @override
  State<_SkillTile> createState() => _SkillTileState();
}

class _SkillTileState extends State<_SkillTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: Motion.fast,
        curve: Motion.ease,
        width: 108,
        height: 108,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(Gap.x2),
        decoration: BoxDecoration(
          borderRadius: Radii.allMd,
          border: Border.all(
            color: _hovered ? scheme.primary : scheme.outlineVariant,
            width: 2,
          ),
        ),
        child: Text(
          widget.label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: _hovered ? scheme.primary : scheme.onSurface,
              ),
        ),
      ),
    );
  }
}
