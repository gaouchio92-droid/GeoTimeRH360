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
