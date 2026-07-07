import 'package:flutter/material.dart';

import 'core/localization/app_strings.dart';
import 'features/ai/ai_screen.dart';
import 'features/missions/missions_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/attendance/attendance_screen.dart';
import 'features/payroll/payroll_screen.dart';
import 'features/employees/employees_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/performance/performance_screen.dart';
import 'features/sites/sites_screen.dart';

class GeoTimeShell extends StatefulWidget {
  const GeoTimeShell({
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
  State<GeoTimeShell> createState() => _GeoTimeShellState();
}

class _GeoTimeShellState extends State<GeoTimeShell> {
  int _index = 0;
  String _statusMessage = 'Plateforme prete';
  int _clickCount = 0;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final destinations = [
      _Destination(strings.t('dashboard'), Icons.dashboard_rounded),
      _Destination(strings.t('products'), Icons.badge_rounded),
      _Destination(strings.t('stock'), Icons.fingerprint_rounded),
      _Destination(strings.t('warehouses'), Icons.business_rounded),
      _Destination(strings.t('pos'), Icons.payments_rounded),
      _Destination(strings.t('customers'), Icons.route_rounded),
      _Destination(strings.t('suppliers'), Icons.query_stats_rounded),
      _Destination(strings.t('ai'), Icons.psychology_rounded),
      _Destination(strings.t('settings'), Icons.settings_rounded),
    ];
    final pages = [
      const DashboardScreen(),
      const EmployeesScreen(),
      const AttendanceScreen(),
      const SitesScreen(),
      const PayrollScreen(),
      const MissionsScreen(),
      const PerformanceScreen(),
      const AiScreen(),
      SettingsScreen(
        themeMode: widget.themeMode,
        locale: widget.locale,
        onThemeModeChanged: widget.onThemeModeChanged,
        onLocaleChanged: widget.onLocaleChanged,
      ),
    ];
    final wide = MediaQuery.sizeOf(context).width >= 840;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GeoTime Enterprise HR Suite'),
        actions: [
          IconButton(
            tooltip: strings.t('search'),
            onPressed: () => _showSearchPanel(context),
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            tooltip: strings.t('alerts'),
            onPressed: () => _showAlertsPanel(context),
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      drawer: wide
          ? null
          : NavigationDrawer(
              selectedIndex: _index,
              onDestinationSelected: (value) {
                Navigator.of(context).pop();
                _selectPage(value);
              },
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 20, 16, 12),
                  child: Text('GeoTime Enterprise HR Suite'),
                ),
                for (final destination in destinations)
                  NavigationDrawerDestination(
                    icon: Icon(destination.icon),
                    label: Text(destination.label),
                  ),
              ],
            ),
      body: Row(
        children: [
          if (wide)
            NavigationRail(
              extended: MediaQuery.sizeOf(context).width >= 1100,
              selectedIndex: _index,
              onDestinationSelected: (value) => _selectPage(value),
              destinations: [
                for (final destination in destinations)
                  NavigationRailDestination(
                    icon: Icon(destination.icon),
                    label: Text(destination.label),
                  ),
              ],
            ),
          Expanded(
            child: Column(
              children: [
                Expanded(child: pages[_index]),
                _ActionStatusBar(
                  message: _statusMessage,
                  clickCount: _clickCount,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: _index > 4 ? 4 : _index,
              onDestinationSelected: (value) => _selectPage(value),
              destinations: destinations.take(5).map((item) {
                return NavigationDestination(icon: Icon(item.icon), label: item.label);
              }).toList(),
            ),
      floatingActionButton: wide || _index <= 4
          ? FloatingActionButton.extended(
              onPressed: () => _showQuickAction(context),
              icon: const Icon(Icons.add_rounded),
              label: Text(_fabLabel(context)),
            )
          : null,
    );
  }

  String _fabLabel(BuildContext context) {
    final strings = AppStrings.of(context);
    return switch (_index) {
      1 => strings.t('products'),
      2 => 'Pointer',
      3 => 'Site',
      4 => 'Paie',
      _ => 'Action',
    };
  }

  void _showQuickAction(BuildContext context) {
    final config = _quickActionConfig(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            MediaQuery.viewInsetsOf(context).bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(config.icon),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      config.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              for (final field in config.fields) ...[
                TextField(
                  keyboardType: field.keyboardType,
                  decoration: InputDecoration(
                    labelText: field.label,
                    prefixIcon: Icon(field.icon),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  _notify('${config.title} enregistre');
                },
                icon: const Icon(Icons.check_rounded),
                label: const Text('Valider'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSearchPanel(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            MediaQuery.viewInsetsOf(context).bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Recherche globale',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Employe, site, mission, paie, alerte...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onSubmitted: (value) {
                  Navigator.of(context).pop();
                  _notify('Recherche: $value');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _notify(String message) {
    setState(() {
      _clickCount++;
      _statusMessage = message;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _selectPage(int value) {
    setState(() {
      _index = value;
      _clickCount++;
      _statusMessage = 'Module ouvert: ${_pageName(value)}';
    });
  }

  String _pageName(int value) {
    return switch (value) {
      0 => 'Tableau',
      1 => 'Employes',
      2 => 'Pointage',
      3 => 'Sites',
      4 => 'Paie',
      5 => 'Missions',
      6 => 'Performance',
      7 => 'IA RH',
      8 => 'Reglages',
      _ => 'Inconnu',
    };
  }

  void _showAlertsPanel(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.security_rounded),
                title: const Text('Pointage suspect'),
                subtitle: const Text('Fake GPS detecte sur un appareil Android.'),
                trailing: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Verifier'),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.schedule_rounded),
                title: const Text('Retard recurrent'),
                subtitle: const Text('5 retards sur 10 jours dans IT & securite.'),
                trailing: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Traiter'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _QuickActionConfig _quickActionConfig(BuildContext context) {
    final strings = AppStrings.of(context);
    return switch (_index) {
      1 => const _QuickActionConfig(
          title: 'Nouvel employe',
          icon: Icons.person_add_rounded,
          fields: [
            _QuickActionField('Nom complet', Icons.person_rounded),
            _QuickActionField('Matricule', Icons.badge_rounded),
            _QuickActionField('Salaire de base', Icons.payments_rounded,
                keyboardType: TextInputType.number),
          ],
        ),
      2 => const _QuickActionConfig(
          title: 'Pointage manuel',
          icon: Icons.fingerprint_rounded,
          fields: [
            _QuickActionField('Employe', Icons.person_rounded),
            _QuickActionField('Mode GPS / QR / NFC', Icons.pin_drop_rounded),
            _QuickActionField('Motif', Icons.notes_rounded),
          ],
        ),
      3 => const _QuickActionConfig(
          title: 'Nouveau site',
          icon: Icons.business_rounded,
          fields: [
            _QuickActionField('Nom du site', Icons.business_rounded),
            _QuickActionField('Latitude / longitude', Icons.map_rounded),
            _QuickActionField('Rayon geofence', Icons.radar_rounded),
          ],
        ),
      4 => const _QuickActionConfig(
          title: 'Validation paie',
          icon: Icons.payments_rounded,
          fields: [
            _QuickActionField('Employe', Icons.person_rounded),
            _QuickActionField('Prime / deduction', Icons.calculate_rounded),
            _QuickActionField('Montant', Icons.payments_rounded,
                keyboardType: TextInputType.number),
          ],
        ),
      5 => const _QuickActionConfig(
          title: 'Nouvelle mission',
          icon: Icons.route_rounded,
          fields: [
            _QuickActionField('Employe', Icons.person_rounded),
            _QuickActionField('Destination', Icons.location_on_rounded),
            _QuickActionField('Indemnite', Icons.payments_rounded,
                keyboardType: TextInputType.number),
          ],
        ),
      6 => const _QuickActionConfig(
          title: 'Objectif KPI',
          icon: Icons.flag_rounded,
          fields: [
            _QuickActionField('Employe / equipe', Icons.groups_rounded),
            _QuickActionField('Objectif', Icons.flag_rounded),
            _QuickActionField('Poids KPI', Icons.percent_rounded),
          ],
        ),
      7 => const _QuickActionConfig(
          title: 'Question IA',
          icon: Icons.auto_awesome_rounded,
          fields: [
            _QuickActionField('Question RH', Icons.chat_rounded),
          ],
        ),
      _ => _QuickActionConfig(
          title: strings.t('alerts'),
          icon: Icons.notifications_active_rounded,
          fields: const [
            _QuickActionField('Note rapide', Icons.edit_note_rounded),
          ],
        ),
    };
  }
}

class _Destination {
  const _Destination(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _ActionStatusBar extends StatelessWidget {
  const _ActionStatusBar({
    required this.message,
    required this.clickCount,
  });

  final String message;
  final int clickCount;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.touch_app_rounded, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Clics: $clickCount - $message',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionConfig {
  const _QuickActionConfig({
    required this.title,
    required this.icon,
    required this.fields,
  });

  final String title;
  final IconData icon;
  final List<_QuickActionField> fields;
}

class _QuickActionField {
  const _QuickActionField(
    this.label,
    this.icon, {
    this.keyboardType,
  });

  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
}
