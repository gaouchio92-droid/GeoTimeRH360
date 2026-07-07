import 'package:flutter/material.dart';

import '../../data/demo_data.dart';
import '../shared_widgets.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader(title: 'Pointage intelligent'),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ActionChip(
              avatar: const Icon(Icons.gps_fixed_rounded),
              label: const Text('GPS'),
              onPressed: () => _openAttendanceAction(context, 'Pointage GPS'),
            ),
            ActionChip(
              avatar: const Icon(Icons.qr_code_scanner_rounded),
              label: const Text('QR dynamique'),
              onPressed: () => _openAttendanceAction(context, 'Pointage QR'),
            ),
            ActionChip(
              avatar: const Icon(Icons.nfc_rounded),
              label: const Text('NFC / RFID'),
              onPressed: () => _openAttendanceAction(context, 'Pointage NFC'),
            ),
            ActionChip(
              avatar: const Icon(Icons.face_retouching_natural_rounded),
              label: const Text('Selfie + liveness'),
              onPressed: () => _openAttendanceAction(context, 'Verification faciale'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...DemoData.employees.map((employee) {
          final risky = employee.status == 'Retard' || employee.status == 'Absent';
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            employee.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        StatusChip(
                          label: employee.status,
                          color: risky ? Colors.orange : Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _AttendanceRow(label: 'Site', value: employee.site),
                    _AttendanceRow(label: 'Retard', value: '${employee.lateMinutes} min'),
                    _AttendanceRow(label: 'Heures sup.', value: '${employee.overtimeHours.toStringAsFixed(1)} h'),
                    const SizedBox(height: 8),
                    const Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        StatusChip(label: 'Fake GPS: OK', color: Colors.green),
                        StatusChip(label: 'VPN: OK', color: Colors.green),
                        StatusChip(label: 'Appareil: verifie', color: Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  void _openAttendanceAction(BuildContext context, String title) {
    final employeeController = TextEditingController();
    final siteController = TextEditingController();
    final noteController = TextEditingController();

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
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              _AttendanceField(
                controller: employeeController,
                label: 'Employe',
                icon: Icons.person_rounded,
              ),
              _AttendanceField(
                controller: siteController,
                label: 'Site / geofence',
                icon: Icons.location_on_rounded,
              ),
              _AttendanceField(
                controller: noteController,
                label: 'Note',
                icon: Icons.edit_note_rounded,
              ),
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$title enregistre')),
                  );
                },
                icon: const Icon(Icons.check_rounded),
                label: const Text('Valider'),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      employeeController.dispose();
      siteController.dispose();
      noteController.dispose();
    });
  }
}

class _AttendanceField extends StatelessWidget {
  const _AttendanceField({
    required this.controller,
    required this.label,
    required this.icon,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

class _AttendanceRow extends StatelessWidget {
  const _AttendanceRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
