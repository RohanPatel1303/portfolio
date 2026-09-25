import "package:flutter/material.dart";

enum ProjectTag {
  flutter("Flutter"),
  nativeIntegration("Native integration"),
  reactNative("React Native");

  const ProjectTag(this.label);
  final String label;
}

class Project {
  final String name;
  final String blurb;
  final List<String> chips;
  final Set<ProjectTag> tags;
  final Color tint;

  /// Null for work that is not publicly linkable.
  final String? url;

  /// Asset path of a phone screenshot. Null falls back to a tinted mockup.
  final String? screenshot;

  const Project({
    required this.name,
    required this.blurb,
    required this.chips,
    required this.tags,
    required this.tint,
    this.url,
    this.screenshot,
  });
}

/// One list drives the whole work grid — add an entry here and the UI follows.
const List<Project> projects = [
  Project(
    name: "Kaizen",
    blurb:
        "Continuous-improvement app for a manufacturing plant. Role-based access for "
        "Team Leader, Manager, and Employee across submissions and One Point Lessons, "
        "with structured data entry and multi-image capture.",
    chips: ["Flutter", "GetX", "REST"],
    tags: {ProjectTag.flutter},
    tint: Color(0xFF00C2A8),
    url: "https://play.google.com/store/apps/details?id=com.techelecon.kaizen",
    screenshot: "assets/screenshots/kaizen.jpg",
  ),
  Project(
    name: "Tech HRMS",
    blurb:
        "Attendance calendar reconciling API records against holiday schedules, plus "
        "leave requests routed through multi-level approval. I also redesigned the "
        "interface for consistency across modules.",
    chips: ["Flutter", "GetX", "UI redesign"],
    tags: {ProjectTag.flutter},
    tint: Color(0xFFFF3D7F),
    url: "https://play.google.com/store/apps/details?id=com.techelecon.tech_hrms",
    screenshot: "assets/screenshots/tech_hrms.jpg",
  ),
  Project(
    name: "Opal ePOD",
    blurb:
        "Delivery and electronic proof-of-delivery tracking, rebuilt from an existing "
        "React Native codebase into Flutter and shipped to Google Play without losing "
        "a feature.",
    chips: ["Flutter", "Migration", "GetX"],
    tags: {ProjectTag.flutter, ProjectTag.reactNative},
    tint: Color(0xFF6C4CFF),
    url: "https://play.google.com/store/apps/details?id=com.opalepod.opalepod",
    screenshot: "assets/screenshots/opal_epod.jpg",
  ),
  Project(
    name: "Scanner plugin",
    blurb:
        "A custom Flutter plugin in Kotlin bridging Honeywell hardware barcode events "
        "into Dart over a platform channel, so badge scans work on ruggedized devices "
        "with no Dart package available.",
    chips: ["Kotlin", "Platform channels"],
    tags: {ProjectTag.flutter, ProjectTag.nativeIntegration},
    tint: Color(0xFFFFC53D),
  ),
  Project(
    name: "Fuel Management",
    blurb:
        "Bluetooth pairing with TSC thermal printers to generate and print transaction "
        "receipts on-device at the point of dispensing.",
    chips: ["Flutter", "Bluetooth", "Thermal print"],
    tags: {ProjectTag.flutter, ProjectTag.nativeIntegration},
    tint: Color(0xFF00C2A8),
  ),
  Project(
    name: "Noise Level Monitor",
    blurb:
        "Samples ambient audio through the microphone and fires a push notification "
        "when sound crosses a configurable decibel threshold, monitoring continuously "
        "in the background.",
    chips: ["React Native", "Sensors"],
    tags: {ProjectTag.reactNative},
    tint: Color(0xFF6C4CFF),
  ),
];
