# CLAUDE.md

Portfolio site for Rohan Patel, Flutter developer (Richmond, VA). Four routes
behind a persistent nav shell, themed entirely from one seed colour.

## Commands

```bash
flutter pub get
flutter analyze
flutter run -d chrome --profile   # NEVER benchmark in debug mode
flutter build web --release
flutter test
```

## Stack

Flutter 3.27+ / Dart 3.6+. `flutter_riverpod`, `go_router`, `google_fonts`,
`url_launcher`. No other dependencies without asking.

## Architecture

```
lib/
├── main.dart              MaterialApp.router; watches seed + brightness
├── app/
│   ├── theme.dart         ColorScheme.fromSeed, TextTheme, component themes
│   ├── tokens.dart        Gap, Radii, Motion, Breakpoints
│   └── router.dart        GoRouter + ShellRoute + cross-fade
├── state/settings.dart    seedColorProvider, themeModeProvider
├── data/                  Project + Experience models and their lists
├── widgets/               nav_shell, seed_switcher, phone_frame,
│                          project_card, timeline_view, section_header
└── pages/                 home, about, work, contact
```

## Rules that are easy to break

**1. Never hardcode a colour, size, or duration.**
Colours come from `Theme.of(context).colorScheme`. Spacing comes from `Gap`
(4pt scale). Radii from `Radii`. Durations from `Motion`. If you need a value
that isn't in `tokens.dart`, add it there rather than inlining it.

**2. Never animate a theme colour at the widget level.**
`MaterialApp` already lerps the entire `ColorScheme` on theme change via
`themeAnimationDuration`. Wrapping the same colour in an `AnimatedContainer`
stacks two eases on one value and looks broken. `AnimatedContainer` is only for
colours that are *not* from the scheme, or for user-triggered state like hover.

**3. `buildTheme` results are memoised in `_themeCache`.**
`ColorScheme.fromSeed` runs the HCT tonal-palette algorithm and is far too
expensive to call per rebuild. `_baseTextTheme` is a top-level `final` for the
same reason — each entry resolves a Google Fonts style. Do not move either of
these back inside a build method.

**4. Content lives in `lib/data/`, never in a widget.**
`projects` and `timeline` are plain const lists. Adding a project means adding
a `Project` to that list; the grid, the filter chips, and the tag chips all
follow. Do not hardcode content into a page.

**5. Nothing important may be hover-only.**
Titles, labels, and stack chips are visible at rest. Most visitors arrive on a
phone where hover does not exist. Hover may add emphasis, never information.

**6. Every async surface needs loading, empty, and error states.**
Prefer skeletons over spinners when the shape of the incoming data is known.

**7. Responsive breakpoints** are Material window size classes:
600 / 900 / 1240. `Breakpoints.isCompact(context)` is the < 900 check that
switches the nav rail to a `NavigationBar`.

## Known gaps

- **Contact form posts to Netlify Forms.** `_submit()` in `contact_page.dart`
  POSTs to `/` with `form-name: contact`; the matching hidden `<form>` lives in
  `web/index.html` because Netlify only detects forms in static HTML at build
  time. Submissions only work on an actual Netlify deploy — set the
  notification address in that site's Forms settings. Locally or on any other
  host the POST 404s and the form shows the error snackbar.
- **Project thumbnails**: Kaizen, Tech HRMS, and Opal ePOD show Play Store
  screenshots from `assets/screenshots/`. Scanner plugin, Fuel Management,
  and Noise Level Monitor have no public app and still use the tinted
  mockup; set `Project.screenshot` to add one.
- **Fonts load over HTTP** via `google_fonts`, which causes a reflow on first
  paint. Bundling the three families in `assets/fonts/` would fix it.
- **No tests exist yet.**
- **This code has never been compile-verified.** It was written without a
  Flutter SDK available. Expect analyzer errors on first run. A known one:
  `CardTheme` became `CardThemeData` in a recent release.

## Web caveat

Flutter Web defaults to CanvasKit, which paints to a canvas — text is not in
the DOM and search engines index almost nothing. That is a real cost for a
portfolio recruiters find by name. Do not silently change the renderer; raise
it if it becomes relevant.

## Style

Comments explain *why*, not *what*. Prefer a short comment on a non-obvious
decision over none. Keep widgets small and private (`_Foo`) unless they are
reused across pages.