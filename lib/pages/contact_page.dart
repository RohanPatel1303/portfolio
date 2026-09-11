import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:url_launcher/url_launcher.dart";

import "../app/tokens.dart";
import "../widgets/section_header.dart";

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _message = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _message.dispose();
    super.dispose();
  }

  static final _emailRe = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]{2,}$");

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Check the highlighted fields.")),
      );
      return;
    }

    setState(() => _sending = true);

    // Netlify's form relay: it only registers forms it finds in the static
    // HTML at build time, so a matching hidden <form name="contact"> lives in
    // web/index.html. Posting here with the same name and field values routes
    // through that registration to whatever address the Netlify dashboard's
    // Forms notifications are set to.
    try {
      await http.post(
        Uri.parse("/"),
        body: {
          "form-name": "contact",
          "name": _name.text.trim(),
          "email": _email.text.trim(),
          "phone": _phone.text.trim(),
          "message": _message.text.trim(),
        },
      );
      if (!mounted) return;
      _formKey.currentState!.reset();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Message sent. I will reply within a day or two.")),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not send — please try again or email me directly."),
        ),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not open $url")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final compact = Breakpoints.isCompact(context);

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Detail(
          icon: Icons.drafts_rounded,
          label: "Email",
          value: "developerrohan01@gmail.com",
          onTap: () => _launch("mailto:developerrohan01@gmail.com"),
        ),
        _Detail(
          icon: Icons.call_rounded,
          label: "Phone",
          value: "+1 (216) 456-5992",
          onTap: () => _launch("tel:+12164565992"),
        ),
        const _Detail(
          icon: Icons.place_rounded,
          label: "Location",
          value: "Richmond, Virginia",
        ),
        _Detail(
          icon: Icons.code_rounded,
          label: "GitHub",
          value: "RohanPatel1303",
          onTap: () => _launch("https://github.com/RohanPatel1303"),
        ),
        _Detail(
          icon: Icons.business_center_rounded,
          label: "LinkedIn",
          value: "rohan-flutter-developer",
          onTap: () =>
              _launch("https://www.linkedin.com/in/rohan-flutter-developer"),
        ),
      ],
    );

    final form = Container(
      padding: const EdgeInsets.all(Gap.x5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: Radii.allLg,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _name,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: "Your name",
                hintText: "Jane Doe",
              ),
              validator: (v) =>
                  (v ?? "").trim().length < 2 ? "Please enter your name" : null,
            ),
            Gap.h4,
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "jane@company.com",
              ),
              validator: (v) => _emailRe.hasMatch((v ?? "").trim())
                  ? null
                  : "Enter a complete email address",
            ),
            Gap.h4,
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: "Phone (optional)",
                hintText: "+1 555 123 4567",
              ),
              // E.164 allows 7 to 15 digits. Never hardcode 10.
              validator: (v) {
                final digits = (v ?? "").replaceAll(RegExp(r"\D"), "");
                if (digits.isEmpty) return null;
                return (digits.length < 7 || digits.length > 15)
                    ? "Enter 7 to 15 digits, or leave it blank"
                    : null;
              },
            ),
            Gap.h4,
            TextFormField(
              controller: _message,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Message",
                hintText: "What are you building?",
                alignLabelWithHint: true,
              ),
              validator: (v) => (v ?? "").trim().length < 10
                  ? "A sentence or two is plenty"
                  : null,
            ),
            Gap.h5,
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _sending ? null : _submit,
                child: _sending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Send message"),
              ),
            ),
          ],
        ),
      ),
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: "Get in touch",
            subtitle: "Open to Mobile Application Developer and Software Engineer "
                "(Mobile) roles. Based in Richmond, Virginia and comfortable "
                "working remote.",
          ),
          if (compact) ...[
            details,
            Gap.h6,
            form,
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: details),
                const SizedBox(width: Gap.x7),
                Expanded(flex: 5, child: form),
              ],
            ),
          Gap.h8,
        ],
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: Gap.x4),
      child: InkWell(
        borderRadius: Radii.allMd,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Gap.x2),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.primaryContainer,
                ),
                child: Icon(icon, size: 19, color: scheme.onPrimaryContainer),
              ),
              Gap.w4,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant, fontSize: 12.5)),
                  Text(value, style: theme.textTheme.titleSmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
