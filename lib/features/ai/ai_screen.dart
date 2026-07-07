import 'package:flutter/material.dart';

import '../../core/localization/app_strings.dart';
import '../shared_widgets.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final TextEditingController _questionController = TextEditingController();
  String? _answer;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionHeader(title: strings.t('ai')),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.t('assistantPrompt'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _questionController,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Quels sites ont un risque d absenteisme demain ?',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    suffixIcon: IconButton(
                      tooltip: 'Commande vocale',
                      onPressed: _startVoiceCommand,
                      icon: const Icon(Icons.mic_rounded),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _analyze,
                  icon: const Icon(Icons.send_rounded),
                  label: const Text('Analyser'),
                ),
                if (_answer != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_answer!),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _InsightCard(
          icon: Icons.person_off_rounded,
          title: 'Prediction absenteisme',
          message: 'Risque eleve demain sur IT & securite apres 5 retards recurrents.',
          onTap: () => _openInsight(
            'Prediction absenteisme',
            'Suggestion: planifier un renfort et demander une validation manager preventive.',
          ),
        ),
        _InsightCard(
          icon: Icons.security_rounded,
          title: 'Fraude pointage',
          message: 'Fake GPS, VPN, root et mock location sont controles avant validation.',
          onTap: () => _openInsight(
            'Fraude pointage',
            'Action: bloquer le pointage suspect, conserver preuve selfie et journal audit.',
          ),
        ),
        _InsightCard(
          icon: Icons.face_retouching_natural_rounded,
          title: 'Liveness facial',
          message: 'Selfie obligatoire avec controle anti-photo, anti-video et anti-deepfake.',
          onTap: () => _openInsight(
            'Liveness facial',
            'Module pret a connecter a OpenAI Vision, Llama local ou moteur specialise.',
          ),
        ),
        _InsightCard(
          icon: Icons.trending_up_rounded,
          title: 'Risque de depart',
          message: 'Analyse rotation, performance, retards, formation et historique carriere.',
          onTap: () => _openInsight(
            'Risque de depart',
            'L IA peut recommander formation, entretien manager ou ajustement de charge.',
          ),
        ),
      ],
    );
  }

  void _startVoiceCommand() {
    setState(() {
      _questionController.text = 'Afficher les retards critiques par departement';
      _answer = 'Commande vocale capturee. Analyse RH en cours.';
    });
  }

  void _analyze() {
    final question = _questionController.text.trim();
    setState(() {
      _answer = question.isEmpty
          ? 'Pose une question pour lancer l analyse.'
          : 'Analyse IA: IT & securite demande un suivi prioritaire; 5 retards recurrents et 1 tentative fake GPS detectee.';
    });
  }

  void _openInsight(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Compris'),
            ),
          ],
        );
      },
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(message),
          trailing: const Icon(Icons.chevron_right_rounded),
        ),
      ),
    );
  }
}
