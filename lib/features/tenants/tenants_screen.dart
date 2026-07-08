import 'package:flutter/material.dart';

import '../../data/demo_data.dart';
import '../shared_widgets.dart';

class TenantsScreen extends StatelessWidget {
  const TenantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionHeader(
          title: 'Console SaaS multi-tenant',
          action: FilledButton.icon(
            onPressed: () => _showProvisioning(context),
            icon: const Icon(Icons.add_business_rounded),
            label: const Text('Nouveau tenant'),
          ),
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: _metricWidth(context),
              child: MetricCard(
                title: 'Tenants actifs',
                value:
                    '${DemoData.activeTenantCount}/${DemoData.tenantAccounts.length}',
                subtitle: 'Production, onboarding et essai',
                icon: Icons.apartment_rounded,
                color: scheme.primary,
              ),
            ),
            SizedBox(
              width: _metricWidth(context),
              child: MetricCard(
                title: 'Effectif heberge',
                value: '${DemoData.totalTenantEmployees}',
                subtitle: 'Employes tous tenants',
                icon: Icons.groups_rounded,
                color: Colors.teal,
              ),
            ),
            SizedBox(
              width: _metricWidth(context),
              child: MetricCard(
                title: 'MRR simule',
                value: _money(DemoData.monthlyRecurringRevenue),
                subtitle: 'Revenus SaaS mensuels',
                icon: Icons.payments_rounded,
                color: Colors.green,
              ),
            ),
            SizedBox(
              width: _metricWidth(context),
              child: const MetricCard(
                title: 'SLA plateforme',
                value: '99,95%',
                subtitle: 'API, web, mobile, sync offline',
                icon: Icons.speed_rounded,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const _ControlsPanel(),
        const SizedBox(height: 20),
        SectionHeader(
          title: 'Locataires',
          action: TextButton.icon(
            onPressed: () => _showProvisioning(context),
            icon: const Icon(Icons.tune_rounded),
            label: const Text('Provisioning'),
          ),
        ),
        for (final tenant in DemoData.tenantAccounts)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _TenantCard(tenant: tenant),
          ),
      ],
    );
  }

  double _metricWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1180) return (width - 150) / 4;
    if (width >= 760) return (width - 92) / 2;
    return width - 32;
  }

  void _showProvisioning(BuildContext context) {
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
                leading: Icon(Icons.check_circle_rounded),
                title: Text('Etapes provisioning'),
                subtitle: Text(
                    'Domaine, plan, region data, modules, admins, politiques RBAC.'),
              ),
              ListTile(
                leading: Icon(Icons.security_rounded),
                title: Text('Isolation obligatoire'),
                subtitle: Text(
                    'Schema tenant_id, RLS PostgreSQL, bucket MinIO separe, audit logs.'),
              ),
              ListTile(
                leading: Icon(Icons.sync_rounded),
                title: Text('Activation mobile'),
                subtitle: Text(
                    'QR dynamique, offline sync, SMS/USSD fallback et politiques appareil.'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ControlsPanel extends StatelessWidget {
  const _ControlsPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Fondations plateforme'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final control in DemoData.saasControls)
                  SizedBox(
                    width: _controlWidth(context),
                    child: _ControlTile(control: control),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _controlWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1100) return (width - 180) / 4;
    if (width >= 720) return (width - 92) / 2;
    return width - 64;
  }
}

class _ControlTile extends StatelessWidget {
  const _ControlTile({required this.control});

  final SaaSControl control;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: control.color.withValues(alpha: 0.18)),
        color: control.color.withValues(alpha: 0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(control.icon, color: control.color),
              const Spacer(),
              StatusChip(label: control.value, color: control.color),
            ],
          ),
          const SizedBox(height: 12),
          Text(control.title,
              style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(control.description),
        ],
      ),
    );
  }
}

class _TenantCard extends StatelessWidget {
  const _TenantCard({required this.tenant});

  final TenantAccount tenant;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (tenant.status) {
      'Actif' => Colors.green,
      'Onboarding' => Colors.orange,
      _ => Colors.blue,
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(tenant.name.substring(0, 1)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tenant.name,
                          style: const TextStyle(fontWeight: FontWeight.w900)),
                      Text(
                          '${tenant.slug} - ${tenant.sector} - ${tenant.country}'),
                    ],
                  ),
                ),
                StatusChip(label: tenant.status, color: statusColor),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _TinyStat(
                    icon: Icons.workspace_premium_rounded, label: tenant.plan),
                _TinyStat(
                    icon: Icons.groups_rounded,
                    label: '${tenant.employeeCount} employes'),
                _TinyStat(
                    icon: Icons.people_alt_rounded,
                    label: '${tenant.userCount} users'),
                _TinyStat(
                    icon: Icons.business_rounded,
                    label: '${tenant.siteCount} sites'),
                _TinyStat(
                    icon: Icons.storage_rounded,
                    label: '${tenant.storageGb.toStringAsFixed(1)} Go'),
                _TinyStat(icon: Icons.public_rounded, label: tenant.dataRegion),
                _TinyStat(
                    icon: Icons.security_rounded,
                    label: tenant.ssoEnabled ? 'SSO actif' : 'SSO non actif'),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: tenant.auditScore / 100,
                minHeight: 10,
                color: tenant.auditScore >= 90 ? Colors.green : Colors.orange,
                backgroundColor: Colors.grey.withValues(alpha: 0.16),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text('Audit securite ${tenant.auditScore}%')),
                Text(_money(tenant.monthlyRevenue)),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final module in tenant.modules)
                  StatusChip(
                      label: module,
                      color: Theme.of(context).colorScheme.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TinyStat extends StatelessWidget {
  const _TinyStat({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      visualDensity: VisualDensity.compact,
    );
  }
}

String _money(double value) {
  final millions = value / 1000000;
  return '${millions.toStringAsFixed(1)}M GNF'.replaceAll('.', ',');
}
