import 'package:flutter/material.dart';

import '../../data/demo_data.dart';
import '../shared_widgets.dart';

class HrSuiteScreen extends StatelessWidget {
  const HrSuiteScreen({super.key, required this.activeTenant});

  final TenantAccount activeTenant;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionHeader(
          title: 'Suite RH 360',
          action: FilledButton.icon(
            onPressed: () => _showRoadmap(context),
            icon: const Icon(Icons.rocket_launch_rounded),
            label: const Text('Roadmap'),
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
                                'Benchmark produit applique au tenant ${activeTenant.slug}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const StatusChip(label: 'UKG analytics', color: Colors.indigo),
                const StatusChip(label: 'Deel conformite', color: Colors.green),
                const StatusChip(label: 'Paylocity EX', color: Colors.teal),
                const StatusChip(
                    label: 'Paycom onboarding', color: Colors.orange),
                const StatusChip(label: 'Greenhouse ATS', color: Colors.blue),
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
              child: const MetricCard(
                title: 'Score IA workforce',
                value: '87%',
                subtitle: 'Risque depart, absence, couverture',
                icon: Icons.auto_graph_rounded,
                color: Colors.indigo,
              ),
            ),
            SizedBox(
              width: _metricWidth(context),
              child: MetricCard(
                title: 'Conformite paie',
                value: '94%',
                subtitle: '${activeTenant.country}, ${activeTenant.currency}',
                icon: Icons.gavel_rounded,
                color: Colors.green,
              ),
            ),
            SizedBox(
              width: _metricWidth(context),
              child: const MetricCard(
                title: 'Experience employe',
                value: '4,6/5',
                subtitle: 'Mobile, self-service, notifications',
                icon: Icons.sentiment_satisfied_alt_rounded,
                color: Colors.teal,
              ),
            ),
            SizedBox(
              width: _metricWidth(context),
              child: const MetricCard(
                title: 'ATS haut volume',
                value: '342',
                subtitle: 'Candidats en pipeline',
                icon: Icons.work_rounded,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Capacites inspirees des leaders RH'),
        for (final capability in DemoData.strategicCapabilities)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _CapabilityCard(capability: capability),
          ),
        const SizedBox(height: 20),
        const _ResponsiveSuiteGrid(
          left: _RecruitingPipelinePanel(),
          right: _OnboardingPanel(),
        ),
        const SizedBox(height: 20),
        _ResponsiveSuiteGrid(
          left: _CompliancePanel(activeTenant: activeTenant),
          right: _IntegrationPanel(scheme: scheme),
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
    if (width >= 980) return 430;
    return width - 64;
  }

  void _showRoadmap(BuildContext context) {
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
                leading: Icon(Icons.auto_graph_rounded),
                title: Text('Phase 1 - Analytics IA'),
                subtitle: Text(
                    'Scores risque depart, absentéisme, productivite et couverture shift.'),
              ),
              ListTile(
                leading: Icon(Icons.gavel_rounded),
                title: Text('Phase 2 - Paie conformite'),
                subtitle: Text(
                    'Regles multi-pays, validations, audit finance et exports comptables.'),
              ),
              ListTile(
                leading: Icon(Icons.work_rounded),
                title: Text('Phase 3 - ATS et onboarding'),
                subtitle: Text(
                    'CV parsing, scorecards, embauche vers dossier RH et parcours employe.'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CapabilityCard extends StatelessWidget {
  const _CapabilityCard({required this.capability});

  final StrategicCapability capability;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: capability.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(capability.icon, color: capability.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${capability.platformReference} - ${capability.title}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      Text(capability.positioning),
                    ],
                  ),
                ),
                StatusChip(label: capability.status, color: capability.color),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: capability.color.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: capability.color.withValues(alpha: 0.16)),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(capability.geoTimeFeature)),
                  const SizedBox(width: 12),
                  Text(
                    capability.kpi,
                    style: TextStyle(
                        color: capability.color, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResponsiveSuiteGrid extends StatelessWidget {
  const _ResponsiveSuiteGrid({required this.left, required this.right});

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

class _RecruitingPipelinePanel extends StatelessWidget {
  const _RecruitingPipelinePanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'ATS haut volume'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (final stage in DemoData.recruitingPipeline)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _PipelineStage(stage: stage),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingPanel extends StatelessWidget {
  const _OnboardingPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Self-onboarding'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (final task in DemoData.onboardingTasks)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _OnboardingTaskTile(task: task),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CompliancePanel extends StatelessWidget {
  const _CompliancePanel({required this.activeTenant});

  final TenantAccount activeTenant;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Paie et conformite'),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.payments_rounded),
                title: const Text('Moteur paie multi-regles'),
                subtitle: Text(
                    'Devise ${activeTenant.currency}, pays ${activeTenant.country}, barèmes overtime.'),
                trailing: const StatusChip(label: 'Pret', color: Colors.green),
              ),
              const Divider(height: 1),
              const ListTile(
                leading: Icon(Icons.rule_folder_rounded),
                title: Text('Audit conformité'),
                subtitle: Text(
                    'Contrats, absences, retenues, validations RH/Finance.'),
                trailing: StatusChip(label: 'Traçable', color: Colors.indigo),
              ),
              const Divider(height: 1),
              const ListTile(
                leading: Icon(Icons.account_balance_rounded),
                title: Text('Exports comptables'),
                subtitle: Text('Sage, Odoo, SAP, Oracle ERP et API finance.'),
                trailing: StatusChip(label: 'API', color: Colors.blue),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IntegrationPanel extends StatelessWidget {
  const _IntegrationPanel({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Experience employe et integrations'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatusChip(label: 'Portail mobile', color: scheme.primary),
                const StatusChip(
                    label: 'Microsoft Teams', color: Colors.indigo),
                const StatusChip(label: 'Slack', color: Colors.purple),
                const StatusChip(label: 'Odoo', color: Colors.green),
                const StatusChip(label: 'Sage', color: Colors.teal),
                const StatusChip(label: 'Active Directory', color: Colors.blue),
                const StatusChip(label: 'WhatsApp', color: Colors.green),
                const StatusChip(label: 'SMS / USSD', color: Colors.orange),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PipelineStage extends StatelessWidget {
  const _PipelineStage({required this.stage});

  final RecruitingPipelineStage stage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: Text(stage.stage,
                    style: const TextStyle(fontWeight: FontWeight.w800))),
            Text('${stage.count}'),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: stage.conversionRate,
            minHeight: 10,
            color: stage.color,
            backgroundColor: stage.color.withValues(alpha: 0.12),
          ),
        ),
      ],
    );
  }
}

class _OnboardingTaskTile extends StatelessWidget {
  const _OnboardingTaskTile({required this.task});

  final OnboardingTask task;

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
                  Text(task.title,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  Text(task.owner),
                ],
              ),
            ),
            StatusChip(label: task.status, color: task.color),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: task.progress,
            minHeight: 10,
            color: task.color,
            backgroundColor: task.color.withValues(alpha: 0.12),
          ),
        ),
      ],
    );
  }
}
