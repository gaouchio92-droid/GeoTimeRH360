import 'package:flutter/material.dart';

import '../../core/localization/app_strings.dart';
import '../../data/demo_data.dart';
import '../shared_widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.activeTenant});

  final TenantAccount activeTenant;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    final tenantEmployees = DemoData.employeesForTenant(activeTenant);
    final employeeCount = activeTenant.employeeCount;
    final presentCount = activeTenant.slug == 'geotime-demo-gn'
        ? tenantEmployees
            .where((employee) => employee.status == 'Presente')
            .length
        : (employeeCount * 0.82).round();
    final lateCount = activeTenant.slug == 'geotime-demo-gn'
        ? tenantEmployees
            .where((employee) => employee.status == 'Retard')
            .length
        : (employeeCount * 0.06).round();
    final absentCount = activeTenant.slug == 'geotime-demo-gn'
        ? tenantEmployees
            .where((employee) => employee.status == 'Absent')
            .length
        : (employeeCount * 0.035).round();
    final presentRate =
        employeeCount == 0 ? 0 : (presentCount / employeeCount * 100).round();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
                width: _cardWidth(context),
                child: MetricCard(
                    title: strings.t('present'),
                    value: '$presentCount',
                    subtitle: '$presentRate% des $employeeCount employes',
                    icon: Icons.groups_rounded,
                    color: scheme.primary)),
            SizedBox(
                width: _cardWidth(context),
                child: MetricCard(
                    title: strings.t('late'),
                    value: '$lateCount',
                    subtitle: '${lateCount ~/ 2} critiques a traiter',
                    icon: Icons.schedule_rounded,
                    color: Colors.orange)),
            SizedBox(
                width: _cardWidth(context),
                child: MetricCard(
                    title: strings.t('absent'),
                    value: '$absentCount',
                    subtitle: '${absentCount ~/ 2} absences injustifiees',
                    icon: Icons.person_off_rounded,
                    color: Colors.red)),
            SizedBox(
                width: _cardWidth(context),
                child: MetricCard(
                    title: strings.t('netPayroll'),
                    value: '27,4M GNF',
                    subtitle: 'Cycle mai pret a valider',
                    icon: Icons.payments_rounded,
                    color: Colors.green)),
          ],
        ),
        const SizedBox(height: 24),
        _TenantContextPanel(activeTenant: activeTenant),
        const SizedBox(height: 24),
        _SaaSOverviewPanel(scheme: scheme),
        const SizedBox(height: 24),
        SectionHeader(title: strings.t('bestSellers')),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 190,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final value in DemoData.attendanceTrend)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          height: value * 1.6,
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const SectionHeader(title: 'Presence intelligente Afrique'),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatusChip(label: 'Offline sync', color: Colors.green),
                StatusChip(label: 'SMS fallback', color: Colors.indigo),
                StatusChip(label: 'USSD fallback', color: Colors.teal),
                StatusChip(label: '2G/3G optimise', color: Colors.orange),
                StatusChip(label: 'Multi-devises', color: Colors.blue),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _ResponsivePanels(
          left: _OrganizationPanel(scheme: scheme),
          right: _ApprovalPanel(scheme: scheme),
        ),
        const SizedBox(height: 24),
        _FraudSignalsPanel(scheme: scheme),
        const SizedBox(height: 24),
        _WorkforcePlanningPanel(scheme: scheme),
        const SizedBox(height: 24),
        SectionHeader(title: strings.t('alerts')),
        ...DemoData.alerts.map((alert) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              child: ListTile(
                leading: Icon(alert.icon, color: scheme.error),
                title: Text(alert.title),
                subtitle: Text(alert.message),
                trailing: const Icon(Icons.chevron_right_rounded),
              ),
            ),
          );
        }),
      ],
    );
  }

  double _cardWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1100) return (width - 132) / 4;
    if (width >= 700) return (width - 92) / 2;
    return width - 32;
  }
}

