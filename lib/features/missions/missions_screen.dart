import 'package:flutter/material.dart';

import '../../data/demo_data.dart';
import '../shared_widgets.dart';

class MissionsScreen extends StatelessWidget {
  const MissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader(title: 'Gestion des missions'),
        ...DemoData.missions.map((mission) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.route_rounded)),
                title: Text(mission.title),
                subtitle: Text('${mission.employee} - ${mission.destination}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(mission.status),
                    Text('${mission.allowance.toStringAsFixed(0)} GNF'),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 12),
        const SectionHeader(title: 'Workflow terrain'),
        const Card(
          child: ListTile(
            leading: Icon(Icons.gps_fixed_rounded),
            title: Text('Depart, arrivee, GPS, frais et indemnites'),
            subtitle: Text('Validation hierarchique employe, manager, RH et finance.'),
          ),
        ),
      ],
    );
  }
}
