import 'package:flutter/material.dart';

import '../../data/demo_data.dart';
import '../shared_widgets.dart';

class SitesScreen extends StatelessWidget {
  const SitesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader(title: 'Sites et geofencing'),
        Card(
          child: Container(
            height: 180,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map_rounded, size: 42),
                SizedBox(height: 8),
                Text('Carte temps reel Google Maps / OpenStreetMap'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...DemoData.sites.map((site) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.business_rounded),
                title: Text(site.name),
                subtitle: Text('${site.type} - ${site.city} - ${site.location}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${site.radius} m'),
                    Text('${site.present}/${site.capacity} presents'),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
