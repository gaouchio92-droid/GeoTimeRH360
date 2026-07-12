import 'package:flutter/material.dart';

import '../../data/demo_data.dart';
import '../shared_widgets.dart';

class RecruitingScreen extends StatelessWidget {
  const RecruitingScreen({super.key, required this.activeTenant});

  final TenantAccount activeTenant;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionHeader(
          title: 'Recrutement ATS',
          action: FilledButton.icon(
            onPressed: () => _showNewRequisition(context),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nouvelle offre'),
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
                            const Text(
                                'ATS haut volume, IA sourcing, embauche vers dossier RH'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const StatusChip(label: 'CV parsing', color: Colors.indigo),
                const StatusChip(label: 'Scorecards', color: Colors.blue),
                const StatusChip(label: 'Entretiens', color: Colors.orange),
                const StatusChip(label: 'Onboarding', color: Colors.green),
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
                title: 'Candidats',
                value: '342',
                subtitle: 'Tous postes ouverts',
                icon: Icons.groups_rounded,
                color: Colors.blue,
              ),
            ),
            SizedBox(
              width: _metricWidth(context),
              child: const MetricCard(
                title: 'Shortlist IA',
                value: '126',
                subtitle: 'Scores > 75%',
                icon: Icons.auto_awesome_rounded,
                color: Colors.indigo,
              ),
            ),
            SizedBox(
              width: _metricWidth(context),
              child: const MetricCard(
                title: 'Time-to-hire',
                value: '18 j',
                subtitle: 'Moyenne tenant actif',
                icon: Icons.schedule_rounded,
                color: Colors.orange,
              ),
            ),
            SizedBox(
              width: _metricWidth(context),
              child: const MetricCard(
                title: 'Embauches',
                value: '11',
                subtitle: 'Converties vers RH Core',
                icon: Icons.badge_rounded,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const _ResponsiveRecruitingGrid(
          left: _PipelinePanel(),
          right: _InterviewPanel(),
        ),
        const SizedBox(height: 20),
        const _ResponsiveRecruitingGrid(
          left: _RequisitionsPanel(),
          right: _CandidateShortlistPanel(),
        ),
        const SizedBox(height: 20),
        const _HireToHrPanel(),
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
    if (width >= 980) return 460;
    return width - 64;
  }

  void _showNewRequisition(BuildContext context) {
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
                'Nouvelle requisition',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Intitule du poste',
                  prefixIcon: Icon(Icons.work_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Departement',
                  prefixIcon: Icon(Icons.account_tree_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Requisition ATS creee')),
                  );
                },
                icon: const Icon(Icons.check_rounded),
                label: const Text('Publier'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ResponsiveRecruitingGrid extends StatelessWidget {
  const _ResponsiveRecruitingGrid({required this.left, required this.right});

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

class _PipelinePanel extends StatelessWidget {
  const _PipelinePanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Pipeline Greenhouse-style'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (final stage in DemoData.recruitingPipeline)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _PipelineStageTile(stage: stage),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InterviewPanel extends StatelessWidget {
  const _InterviewPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Entretiens planifies'),
        Card(
          child: Column(
            children: [
              for (final slot in DemoData.interviewSlots)
                ListTile(
                  leading:
                      Icon(Icons.event_available_rounded, color: slot.color),
                  title: Text(slot.candidate),
                  subtitle: Text('${slot.panel} - ${slot.time} - ${slot.mode}'),
                  trailing: StatusChip(label: slot.status, color: slot.color),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RequisitionsPanel extends StatelessWidget {
  const _RequisitionsPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Offres ouvertes'),
        for (final item in DemoData.jobRequisitions)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: ListTile(
                leading: Icon(Icons.work_rounded, color: item.color),
                title: Text(item.title),
                subtitle: Text(
                  '${item.department} - ${item.location}\n${item.candidates} candidats pour ${item.openings} postes',
                ),
                isThreeLine: true,
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StatusChip(label: item.priority, color: item.color),
                    const SizedBox(height: 6),
                    Text(item.status),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CandidateShortlistPanel extends StatelessWidget {
  const _CandidateShortlistPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Shortlist IA'),
        for (final candidate in DemoData.candidateProfiles)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                            child: Text(candidate.name.substring(0, 1))),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(candidate.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900)),
                              Text('${candidate.role} - ${candidate.source}'),
                            ],
                          ),
                        ),
                        StatusChip(
                            label: '${candidate.aiScore}%',
                            color: candidate.color),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(candidate.experience),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: Text(candidate.stage)),
                        Text(candidate.nextStep),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _HireToHrPanel extends StatelessWidget {
  const _HireToHrPanel();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: 'Conversion embauche vers RH Core'),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatusChip(label: 'Contrat genere', color: Colors.indigo),
                StatusChip(
                    label: 'Signature electronique', color: Colors.green),
                StatusChip(label: 'Matricule automatique', color: Colors.blue),
                StatusChip(label: 'Badge NFC/RFID', color: Colors.orange),
                StatusChip(label: 'Formation initiale', color: Colors.teal),
                StatusChip(label: 'Dossier RH cree', color: Colors.purple),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PipelineStageTile extends StatelessWidget {
  const _PipelineStageTile({required this.stage});

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
            Text('${stage.count} candidats'),
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
