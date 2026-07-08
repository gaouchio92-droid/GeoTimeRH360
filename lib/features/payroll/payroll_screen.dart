import 'package:flutter/material.dart';

import '../../data/demo_data.dart';
import '../shared_widgets.dart';

class PayrollScreen extends StatefulWidget {
  const PayrollScreen({super.key});

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  String _cycle = 'monthly';
  String _validation = 'RH';

  @override
  Widget build(BuildContext context) {
    const summary = DemoData.payrollSummary;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader(title: 'Paie integree'),
        _PayrollCycleCard(
          cycle: _cycle,
          validation: _validation,
          summary: summary,
          onCycleChanged: (value) => setState(() => _cycle = value),
          onValidationChanged: (value) => setState(() => _validation = value),
          onValidate: () => _validatePayroll(context, summary.net),
        ),
        const SizedBox(height: 16),
        const _PayrollBreakdown(summary: summary),
        const SizedBox(height: 24),
        const _ResponsivePayrollPanels(
          left: _PayrollLinesPanel(),
          right: _PayrollAnomaliesPanel(),
        ),
      ],
    );
  }

  void _validatePayroll(BuildContext context, double total) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cycle paie valide'),
          content: Text(
            'Cycle: $_cycle\nEtape: $_validation\nNet: ${total.toStringAsFixed(0)} GNF\n\nExport PDF, Excel, comptabilite et API prets a connecter.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Rapport paie genere')),
                );
              },
              icon: const Icon(Icons.download_rounded),
              label: const Text('Exporter'),
            ),
          ],
        );
      },
    );
  }
}

class _PayrollCycleCard extends StatelessWidget {
  const _PayrollCycleCard({
    required this.cycle,
    required this.validation,
    required this.summary,
    required this.onCycleChanged,
    required this.onValidationChanged,
    required this.onValidate,
  });

  final String cycle;
  final String validation;
  final PayrollSummary summary;
  final ValueChanged<String> onCycleChanged;
  final ValueChanged<String> onValidationChanged;
  final VoidCallback onValidate;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.payments_rounded, color: scheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        summary.period,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      Text('${summary.employeeCount} employes - ${summary.pendingApprovals} validations restantes'),
                    ],
                  ),
                ),
                StatusChip(label: validation, color: scheme.primary),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'monthly', label: Text('Mensuelle'), icon: Icon(Icons.calendar_month_rounded)),
                  ButtonSegment(value: 'advance', label: Text('Avances'), icon: Icon(Icons.account_balance_wallet_rounded)),
                  ButtonSegment(value: 'bonus', label: Text('Primes'), icon: Icon(Icons.stars_rounded)),
                ],
                selected: {cycle},
                onSelectionChanged: (value) => onCycleChanged(value.first),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final step in const ['Employe', 'Manager', 'RH', 'Finance'])
                  ChoiceChip(
                    label: Text(step),
                    selected: validation == step,
                    onSelected: (_) => onValidationChanged(step),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onValidate,
              icon: const Icon(Icons.verified_rounded),
              label: const Text('Valider le cycle'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PayrollBreakdown extends StatelessWidget {
  const _PayrollBreakdown({required this.summary});

  final PayrollSummary summary;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final itemWidth = width >= 1100 ? (width - 132) / 4 : width >= 700 ? (width - 92) / 2 : width - 32;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SizedBox(
          width: itemWidth,
          child: MetricCard(
            title: 'Brut',
            value: _money(summary.gross),
            subtitle: 'Salaires de base',
            icon: Icons.account_balance_wallet_rounded,
            color: Colors.indigo,
          ),
        ),
        SizedBox(
          width: itemWidth,
          child: MetricCard(
            title: 'Heures sup.',
            value: _money(summary.overtime),
            subtitle: 'Jour, nuit, week-end',
            icon: Icons.more_time_rounded,
            color: Colors.orange,
          ),
        ),
        SizedBox(
          width: itemWidth,
          child: MetricCard(
            title: 'Indemnites',
            value: _money(summary.allowances),
            subtitle: 'Missions et primes',
            icon: Icons.card_giftcard_rounded,
            color: Colors.green,
          ),
        ),
        SizedBox(
          width: itemWidth,
          child: MetricCard(
            title: 'Net a payer',
            value: _money(summary.net),
            subtitle: 'Apres retenues',
            icon: Icons.payments_rounded,
            color: Colors.teal,
          ),
        ),
      ],
    );
  }
}

class _ResponsivePayrollPanels extends StatelessWidget {
  const _ResponsivePayrollPanels({
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

class _PayrollLinesPanel extends StatelessWidget {
  const _PayrollLinesPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Bulletins calcules'),
        Card(
          child: Column(
            children: [
              for (final line in DemoData.payroll)
                ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person_rounded)),
                  title: Text(line.employee),
                  subtitle: Text('Base ${_money(line.base)} - HS ${_money(line.overtime)} - retenues ${_money(line.deductions)}'),
                  trailing: Text(_money(line.net), style: const TextStyle(fontWeight: FontWeight.w800)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PayrollAnomaliesPanel extends StatelessWidget {
  const _PayrollAnomaliesPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Anomalies paie IA'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (final anomaly in DemoData.payrollAnomalies)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _PayrollAnomalyTile(anomaly: anomaly),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PayrollAnomalyTile extends StatelessWidget {
  const _PayrollAnomalyTile({required this.anomaly});

  final PayrollAnomaly anomaly;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.manage_search_rounded, color: anomaly.color),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(anomaly.title, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text('${anomaly.employee} - ${anomaly.message}'),
            ],
          ),
        ),
        const SizedBox(width: 8),
        StatusChip(label: anomaly.severity, color: anomaly.color),
      ],
    );
  }
}

String _money(double value) {
  final millions = value / 1000000;
  if (millions >= 1) return '${millions.toStringAsFixed(1)}M GNF'.replaceAll('.', ',');
  return '${value.toStringAsFixed(0)} GNF';
}
