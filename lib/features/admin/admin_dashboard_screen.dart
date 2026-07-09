import 'package:flutter/material.dart';

import '../../data/demo_data.dart';
import '../shared_widgets.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key, required this.activeTenant});

  final TenantAccount activeTenant;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final storageRate = activeTenant.storageGb / 120;
    final usageRate = activeTenant.employeeCount / activeTenant.employeeLimit;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionHeader(
          title: 'Dashboard Admin',
          action: FilledButton.icon(
            onPressed: () => _showAdminAction(context),
            icon: const Icon(Icons.admin_panel_settings_rounded),
            label: const Text('Action admin'),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: _contextWidth(context),
                  child: Row(
                    children: [
                      CircleAvatar(
                          child: Text(activeTenant.name.substring(0, 1))),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activeTenant.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                            Text('${activeTenant.slug} - ${activeTenant.plan}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                StatusChip(
                    label: activeTenant.status,
                    color: _statusColor(activeTenant.status)),
                StatusChip(label: activeTenant.dataRegion, color: Colors.teal),
                StatusChip(
                    label: activeTenant.ssoEnabled ? 'SSO actif' : 'SSO requis',
                    color:
                        activeTenant.ssoEnabled ? Colors.green : Colors.orange),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: _metricWidth(context),
              child: MetricCard(
                title: 'Tenants',
                value:
                    '${DemoData.activeTenantCount}/${DemoData.tenantAccounts.length}',
                subtitle: 'Actifs / total plateforme',
                icon: Icons.apartment_rounded,
                color: scheme.primary,
              ),
            ),
            SizedBox(
              width: _metricWidth(context),
              child: MetricCard(
                title: 'Utilisateurs',
                value: '${activeTenant.userCount}',
                subtitle: 'Comptes admin, RH, manager',
                icon: Icons.manage_accounts_rounded,
                color: Colors.indigo,
              ),
            ),
            SizedBox(
              width: _metricWidth(context),
              child: MetricCard(
                title: 'Audit securite',
                value: '${activeTenant.auditScore}%',
                subtitle: 'MFA, RBAC, logs, SSO',
                icon: Icons.verified_user_rounded,
                color: activeTenant.auditScore >= 90
                    ? Colors.green
                    : Colors.orange,
              ),
            ),
            SizedBox(
              width: _metricWidth(context),
              child: MetricCard(
                title: 'Stockage',
                value: '${activeTenant.storageGb.toStringAsFixed(1)} Go',
                subtitle: 'Documents RH et preuves pointage',
                icon: Icons.storage_rounded,
                color: Colors.teal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _ResponsiveAdminGrid(
          left: _TenantUsagePanel(
            activeTenant: activeTenant,
            usageRate: usageRate,
            storageRate: storageRate,
          ),
          right: const _PlatformHealthPanel(),
        ),
        const SizedBox(height: 20),
        const _ResponsiveAdminGrid(
          left: _SecurityPanel(),
          right: _SyncJobsPanel(),
        ),
        const SizedBox(height: 20),
        const _AdminActivityPanel(),
      ],
    );
  }

  double _metricWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1180) return (width - 150) / 4;
    if (width >= 760) return (width - 92) / 2;
    return width - 32;
  }

  double _contextWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 900) return 380;
    return width - 64;
  }

  Color _statusColor(String status) {
    return switch (status) {
      'Actif' => Colors.green,
      'Onboarding' => Colors.orange,
      _ => Colors.blue,
    };
  }

  void _showAdminAction(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.security_rounded),
                title: Text('Forcer rotation session'),
                subtitle:
                    Text('Expire les sessions sensibles du tenant actif.'),
              ),
              ListTile(
                leading: Icon(Icons.backup_rounded),
                title: Text('Lancer sauvegarde'),
                subtitle:
                    Text('Snapshot PostgreSQL, MinIO et configuration RBAC.'),
              ),
              ListTile(
                leading: Icon(Icons.fact_check_rounded),
                title: Text('Exporter audit'),
                subtitle:
                    Text('Journal admin, pointage, paie et acces documents.'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ResponsiveAdminGrid extends StatelessWidget {
  const _ResponsiveAdminGrid({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 920;
    if (!wide) {
      return Column(
        children: [
          left,
          const SizedBox(height: 16),
          right,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }
}

class _TenantUsagePanel extends StatelessWidget {
  const _TenantUsagePanel({
    required this.activeTenant,
    required this.usageRate,
    required this.storageRate,
  });

  final TenantAccount activeTenant;
  final double usageRate;
  final double storageRate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Quota tenant'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _ProgressLine(
                  title: 'Employes',
                  value:
                      '${activeTenant.employeeCount}/${activeTenant.employeeLimit}',
                  progress: usageRate,
                  color: usageRate > 0.8 ? Colors.orange : Colors.green,
                ),
                const SizedBox(height: 16),
                _ProgressLine(
                  title: 'Stockage documents',
                  value: '${activeTenant.storageGb.toStringAsFixed(1)}/120 Go',
                  progress: storageRate,
                  color: storageRate > 0.75 ? Colors.orange : Colors.teal,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final module in activeTenant.modules)
                      StatusChip(
                          label: module,
                          color: Theme.of(context).colorScheme.primary),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PlatformHealthPanel extends StatelessWidget {
  const _PlatformHealthPanel();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: 'Sante plateforme'),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _HealthTile(
                    label: 'API Gateway',
                    value: '35 ms',
                    status: 'OK',
                    color: Colors.green),
                _HealthTile(
                    label: 'PostgreSQL',
                    value: '4 connexions',
                    status: 'OK',
                    color: Colors.green),
                _HealthTile(
                    label: 'Redis cache',
                    value: '92% hit',
                    status: 'OK',
                    color: Colors.green),
                _HealthTile(
                    label: 'MinIO documents',
                    value: '18,4 Go',
                    status: 'OK',
                    color: Colors.green),
                _HealthTile(
                    label: 'SMS/USSD fallback',
                    value: '2 files',
                    status: 'A surveiller',
                    color: Colors.orange),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SecurityPanel extends StatelessWidget {
  const _SecurityPanel();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: 'Securite admin'),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _PolicyTile(
                    title: 'MFA obligatoire',
                    subtitle: 'Admins, RH et Finance',
                    enabled: true),
                _PolicyTile(
                    title: 'RBAC strict',
                    subtitle: 'Permissions par tenant et module',
                    enabled: true),
                _PolicyTile(
                    title: 'RLS PostgreSQL',
                    subtitle: 'Isolation tenant_id sur tables sensibles',
                    enabled: true),
                _PolicyTile(
                    title: 'SIEM integration',
                    subtitle: 'Flux audit vers SOC client',
                    enabled: true),
                _PolicyTile(
                    title: 'Rotation secrets',
                    subtitle: 'A programmer avant production',
                    enabled: false),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SyncJobsPanel extends StatelessWidget {
  const _SyncJobsPanel();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: 'Jobs et sync'),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _JobTile(
                    title: 'Sync offline mobile',
                    detail: '47 pointages en file',
                    color: Colors.orange),
                _JobTile(
                    title: 'Calcul paie nocturne',
                    detail: 'Planifie 23:30',
                    color: Colors.indigo),
                _JobTile(
                    title: 'Backup PostgreSQL',
                    detail: 'Dernier snapshot 02:10',
                    color: Colors.green),
                _JobTile(
                    title: 'Export audit SIEM',
                    detail: 'Toutes les 15 minutes',
                    color: Colors.blue),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AdminActivityPanel extends StatelessWidget {
  const _AdminActivityPanel();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: 'Activite admin recente'),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.login_rounded),
                title: Text('Connexion admin plateforme'),
                subtitle:
                    Text('MFA valide, IP Conakry, session limitee a 8 h.'),
                trailing: StatusChip(label: 'OK', color: Colors.green),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.rule_rounded),
                title: Text('Politique RBAC modifiee'),
                subtitle:
                    Text('Role Finance: validation paie uniquement apres RH.'),
                trailing: StatusChip(label: 'Audit', color: Colors.indigo),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.warning_rounded),
                title: Text('Tentative export bloquee'),
                subtitle:
                    Text('Utilisateur sans permission documents RH sensibles.'),
                trailing: StatusChip(label: 'Bloque', color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({
    required this.title,
    required this.value,
    required this.progress,
    required this.color,
  });

  final String title;
  final String value;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w800))),
            Text(value),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: 10,
            color: color,
            backgroundColor: color.withValues(alpha: 0.12),
          ),
        ),
      ],
    );
  }
}

class _HealthTile extends StatelessWidget {
  const _HealthTile({
    required this.label,
    required this.value,
    required this.status,
    required this.color,
  });

  final String label;
  final String value;
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.monitor_heart_rounded, color: color),
      title: Text(label),
      subtitle: Text(value),
      trailing: StatusChip(label: status, color: color),
    );
  }
}

class _PolicyTile extends StatelessWidget {
  const _PolicyTile({
    required this.title,
    required this.subtitle,
    required this.enabled,
  });

  final String title;
  final String subtitle;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? Colors.green : Colors.orange;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
          enabled ? Icons.check_circle_rounded : Icons.pending_actions_rounded,
          color: color),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: StatusChip(label: enabled ? 'Actif' : 'A faire', color: color),
    );
  }
}

class _JobTile extends StatelessWidget {
  const _JobTile({
    required this.title,
    required this.detail,
    required this.color,
  });

  final String title;
  final String detail;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.sync_rounded, color: color),
      title: Text(title),
      subtitle: Text(detail),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}
