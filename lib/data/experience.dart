class Experience {
  final String period;
  final String role;
  final String org;
  final List<String> bullets;
  final bool isEducation;

  const Experience({
    required this.period,
    required this.role,
    required this.org,
    this.bullets = const [],
    this.isEducation = false,
  });
}

const List<Experience> timeline = [
  Experience(
    period: "Feb 2026 - now",
    role: "Flutter Developer",
    org: "Viz Digital Marketing LLC - Remote, US",
    bullets: [
      "Building an internal Scratch Ticket Management app tracking inventory, distribution, and redemption in one cross-platform interface.",
      "Added accounting and reconciliation reporting that replaced the team's manual spreadsheet workflow.",
      "Extended the product to the browser with Flutter Web, so mobile and web ship from one Dart codebase.",
    ],
  ),
  Experience(
    period: "Dec 2025 - Jan 2026",
    role: "Junior Flutter Developer",
    org: "FTNSS - Remote, US",
    bullets: [
      "Built a partner-facing web portal for gym membership signups with multi-step validated forms over REST APIs.",
      "Implemented role-based access control scoping screens, data, and actions per role.",
    ],
  ),
  Experience(
    period: "Jan 2024 - Dec 2025",
    role: "Master of Computer Science",
    org: "Cleveland State University - GPA 3.8 / 4.0",
    isEducation: true,
  ),
  Experience(
    period: "Jan 2025 - Dec 2025",
    role: "Graduate Teaching Assistant",
    org: "Cleveland State University - Cleveland, OH",
    bullets: [
      "Supported three sections across Data Structures and Algorithms, Data Science, and Computer Architecture.",
      "Graded assignments and labs with written feedback on algorithm design and code correctness.",
    ],
  ),
  Experience(
    period: "Jan 2023 - Nov 2023",
    role: "Flutter Application Developer",
    org: "Tech Elecon Pvt. Ltd. - Anand, India",
    bullets: [
      "Shipped three Flutter apps to Google Play, owning them from requirements through release, training, and support.",
      "Wrote a custom Flutter plugin in Kotlin bridging Honeywell hardware scanner events into Dart over a platform channel.",
      "Built a Fuel Management app pairing with TSC thermal printers over Bluetooth to print receipts at the point of dispensing.",
      "Integrated every app with enterprise REST APIs using GetX, extending backend endpoints where mobile demanded it.",
    ],
  ),
  Experience(
    period: "Jun 2022 - Jul 2022",
    role: "Mobile Application Developer Intern",
    org: "Alian Software - Anand, India",
    bullets: [
      "Implemented video optimization for a React Native school learning platform on constrained connections.",
    ],
  ),
  Experience(
    period: "Jul 2019 - May 2023",
    role: "B.E. Information Technology",
    org: "Gujarat Technological University - Anand, India",
    isEducation: true,
  ),
];

const List<String> skills = [
  "Dart", "Flutter", "Kotlin", "Java", "Python", "SQL",
  "GetX", "Riverpod", "Provider", "Firebase", "Supabase", "REST APIs",
  "Hive", "SQLite", "Platform channels", "Jetpack Compose", "React Native", "GitHub Actions",
];

class Certification {
  final String title;
  final String issuer;
  final String date;

  /// Coursera verification code, printed on the certificate. The public
  /// verify page is proof a recruiter can trust; a PDF we host is not.
  final String verifyId;

  const Certification({
    required this.title,
    required this.issuer,
    required this.date,
    required this.verifyId,
  });

  String get verifyUrl => "https://coursera.org/verify/$verifyId";
}

// Newest first. Source PDFs are in assets/certificates/, named by verifyId.
const List<Certification> certifications = [
  Certification(
    title: "Create the User Interface in Android Studio",
    issuer: "Meta",
    date: "Sep 2026",
    verifyId: "LYNPUR1WRD5Z",
  ),
  Certification(
    title: "Principles of UX/UI Design",
    issuer: "Meta",
    date: "Jun 2026",
    verifyId: "9TWR21W5303C",
  ),
  Certification(
    title: "Getting Started with Flutter & Dart",
    issuer: "Packt",
    date: "Jun 2026",
    verifyId: "KEKN8THI5J6R",
  ),
  Certification(
    title: "Programming Fundamentals in Kotlin",
    issuer: "Meta",
    date: "May 2026",
    verifyId: "PRT5I6HRFG2N",
  ),
  Certification(
    title: "Version Control",
    issuer: "Meta",
    date: "May 2026",
    verifyId: "NLSFHWMYYACK",
  ),
  Certification(
    title: "Introduction to Android Mobile Application Development",
    issuer: "Meta",
    date: "May 2026",
    verifyId: "DPNFOHEK2ZXY",
  ),
];
