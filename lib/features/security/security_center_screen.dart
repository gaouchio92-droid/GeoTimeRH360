import 'package:flutter/material.dart';

import '../../data/demo_data.dart';
import '../shared_widgets.dart';

class SecurityCenterScreen extends StatelessWidget {
  const SecurityCenterScreen({super.key, required this.activeTenant});

  final TenantAccount activeTenant;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionHeader(
          title: 'Security Center',
          action: FilledButton.icon(
            onPressed: () => _showIncidentRunbook(context),
            icon: const Icon(Icons.shield_rounded),
            label: const Text('Runbook'),
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
                            Text(
                                'Tenant ${activeTenant.slug} - region ${activeTenant.dataRegion}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                StatusChip(
                    label: activeTenant.ssoEnabled ? 'SSO actif' : 'SSO requis',
                    color:
                        activeTenant.ssoEnabled ? Colors.green : Colors.orange),
                StatusChip(
                    label: 'Audit ${activeTenant.auditScore}%',
                    color: activeTenant.auditScore >= 90
                        ? Colors.green
                        : Colors.orange),
                const StatusChip(label: 'SIEM ready', color: Colors.indigo),
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
                title: 'Audit score',
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
              child: const MetricCard(
                title: 'Risques ouverts',
                value: '4',
                subtitle: '2 critiques, 1 haut, 1 moyen',
                icon: Icons.warning_rounded,
                color: Colors.red,
              ),
            ),
            SizedBox(
              width: _metricWidth(context),
              child: const MetricCard(
                title: 'Evenements audit',
                value: '1 284',
                subtitle: 'Dernieres 24 heures',
                icon: Icons.receipt_long_rounded,
                color: Colors.indigo,
              ),
            ),
            SizedBox(
              width: _metricWidth(context),
              child: MetricCard(
                title: 'Data isolation',
                value: 'tenant_id',
                subtitle: '${activeTenant.employeeCount} dossiers scopes',
                icon: Icons.dataset_linked_rounded,
                color: scheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const _ResponsiveSecurityGrid(
          left: _SecurityControlsPanel(),
          right: _SecurityRisksPanel(),
        ),
        const SizedBox(height: 20),
        const _ResponsiveSecurityGrid(
          left: _SecurityOwnershipPanel(),
          right: _SecurityEventsPanel(),
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

  double _contextWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 980) return 440;
    return width - 64;
  }

  void _showIncidentRunbook(BuildContext context) {
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
                leading: Icon(Icons.block_rounded),
                title: Text('1. Contenir'),
                subtitle:
                    Text('Desactiver session, token API ou export compromis.'),
              ),
              ListTile(
                leading: Icon(Icons.manage_search_rounded),
                title: Text('2. Investiguer'),
                subtitle: Text(
                    'Consulter audit logs, tenant_id, IP, appareil et action.'),
              ),
              ListTile(
                leading: Icon(Icons.fact_check_rounded),
                title: Text('3. Corriger'),
                subtitle:
                    Text('Mettre a jour RBAC, RLS, MFA, secret ou workflow.'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ResponsiveSecurityGrid extends StatelessWidget {
  const _ResponsiveSecurityGrid({required this.left, required this.right});

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

class _SecurityControlsPanel extends StatelessWidget {
  const _SecurityControlsPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Controles securite'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (final control in DemoData.securityControls)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _SecurityControlTile(control: control),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SecurityRisksPanel extends StatelessWidget {
  const _SecurityRisksPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Threat model RH'),
        for (final risk in DemoData.securityRisks)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: ListTile(
                leading: Icon(Icons.warning_rounded, color: risk.color),
                title: Text(risk.title),
                subtitle:
                    Text('${risk.impact}\nMitigation: ${risk.mitigation}'),
                isThreeLine: true,
                trailing: StatusChip(label: risk.severity, color: risk.color),
              ),
            ),
          ),
      ],
    );
  }
}

class _SecurityOwnershipPanel extends StatelessWidget {
  const _SecurityOwnershipPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Ownership map'),
        Card(
          child: Column(
            children: [
              for (final owner in DemoData.securityOwners)
                ListTile(
                  leading:
                      Icon(Icons.assignment_ind_rounded, color: owner.color),
                  title: Text(owner.domain),
                  subtitle: Text(
                      '${owner.owner} - ${owner.responsibility}\nBackup: ${owner.backup}'),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SecurityEventsPanel extends StatelessWidget {
  const _SecurityEventsPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Audit events'),
        Card(
          child: Column(
            children: [
              for (final event in DemoData.securityEvents)
                ListTile(
                  leading: Icon(Icons.history_rounded, color: event.color),
                  title: Text(event.title),
                  subtitle: Text('${event.actor} - ${event.when}'),
                  trailing:
                      StatusChip(label: event.decision, color: event.color),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SecurityControlTile extends StatelessWidget {
  const _SecurityControlTile({required this.control});

  final SecurityControl control;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(control.title,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  Text('${control.scope} - ${control.owner}'),
                ],
              ),
            ),
            StatusChip(label: control.status, color: control.color),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: control.coverage,
            minHeight: 10,
            color: control.color,
            backgroundColor: control.color.withValues(alpha: 0.12),
          ),
        ),
      ],
    );
  }
}
