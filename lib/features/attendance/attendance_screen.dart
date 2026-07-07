import 'package:flutter/material.dart';

import '../../data/demo_data.dart';
import '../shared_widgets.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String _method = 'gps';
  bool _offlineMode = true;
  String _decision = 'Pret a verifier';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader(title: 'Pointage intelligent'),
        _AttendanceConsole(
          method: _method,
          offlineMode: _offlineMode,
          decision: _decision,
          onMethodChanged: (value) => setState(() => _method = value),
          onOfflineChanged: (value) => setState(() => _offlineMode = value),
          onValidate: _simulateValidation,
        ),
        const SizedBox(height: 16),
        _ResponsiveAttendancePanels(
          left: _FraudControlPanel(scheme: scheme),
          right: _OfflineQueuePanel(enabled: _offlineMode),
        ),
        const SizedBox(height: 24),
        const SectionHeader(title: 'Evenements recents'),
        ...DemoData.attendanceEvents.map((event) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _AttendanceEventTile(event: event),
          );
        }),
        const SizedBox(height: 12),
        const SectionHeader(title: 'Suivi employes'),
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

  void _simulateValidation() {
    final decision = switch (_method) {
      'gps' => 'Valide: GPS reel dans le geofence',
      'qr' => 'Valide: QR dynamique non expire',
      'nfc' => 'Valide: badge NFC reconnu',
      'face' => 'Valide: liveness facial confirme',
      'pin' => 'Secours: validation manager requise',
      _ => 'Pret a verifier',
    };

    setState(() => _decision = decision);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(decision)),
    );
  }
}

class _AttendanceConsole extends StatelessWidget {
  const _AttendanceConsole({
    required this.method,
    required this.offlineMode,
    required this.decision,
    required this.onMethodChanged,
    required this.onOfflineChanged,
    required this.onValidate,
  });

  final String method;
  final bool offlineMode;
  final String decision;
  final ValueChanged<String> onMethodChanged;
  final ValueChanged<bool> onOfflineChanged;
  final VoidCallback onValidate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.fingerprint_rounded),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Console de validation',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                Switch(
                  value: offlineMode,
                  onChanged: onOfflineChanged,
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(offlineMode ? 'Offline actif' : 'Connecte'),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'gps', label: Text('GPS'), icon: Icon(Icons.gps_fixed_rounded)),
                  ButtonSegment(value: 'qr', label: Text('QR'), icon: Icon(Icons.qr_code_scanner_rounded)),
                  ButtonSegment(value: 'nfc', label: Text('NFC'), icon: Icon(Icons.nfc_rounded)),
                  ButtonSegment(value: 'face', label: Text('Face'), icon: Icon(Icons.face_retouching_natural_rounded)),
                  ButtonSegment(value: 'pin', label: Text('PIN'), icon: Icon(Icons.pin_rounded)),
                ],
                selected: {method},
                onSelectionChanged: (value) => onMethodChanged(value.first),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_rounded),
                  const SizedBox(width: 10),
                  Expanded(child: Text(decision)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onValidate,
              icon: const Icon(Icons.fact_check_rounded),
              label: const Text('Simuler validation'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResponsiveAttendancePanels extends StatelessWidget {
  const _ResponsiveAttendancePanels({
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

class _FraudControlPanel extends StatelessWidget {
  const _FraudControlPanel({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Controle anti-fraude'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const _CheckRow(label: 'GPS reel', value: 'OK', color: Colors.green),
                const _CheckRow(label: 'Fake GPS / Mock location', value: 'Bloque', color: Colors.red),
                const _CheckRow(label: 'VPN / Proxy', value: 'OK', color: Colors.green),
                const _CheckRow(label: 'Root Android / Jailbreak iOS', value: 'OK', color: Colors.green),
                _CheckRow(label: 'Liveness selfie', value: '98%', color: scheme.primary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OfflineQueuePanel extends StatelessWidget {
  const _OfflineQueuePanel({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'File offline Afrique'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusChip(
                  label: enabled ? 'Synchronisation en attente' : 'Temps reel',
                  color: enabled ? Colors.orange : Colors.green,
                ),
                const SizedBox(height: 14),
                const _AttendanceRow(label: 'Evenements locaux', value: '7'),
                const _AttendanceRow(label: 'SMS fallback', value: 'Pret'),
                const _AttendanceRow(label: 'USSD fallback', value: '*144#'),
                const _AttendanceRow(label: 'Batterie', value: 'Mode economique'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.shield_rounded, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(label)),
          StatusChip(label: value, color: color),
        ],
      ),
    );
  }
}

class _AttendanceEventTile extends StatelessWidget {
  const _AttendanceEventTile({required this.event});

  final AttendanceEvent event;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: event.color.withValues(alpha: 0.14),
          child: Icon(Icons.access_time_rounded, color: event.color),
        ),
        title: Text(event.employee),
        subtitle: Text('${event.method} - ${event.site}\n${event.note}'),
        isThreeLine: true,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(event.time, style: const TextStyle(fontWeight: FontWeight.w800)),
            Text(event.decision),
          ],
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
