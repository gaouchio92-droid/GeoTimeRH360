import 'package:flutter/material.dart';

import '../../data/demo_data.dart';
import '../shared_widgets.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader(title: 'Performance et competences'),
        ...DemoData.employees.map((employee) {
          final score = employee.status == 'Presente' ? 92 : employee.status == 'Mission' ? 88 : 64;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.query_stats_rounded),
                title: Text(employee.name),
                subtitle: Text('${employee.department} - ${employee.role}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('$score/100'),
                    Text('${employee.overtimeHours.toStringAsFixed(1)} h sup.'),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: Icon(Icons.school_rounded),
            title: Text('Matrice competences et formations'),
            subtitle: Text('L IA recommande les formations selon role, certification et risque de depart.'),
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: Icon(Icons.work_history_rounded),
            title: Text('ATS recrutement'),
            subtitle: Text('Offres, CV, scoring IA, entretiens, tests et onboarding RH.'),
          ),
        ),
      ],
    );
  }
}
