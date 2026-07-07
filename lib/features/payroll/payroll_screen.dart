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
    final total = DemoData.payroll.fold<double>(0, (sum, line) => sum + line.net);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader(title: 'Paie integree'),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(
              value: 'monthly',
              label: Text('Mensuelle'),
              icon: Icon(Icons.calendar_month_rounded),
            ),
            ButtonSegment(
              value: 'advance',
              label: Text('Avances'),
              icon: Icon(Icons.account_balance_wallet_rounded),
            ),
            ButtonSegment(
              value: 'bonus',
              label: Text('Primes'),
              icon: Icon(Icons.stars_rounded),
            ),
          ],
          selected: {_cycle},
          onSelectionChanged: (value) => setState(() => _cycle = value.first),
        ),
        const SizedBox(height: 16),
        ...DemoData.payroll.map(
          (line) => Card(
            child: ListTile(
              title: Text(line.employee),
              subtitle: Text('Base ${line.base.toStringAsFixed(0)} - HS ${line.overtime.toStringAsFixed(0)} - retenues ${line.deductions.toStringAsFixed(0)}'),
              trailing: Text('${line.net.toStringAsFixed(0)} GNF'),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text('Net a payer', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    Text(
                      '${total.toStringAsFixed(0)} GNF',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final step in const ['Employe', 'Manager', 'RH', 'Finance'])
                      ChoiceChip(
                        label: Text(step),
                        selected: _validation == step,
                        onSelected: (_) => setState(() => _validation = step),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => _validatePayroll(context, total),
                  icon: const Icon(Icons.verified_rounded),
                  label: const Text('Valider le cycle'),
                ),
              ],
            ),
          ),
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
