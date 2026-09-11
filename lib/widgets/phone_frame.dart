import "dart:async";

import "package:flutter/material.dart";

import "../app/tokens.dart";

/// A mock phone, themed from the active seed colour, that auto-pages between
/// the Kaizen review queue and a short "about me" screen.
class PhoneFrame extends StatefulWidget {
  const PhoneFrame({super.key, this.width = 260});

  final double width;

  @override
  State<PhoneFrame> createState() => _PhoneFrameState();
}

class _PhoneFrameState extends State<PhoneFrame> {
  static const _pageCount = 2;

  final PageController _controller = PageController();
  Timer? _timer;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Motion.phoneAutoAdvance, (_) => _advance());
  }

  void _advance() {
    if (!_controller.hasClients) return;
    final next = (_page + 1) % _pageCount;
    _controller.animateToPage(next, duration: Motion.slow, curve: Motion.enter);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    // A 44px blur over the whole frame is the most expensive paint on the home
    // page. Isolated so that hover on the seed switcher beside it, and the
    // route fade above it, do not force the shadow to re-rasterise.
    return RepaintBoundary(
      child: Container(
        width: widget.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: scheme.onSurface,
          borderRadius: BorderRadius.circular(widget.width * 0.16),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.35),
              blurRadius: 44,
              offset: const Offset(0, 22),
            ),
          ],
        ),
        child: AspectRatio(
          aspectRatio: 9 / 19.2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.width * 0.13),
            child: Column(
              children: [
                _AppBar(scheme: scheme, text: text),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    // A visitor can swipe through manually; this keeps the
                    // dot indicator and the auto-advance timer's notion of
                    // "current page" in sync when they do.
                    onNotification: (n) {
                      final page = _controller.page?.round();
                      if (page != null && page != _page) {
                        setState(() => _page = page);
                      }
                      return false;
                    },
                    child: PageView(
                      controller: _controller,
                      children: [
                        _QueuePage(scheme: scheme),
                        _AboutPage(scheme: scheme, text: text),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: scheme.surface,
                  padding: const EdgeInsets.fromLTRB(Gap.x5, Gap.x3, Gap.x5, Gap.x4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < _pageCount; i++) ...[
                        if (i != 0) Gap.w2,
                        _Pip(active: i == _page, scheme: scheme),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({required this.scheme, required this.text});

  final ColorScheme scheme;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    // Plain Container, not AnimatedContainer: scheme.primary is already being
    // lerped by MaterialApp on every theme change. Animating it again here
    // stacked a second ease on one value, which is what made the seed switch
    // look like it was dragging.
    return Container(
      color: scheme.primary,
      padding: const EdgeInsets.fromLTRB(Gap.x4, Gap.x3, Gap.x4, Gap.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("9:41",
                  style: text.labelSmall
                      ?.copyWith(color: scheme.onPrimary, fontWeight: FontWeight.w600)),
              Icon(Icons.more_horiz_rounded, size: 14, color: scheme.onPrimary),
            ],
          ),
          const SizedBox(height: Gap.x2),
          Text("MY APP",
              style: text.titleLarge?.copyWith(color: scheme.onPrimary, fontSize: 20)),
          Text("4 submissions awaiting review",
              style: text.bodySmall?.copyWith(
                  color: scheme.onPrimary.withValues(alpha: 0.85), fontSize: 11)),
        ],
      ),
    );
  }
}

class _QueuePage extends StatelessWidget {
  const _QueuePage({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: scheme.primaryContainer,
      padding: const EdgeInsets.fromLTRB(Gap.x3, Gap.x3, Gap.x3, 0),
      child: const Column(
        children: [
          _Row(title: "Line 3 changeover", sub: "Team Leader - 2 photos"),
          SizedBox(height: Gap.x2),
          _Row(title: "One Point Lesson", sub: "Draft - Press shop"),
          SizedBox(height: Gap.x2),
          _Row(title: "Guard rail proposal", sub: "Approved by Manager"),
        ],
      ),
    );
  }
}

class _AboutPage extends StatelessWidget {
  const _AboutPage({required this.scheme, required this.text});

  final ColorScheme scheme;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: scheme.surface,
      padding: const EdgeInsets.all(Gap.x4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: scheme.primary, width: 2),
            ),
            padding: const EdgeInsets.all(3),
            child: ClipOval(
              child: Image.asset("assets/rohan.png", fit: BoxFit.cover),
            ),
          ),
          Gap.h4,
          Text("Rohan Patel",
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          Gap.h2,
          Text(
            "Flutter developer in Richmond, VA — building mobile apps that "
            "run real operations.",
            textAlign: TextAlign.center,
            style: text.bodySmall
                ?.copyWith(color: scheme.onSurfaceVariant, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.title, required this.sub});

  final String title;
  final String sub;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(Gap.x3),
      decoration: BoxDecoration(color: scheme.surface, borderRadius: Radii.allMd),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(color: scheme.primary, borderRadius: Radii.allSm),
          ),
          Gap.w3,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall?.copyWith(
                        fontSize: 11.5, fontWeight: FontWeight.w600, height: 1.2)),
                Text(sub,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall?.copyWith(
                        fontSize: 10, color: scheme.onSurfaceVariant, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pip extends StatelessWidget {
  const _Pip({required this.active, required this.scheme});

  final bool active;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) => Container(
        width: active ? 16 : 6,
        height: 6,
        decoration: BoxDecoration(
          color: active ? scheme.primary : scheme.onSurface.withValues(alpha: 0.16),
          borderRadius: Radii.allSm,
        ),
      );
}
