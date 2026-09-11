# Rohan Patel — portfolio

Flutter portfolio site. Four routes behind a persistent nav shell, themed
entirely from a single seed colour.

## Getting it running

This repo is `lib/` plus `pubspec.yaml` only — no platform folders, because
those are generated. Create a project shell first, then drop these in:

```bash
flutter create rohan_portfolio
cd rohan_portfolio

# replace the generated lib/ and pubspec.yaml with the ones from this archive
rm -rf lib pubspec.yaml
cp -r /path/to/download/lib .
cp /path/to/download/pubspec.yaml .

flutter pub get
flutter run -d chrome
```

Requires **Flutter 3.27 or newer** (Dart 3.6+). `Color.withValues()` replaced
`withOpacity()` in that release; on an older SDK swap those calls back.

If the analyzer complains about `cardTheme` expecting `CardThemeData`, you're
on a newer Flutter than this was written against — change `CardTheme(` to
`CardThemeData(` in `lib/app/theme.dart`. One line.

## Layout

```
lib/
├── main.dart                 MaterialApp.router, watches seed + brightness
├── app/
│   ├── theme.dart            ColorScheme.fromSeed + TextTheme + component themes
│   ├── tokens.dart           Gap, Radii, Motion, Breakpoints
│   └── router.dart           GoRouter, ShellRoute, cross-fade transitions
├── state/
│   └── settings.dart         seedColorProvider, themeModeProvider
├── data/
│   ├── project.dart          Project model + the projects list
│   └── experience.dart       Experience model, timeline, skills, certifications
├── widgets/
│   ├── nav_shell.dart        rail ≥900px, NavigationBar below
│   ├── seed_switcher.dart    the four-colour theme switcher
│   ├── phone_frame.dart      the Kaizen mock in the hero
│   ├── project_card.dart     title + stack always visible
│   ├── timeline_view.dart    work and education on one rail
│   └── section_header.dart   SectionHeader + PageHeader
└── pages/
    ├── home_page.dart
    ├── about_page.dart
    ├── work_page.dart        filter chips + empty state
    └── contact_page.dart     validated form
```

## Adding a project

Everything on the Work page comes from one list. Add an entry to
`projects` in `lib/data/project.dart` and the grid, the filters, and the
chips all follow:

```dart
Project(
  name: "New app",
  blurb: "What it does and what made it hard.",
  chips: ["Flutter", "Riverpod"],
  tags: {ProjectTag.flutter},
  tint: Color(0xFF00C2A8),
  url: "https://play.google.com/...",   // omit for internal work
),
```

## Still to wire up

1. **Contact form has no backend.** `_submit()` in `contact_page.dart` fakes a
   700ms delay where the POST belongs. Formspree or your own endpoint both work.
2. **Download CV** shows a snackbar. Put the PDF in `assets/`, declare it in
   `pubspec.yaml`, and open it with `url_launcher`.
3. **Screenshots.** Project thumbnails are flat colour placeholders. Play Store
   assets for Kaizen, Tech HRMS, and Opal ePOD would replace `_Thumb`.

## A note on web

Flutter Web defaults to CanvasKit, which paints to a canvas — your text is not
in the DOM and search engines index close to nothing. If recruiters finding you
by name matters more than the site itself being a Flutter demo, either build
with `--web-renderer html` (weaker, but text lands in the DOM) or keep the HTML
version as the public site.

```bash
flutter build web --release
```
# portfolio
