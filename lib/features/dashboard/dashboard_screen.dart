import 'package:flutter/material.dart';

import '../../core/localization/app_strings.dart';
import '../../data/demo_data.dart';
import '../shared_widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(width: _cardWidth(context), child: MetricCard(title: strings.t('present'), value: '244', subtitle: '92% des effectifs actifs', icon: Icons.groups_rounded, color: scheme.primary)),
            SizedBox(width: _cardWidth(context), child: MetricCard(title: strings.t('late'), value: '18', subtitle: '6 critiques a traiter', icon: Icons.schedule_rounded, color: Colors.orange)),
            SizedBox(width: _cardWidth(context), child: MetricCard(title: strings.t('absent'), value: '12', subtitle: '4 absences injustifiees', icon: Icons.person_off_rounded, color: Colors.red)),
            SizedBox(width: _cardWidth(context), child: MetricCard(title: strings.t('netPayroll'), value: '27,4M GNF', subtitle: 'Cycle mai pret a valider', icon: Icons.payments_rounded, color: Colors.green)),
          ],
        ),
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
                for (var index = 0; index < DemoData.organization.length; index++) ...[
                  _OrgUnitTile(
                    unit: DemoData.organization[index],
                    color: _orgColor(index),
                  ),
                  if (index < DemoData.organization.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Icon(Icons.keyboard_arrow_down_rounded, color: scheme.outline),
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
                Text(unit.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text('${unit.level} - ${unit.manager}'),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${unit.headcount}', style: const TextStyle(fontWeight: FontWeight.w800)),
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
              Text(task.title, style: const TextStyle(fontWeight: FontWeight.w800)),
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
                Text(signal.label, style: const TextStyle(fontWeight: FontWeight.w800)),
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
