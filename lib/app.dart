import 'package:flutter/material.dart';

import 'core/localization/app_strings.dart';
import 'data/demo_data.dart';
import 'features/admin/admin_dashboard_screen.dart';
import 'features/ai/ai_screen.dart';
import 'features/missions/missions_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/attendance/attendance_screen.dart';
import 'features/payroll/payroll_screen.dart';
import 'features/employees/employees_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/performance/performance_screen.dart';
import 'features/sites/sites_screen.dart';
import 'features/suite/hr_suite_screen.dart';
import 'features/tenants/tenants_screen.dart';

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
  int _activeTenantIndex = 0;
  String _statusMessage = 'Plateforme prete';
  int _clickCount = 0;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final activeTenant = DemoData.tenantAccounts[_activeTenantIndex];
    final destinations = [
      _Destination(strings.t('dashboard'), Icons.dashboard_rounded),
      _Destination(strings.t('admin'), Icons.admin_panel_settings_rounded),
      _Destination(strings.t('suite'), Icons.auto_awesome_motion_rounded),
      _Destination(strings.t('products'), Icons.badge_rounded),
      _Destination(strings.t('stock'), Icons.fingerprint_rounded),
      _Destination(strings.t('pos'), Icons.payments_rounded),
      _Destination(strings.t('warehouses'), Icons.business_rounded),
      _Destination(strings.t('customers'), Icons.route_rounded),
      _Destination(strings.t('suppliers'), Icons.query_stats_rounded),
      _Destination(strings.t('ai'), Icons.psychology_rounded),
      _Destination(strings.t('tenants'), Icons.apartment_rounded),
      _Destination(strings.t('settings'), Icons.settings_rounded),
    ];
    final pages = [
      DashboardScreen(activeTenant: activeTenant),
      AdminDashboardScreen(activeTenant: activeTenant),
      HrSuiteScreen(activeTenant: activeTenant),
      EmployeesScreen(activeTenant: activeTenant),
      const AttendanceScreen(),
      const PayrollScreen(),
      const SitesScreen(),
      const MissionsScreen(),
      const PerformanceScreen(),
      const AiScreen(),
      TenantsScreen(
        activeTenant: activeTenant,
        onTenantSelected: _selectTenant,
      ),
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
          _TenantSwitcher(
            activeTenant: activeTenant,
            onTenantSelected: _selectTenant,
          ),
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
      bottomNavigationBar: wide || _index > 4
          ? null
          : NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (value) => _selectPage(value),
              destinations: destinations.take(5).map((item) {
                return NavigationDestination(
                    icon: Icon(item.icon), label: item.label);
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
      1 => 'Admin',
      2 => 'Suite RH',
      3 => strings.t('products'),
      4 => 'Pointer',
      5 => 'Paie',
      6 => 'Site',
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

  void _selectTenant(TenantAccount tenant) {
    final index = DemoData.tenantAccounts.indexOf(tenant);
    if (index == -1) return;
    setState(() {
      _activeTenantIndex = index;
      _clickCount++;
      _statusMessage = 'Tenant actif: ${tenant.name}';
    });
  }

  String _pageName(int value) {
    return switch (value) {
      0 => 'Tableau',
      1 => 'Admin',
      2 => 'Suite RH 360',
      3 => 'Employes',
      4 => 'Pointage',
      5 => 'Paie',
      6 => 'Sites',
      7 => 'Missions',
      8 => 'Performance',
      9 => 'IA RH',
      10 => 'Tenants',
      11 => 'Reglages',
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
                subtitle:
                    const Text('Fake GPS detecte sur un appareil Android.'),
                trailing: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Verifier'),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.schedule_rounded),
                title: const Text('Retard recurrent'),
                subtitle:
                    const Text('5 retards sur 10 jours dans IT & securite.'),
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
          title: 'Action admin',
          icon: Icons.admin_panel_settings_rounded,
          fields: [
            _QuickActionField('Operation', Icons.tune_rounded),
            _QuickActionField('Tenant cible', Icons.apartment_rounded),
            _QuickActionField('Motif audit', Icons.fact_check_rounded),
          ],
        ),
      2 => const _QuickActionConfig(
          title: 'Priorite produit',
          icon: Icons.auto_awesome_motion_rounded,
          fields: [
            _QuickActionField('Capacite cible', Icons.extension_rounded),
            _QuickActionField(
                'Reference marche', Icons.business_center_rounded),
            _QuickActionField('KPI attendu', Icons.query_stats_rounded),
          ],
        ),
      3 => const _QuickActionConfig(
          title: 'Nouvel employe',
          icon: Icons.person_add_rounded,
          fields: [
            _QuickActionField('Nom complet', Icons.person_rounded),
            _QuickActionField('Matricule', Icons.badge_rounded),
            _QuickActionField('Salaire de base', Icons.payments_rounded,
                keyboardType: TextInputType.number),
          ],
        ),
      4 => const _QuickActionConfig(
          title: 'Pointage manuel',
          icon: Icons.fingerprint_rounded,
          fields: [
            _QuickActionField('Employe', Icons.person_rounded),
            _QuickActionField('Mode GPS / QR / NFC', Icons.pin_drop_rounded),
            _QuickActionField('Motif', Icons.notes_rounded),
          ],
        ),
      5 => const _QuickActionConfig(
          title: 'Validation paie',
          icon: Icons.payments_rounded,
          fields: [
            _QuickActionField('Employe', Icons.person_rounded),
            _QuickActionField('Prime / deduction', Icons.calculate_rounded),
            _QuickActionField('Montant', Icons.payments_rounded,
                keyboardType: TextInputType.number),
          ],
        ),
      6 => const _QuickActionConfig(
          title: 'Nouveau site',
          icon: Icons.business_rounded,
          fields: [
            _QuickActionField('Nom du site', Icons.business_rounded),
            _QuickActionField('Latitude / longitude', Icons.map_rounded),
            _QuickActionField('Rayon geofence', Icons.radar_rounded),
          ],
        ),
      7 => const _QuickActionConfig(
          title: 'Nouvelle mission',
          icon: Icons.route_rounded,
          fields: [
            _QuickActionField('Employe', Icons.person_rounded),
            _QuickActionField('Destination', Icons.location_on_rounded),
            _QuickActionField('Indemnite', Icons.payments_rounded,
                keyboardType: TextInputType.number),
          ],
        ),
      8 => const _QuickActionConfig(
          title: 'Objectif KPI',
          icon: Icons.flag_rounded,
          fields: [
            _QuickActionField('Employe / equipe', Icons.groups_rounded),
            _QuickActionField('Objectif', Icons.flag_rounded),
            _QuickActionField('Poids KPI', Icons.percent_rounded),
          ],
        ),
      9 => const _QuickActionConfig(
          title: 'Question IA',
          icon: Icons.auto_awesome_rounded,
          fields: [
            _QuickActionField('Question RH', Icons.chat_rounded),
          ],
        ),
      10 => const _QuickActionConfig(
          title: 'Nouveau tenant',
          icon: Icons.add_business_rounded,
          fields: [
            _QuickActionField('Nom organisation', Icons.apartment_rounded),
            _QuickActionField('Domaine / slug', Icons.link_rounded),
            _QuickActionField('Plan SaaS', Icons.workspace_premium_rounded),
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

class _TenantSwitcher extends StatelessWidget {
  const _TenantSwitcher({
    required this.activeTenant,
    required this.onTenantSelected,
  });

  final TenantAccount activeTenant;
  final ValueChanged<TenantAccount> onTenantSelected;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 760;
    return PopupMenuButton<TenantAccount>(
      tooltip: 'Changer de tenant',
      onSelected: onTenantSelected,
      itemBuilder: (context) {
        return [
          for (final tenant in DemoData.tenantAccounts)
            PopupMenuItem(
              value: tenant,
              child: Row(
                children: [
                  Icon(
                    tenant == activeTenant
                        ? Icons.check_circle_rounded
                        : Icons.apartment_rounded,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(tenant.name)),
                  const SizedBox(width: 8),
                  Text(tenant.plan),
                ],
              ),
            ),
        ];
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Chip(
          avatar: const Icon(Icons.apartment_rounded, size: 18),
          label: Text(wide ? activeTenant.name : activeTenant.slug),
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
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
