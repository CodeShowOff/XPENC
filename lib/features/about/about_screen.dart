import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/branding/app_info.dart';
import '../../core/branding/brand_mark.dart';

/// Who made this, which build you are looking at, and where the source lives.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      // Not a `SafeArea` — on some 3-button-nav devices its reported inset
      // doesn't clear the nav bar (GitHub #53, the same class of bug as
      // #14). Adding the inset explicitly is the pattern that actually held
      // up for that one.
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          20,
          8,
          20,
          40 + MediaQuery.of(context).padding.bottom,
        ),
        children: [
          const SizedBox(height: 12),
          const Center(child: BrandMark(size: 92)),
          const SizedBox(height: 20),
          const Center(child: BrandWordmark(fontSize: 34)),
          const SizedBox(height: 8),
          Center(
            child: Text(
              AppInfo.tagline,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Center(child: _VersionPill()),
          const SizedBox(height: 34),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                AppInfo.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ),
          ),

          _sectionLabel(context, 'Developer'),
          Card(
            child: Column(
              children: [
                _LinkTile(
                  icon: Icons.code_rounded,
                  label: 'Yash Patil',
                  value: 'Original Developer',
                  url: 'https://github.com/PATILYASHH/XPENC',
                ),
                Divider(height: 1, indent: 60, color: cs.outline),
                _LinkTile(
                  icon: Icons.code_rounded,
                  label: AppInfo.developer,
                  value: AppInfo.developerRole,
                  url: AppInfo.githubUrl,
                ),

                if (AppInfo.linkedinHandle.isNotEmpty) ...[
                  Divider(height: 1, indent: 60, color: cs.outline),
                  _LinkTile(
                    icon: Icons.work_outline_rounded,
                    label: 'LinkedIn',
                    value: '/in/${AppInfo.linkedinHandle}',
                    url: AppInfo.linkedinUrl,
                  ),
                ],
                if (AppInfo.sponsorUrl.isNotEmpty) ...[
                  Divider(height: 1, indent: 60, color: cs.outline),
                  _LinkTile(
                    icon: Icons.favorite_border_rounded,
                    label: 'Sponsor',
                    value: 'Buy the developer a coffee',
                    url: AppInfo.sponsorUrl,
                  ),
                ],
                if (AppInfo.personalEmail.isNotEmpty) ...[
                  Divider(height: 1, indent: 60, color: cs.outline),
                  _LinkTile(
                    icon: Icons.mail_outline_rounded,
                    label: 'Contact (personal)',
                    value: AppInfo.personalEmail,
                    url: 'mailto:${AppInfo.personalEmail}',
                  ),
                ],
              ],
            ),
          ),
          _sectionLabel(context, 'Project'),
          Card(
            child: Column(
              children: [
                if (AppInfo.websiteUrl.isNotEmpty) ...[
                  _LinkTile(
                    icon: Icons.language_rounded,
                    label: 'Website',
                    value: AppInfo.websiteUrl.replaceAll('https://', ''),
                    url: AppInfo.websiteUrl,
                  ),
                  Divider(height: 1, indent: 60, color: cs.outline),
                ],
                _LinkTile(
                  icon: Icons.code_rounded,
                  label: 'Original source code',
                  value: 'PATILYASHH/XPENC',
                  url: 'https://github.com/PATILYASHH/XPENC',
                ),
                Divider(height: 1, indent: 60, color: cs.outline),
                _LinkTile(
                  icon: Icons.code_rounded,
                  label: 'Source code',
                  value: 'CodeShowOff/XPENC',
                  url: AppInfo.repoUrl,
                ),
                Divider(height: 1, indent: 60, color: cs.outline),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.system_update_alt_rounded),
                  title: Text(
                    'Latest release',
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Changelogs & APKs',
                    style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(const SnackBar(content: Text('Coming soon')));
                  },
                ),
                Divider(height: 1, indent: 60, color: cs.outline),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.bug_report_outlined),
                  title: Text(
                    'Report a bug',
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Issues & feature requests',
                    style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(const SnackBar(content: Text('Coming soon')));
                  },
                ),
                Divider(height: 1, indent: 60, color: cs.outline),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.gavel_rounded),
                  title: Text(
                    'License',
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    AppInfo.licenseName,
                    style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: AppInfo.name,
                    applicationVersion: AppInfo.versionLabel,
                    applicationLegalese: AppInfo.copyright.isNotEmpty ? AppInfo.copyright : null,
                  ),
                ),
                if (AppInfo.feedbackEmail.isNotEmpty) ...[
                  Divider(height: 1, indent: 60, color: cs.outline),
                  _LinkTile(
                    icon: Icons.mail_outline_rounded,
                    label: 'Contact (project)',
                    value: AppInfo.feedbackEmail,
                    url: 'mailto:${AppInfo.feedbackEmail}?subject=XPENC%20feedback',
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
          if (AppInfo.copyright.isNotEmpty) ...[
            Center(
              child: Text(
                AppInfo.copyright,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 10),
      child: Text(
        text.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

/// Tap to copy — a bug report is useless without the exact build.
class _VersionPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () async {
        await Clipboard.setData(
          ClipboardData(text: '${AppInfo.name} ${AppInfo.versionLabel}'),
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Version copied')));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: cs.outline),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          'Version ${AppInfo.versionLabel}',
          style: theme.textTheme.labelMedium?.copyWith(
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Opens [url] in a browser. If no handler exists — a stripped device, a test
/// harness — the URL goes to the clipboard instead of the tap doing nothing.
class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.url,
  });

  final IconData icon;
  final String label;
  final String value;
  final String url;


  Future<void> _open(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    var opened = false;
    try {
      opened = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      opened = false;
    }
    if (opened) return;

    await Clipboard.setData(ClipboardData(text: url));
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Copied — $url')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(icon),
      title: Text(
        label,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        value,
        style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
      ),
      trailing: Icon(
        Icons.open_in_new_rounded,
        size: 18,
        color: cs.onSurfaceVariant,
      ),
      onTap: () => _open(context),
    );
  }
}
