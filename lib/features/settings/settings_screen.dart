import 'package:flutter/material.dart';

import '../../core/localization/app_strings.dart';
import '../shared_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.themeMode,
    required this.locale,
    required this.onThemeModeChanged,
    required this.onLocaleChanged,
  });

  final ThemeMode themeMode;
  final Locale locale;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionHeader(title: strings.t('settings')),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.dark_mode_rounded),
                title: Text(strings.t('theme')),
                subtitle: const Text('Clair, sombre ou systeme'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(value: ThemeMode.light, label: Text('Clair'), icon: Icon(Icons.light_mode_rounded)),
                    ButtonSegment(value: ThemeMode.dark, label: Text('Sombre'), icon: Icon(Icons.dark_mode_rounded)),
                    ButtonSegment(value: ThemeMode.system, label: Text('Auto'), icon: Icon(Icons.brightness_auto_rounded)),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (value) => onThemeModeChanged(value.first),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.language_rounded),
                title: Text(strings.t('language')),
                subtitle: const Text('Francais, English, Arabic, Espanol'),
              ),
              _LanguageTile(
                label: 'Francais',
                value: const Locale('fr'),
                selected: locale.languageCode == 'fr',
                onSelected: onLocaleChanged,
              ),
              _LanguageTile(
                label: 'English',
                value: const Locale('en'),
                selected: locale.languageCode == 'en',
                onSelected: onLocaleChanged,
              ),
              _LanguageTile(
                label: 'Arabic',
                value: const Locale('ar'),
                selected: locale.languageCode == 'ar',
                onSelected: onLocaleChanged,
              ),
              _LanguageTile(
                label: 'Espanol',
                value: const Locale('es'),
                selected: locale.languageCode == 'es',
                onSelected: onLocaleChanged,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: Icon(Icons.apartment_rounded),
            title: Text('Multi-tenant SaaS'),
            subtitle: Text('Isolation entreprises, ministeres, ONG, universites, banques et hopitaux.'),
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: Icon(Icons.security_rounded),
            title: Text('Securite entreprise'),
            subtitle: Text('MFA, RBAC, SSO, OAuth2, OpenID Connect, audit logs, TLS 1.3 et chiffrement.'),
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: Icon(Icons.sync_rounded),
            title: Text('Mode offline Afrique'),
            subtitle: Text('SQLite local, synchronisation automatique, SMS fallback et USSD fallback.'),
          ),
        ),
      ],
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.label,
    required this.value,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final Locale value;
  final bool selected;
  final ValueChanged<Locale> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onSelected(value),
      title: Text(label),
      trailing: selected ? const Icon(Icons.check_rounded) : null,
    );
  }
}