class _WorkforcePlanningPanel extends StatelessWidget {
  const _WorkforcePlanningPanel({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: 'Planification workforce',
          action: TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Simulation de planning lancee')),
              );
            },
            icon: const Icon(Icons.auto_graph_rounded),
            label: const Text('Simuler'),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.groups_3_rounded, color: scheme.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Couverture previsionnelle par site',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    const StatusChip(
                        label: 'IA planning', color: Colors.indigo),
                  ],
                ),
                const SizedBox(height: 16),
                for (final item in DemoData.workforcePlan)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _WorkforcePlanTile(item: item),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TenantContextPanel extends StatelessWidget {
  const _TenantContextPanel({required this.activeTenant});

  final TenantAccount activeTenant;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: _contextTitleWidth(context),
              child: Row(
                children: [
                  CircleAvatar(child: Text(activeTenant.name.substring(0, 1))),
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
                        Text('${activeTenant.slug} - ${activeTenant.sector}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            StatusChip(label: activeTenant.plan, color: scheme.primary),
            StatusChip(label: activeTenant.status, color: _statusColor()),
            StatusChip(label: activeTenant.dataRegion, color: Colors.teal),
            StatusChip(
              label: activeTenant.ssoEnabled ? 'SSO actif' : 'SSO a configurer',
              color: activeTenant.ssoEnabled ? Colors.green : Colors.orange,
            ),
            StatusChip(
              label: 'Limite ${activeTenant.employeeLimit} employes',
              color: Colors.indigo,
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor() {
    return switch (activeTenant.status) {
      'Actif' => Colors.green,
      'Onboarding' => Colors.orange,
      _ => Colors.blue,
    };
  }

  double _contextTitleWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 900) return 360;
    return width - 64;
  }
}

class _SaaSOverviewPanel extends StatelessWidget {
  const _SaaSOverviewPanel({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Pilotage SaaS multi-tenant'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _SaaSKpi(
                      icon: Icons.apartment_rounded,
                      label: 'Tenants',
                      value:
                          '${DemoData.activeTenantCount}/${DemoData.tenantAccounts.length}',
                      color: scheme.primary,
                    ),
                    _SaaSKpi(
                      icon: Icons.groups_rounded,
                      label: 'Employes heberges',
                      value: '${DemoData.totalTenantEmployees}',
                      color: Colors.teal,
                    ),
                    _SaaSKpi(
                      icon: Icons.payments_rounded,
                      label: 'MRR',
                      value: _money(DemoData.monthlyRecurringRevenue),
                      color: Colors.green,
                    ),
                    const _SaaSKpi(
                      icon: Icons.shield_rounded,
                      label: 'Isolation',
                      value: 'tenant_id',
                      color: Colors.indigo,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    StatusChip(label: 'RBAC par tenant', color: Colors.indigo),
                    StatusChip(label: 'RLS PostgreSQL', color: Colors.green),
                    StatusChip(label: 'Audit logs', color: Colors.orange),
                    StatusChip(label: 'API publique', color: Colors.blue),
                    StatusChip(label: 'SSO / MFA', color: Colors.teal),
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

class _SaaSKpi extends StatelessWidget {
  const _SaaSKpi({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width(context),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelMedium),
                Text(value,
                    style: const TextStyle(fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _width(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1100) return (width - 180) / 4;
    if (width >= 700) return (width - 92) / 2;
    return width - 64;
  }
}

class _WorkforcePlanTile extends StatelessWidget {
  const _WorkforcePlanTile({required this.item});

  final WorkforcePlan item;

  @override
  Widget build(BuildContext context) {
    final coverage = item.scheduled / item.required;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.site,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(item.shift),
                ],
              ),
            ),
            StatusChip(label: item.risk, color: item.color),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: coverage.clamp(0, 1.2) / 1.2,
            minHeight: 10,
            color: item.color,
            backgroundColor: item.color.withValues(alpha: 0.12),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child: Text('${item.scheduled}/${item.required} planifies')),
            Text('Ecart ${item.gap >= 0 ? '+' : ''}${item.gap}'),
            const SizedBox(width: 16),
            Text(_money(item.costImpact)),
          ],
        ),
      ],
    );
  }
}

class _ResponsivePanels extends StatelessWidget {
  const _ResponsivePanels({
    required this.left,
    required this.right,
  });

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
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

class _OrganizationPanel extends StatelessWidget {
  const _OrganizationPanel({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Organigramme dynamique'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (var index = 0;
                    index < DemoData.organization.length;
                    index++) ...[
                  _OrgUnitTile(
                    unit: DemoData.organization[index],
                    color: _orgColor(index),
                  ),
                  if (index < DemoData.organization.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Icon(Icons.keyboard_arrow_down_rounded,
                          color: scheme.outline),
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _orgColor(int index) {
    return switch (index) {
      0 => Colors.indigo,
      1 => Colors.teal,
      2 => Colors.orange,
      _ => Colors.blue,
    };
  }
}

class _OrgUnitTile extends StatelessWidget {
  const _OrgUnitTile({
    required this.unit,
    required this.color,
  });

  final OrgUnit unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.24)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.account_tree_rounded, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(unit.name,
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text('${unit.level} - ${unit.manager}'),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${unit.headcount}',
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              Text('${unit.presentRate.toStringAsFixed(0)}%'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ApprovalPanel extends StatelessWidget {
  const _ApprovalPanel({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Workflow a valider'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (final task in DemoData.approvals)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ApprovalTile(task: task),
                  ),
                const Divider(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.rule_rounded, color: scheme.primary),
                  title: const Text('Circuit actif'),
                  subtitle: const Text('Employe -> Manager -> RH -> Finance'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ApprovalTile extends StatelessWidget {
  const _ApprovalTile({required this.task});

  final ApprovalTask task;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 52,
          decoration: BoxDecoration(
            color: task.color,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title,
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text('${task.step} - ${task.owner}'),
            ],
          ),
        ),
        const SizedBox(width: 8),
        StatusChip(label: task.dueLabel, color: task.color),
      ],
    );
  }
}

class _FraudSignalsPanel extends StatelessWidget {
  const _FraudSignalsPanel({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Anti-fraude pointage'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final signal in DemoData.fraudSignals)
                  SizedBox(
                    width: _signalWidth(context),
                    child: _FraudSignalCard(signal: signal),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _signalWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1100) return (width - 180) / 4;
    if (width >= 700) return (width - 92) / 2;
    return width - 64;
  }
}

class _FraudSignalCard extends StatelessWidget {
  const _FraudSignalCard({required this.signal});

  final FraudSignal signal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: signal.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: signal.color.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_user_rounded, color: signal.color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(signal.label,
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                Text(signal.status),
              ],
            ),
          ),
          Text(
            signal.value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: signal.color,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

String _money(double value) {
  final millions = value / 1000000;
  if (millions >= 1) {
    return '${millions.toStringAsFixed(1)}M GNF'.replaceAll('.', ',');
  }
  return '${value.toStringAsFixed(0)} GNF';
}
