import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geotime_enterprise_hr_suite/main.dart';

void main() {
  testWidgets('GeoTime launches dashboard', (tester) async {
    await tester.pumpWidget(const GeoTimeApp());
    await tester.pumpAndSettle();

    expect(find.byType(GeoTimeApp), findsOneWidget);
    expect(find.text('Presents'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Organigramme dynamique'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Organigramme dynamique'), findsOneWidget);
    expect(find.text('Workflow a valider'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Anti-fraude pointage'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Anti-fraude pointage'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Planification workforce'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Planification workforce'), findsOneWidget);
  });

  testWidgets('Attendance console validates a GPS check-in', (tester) async {
    await tester.pumpWidget(const GeoTimeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pointage'));
    await tester.pumpAndSettle();

    expect(find.text('Console de validation'), findsOneWidget);
    expect(find.text('Controle anti-fraude'), findsOneWidget);
    expect(find.text('File offline Afrique'), findsOneWidget);

    await tester.tap(find.text('Simuler validation'));
    await tester.pumpAndSettle();

    expect(find.text('Valide: GPS reel dans le geofence'), findsWidgets);
  });

  testWidgets('Payroll module displays cycle and validates payroll',
      (tester) async {
    await tester.pumpWidget(const GeoTimeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Paie'));
    await tester.pumpAndSettle();

    expect(find.text('Paie integree'), findsOneWidget);
    expect(find.text('Juillet 2026'), findsOneWidget);

    await tester.tap(find.text('Valider le cycle'));
    await tester.pumpAndSettle();

    expect(find.text('Cycle paie valide'), findsOneWidget);

    await tester.tap(find.text('Fermer'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Anomalies paie IA'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Anomalies paie IA'), findsOneWidget);
  });

  testWidgets('Tenant switcher updates dashboard context', (tester) async {
    await tester.pumpWidget(const GeoTimeApp());
    await tester.pumpAndSettle();

    expect(find.text('GeoTime Demo Guinee'), findsWidgets);

    await tester.tap(find.byTooltip('Changer de tenant'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Banque Atlantique Conakry').last);
    await tester.pumpAndSettle();

    expect(find.text('Banque Atlantique Conakry'), findsWidgets);
    expect(find.text('Enterprise Plus'), findsWidgets);
  });

  testWidgets('Admin dashboard opens from navigation', (tester) async {
    await tester.pumpWidget(const GeoTimeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Admin'));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard Admin'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Sante plateforme'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Sante plateforme'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Securite admin'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Securite admin'), findsOneWidget);
  });

  testWidgets('HR suite benchmark page opens from navigation', (tester) async {
    await tester.pumpWidget(const GeoTimeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Suite RH'));
    await tester.pumpAndSettle();

    expect(find.text('Suite RH 360'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Capacites inspirees des leaders RH'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Capacites inspirees des leaders RH'), findsOneWidget);
    expect(find.textContaining('UKG'), findsWidgets);

    await tester.scrollUntilVisible(
      find.text('ATS haut volume'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('ATS haut volume'), findsWidgets);
  });
}
