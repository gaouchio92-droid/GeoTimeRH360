import 'package:flutter/widgets.dart';
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

  testWidgets('Payroll module displays cycle and validates payroll', (tester) async {
    await tester.pumpWidget(const GeoTimeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Paie'));
    await tester.pumpAndSettle();

    expect(find.text('Paie integree'), findsOneWidget);
    expect(find.text('Juillet 2026'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Anomalies paie IA'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Anomalies paie IA'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Valider le cycle'),
      -500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Valider le cycle'));
    await tester.pumpAndSettle();

    expect(find.text('Cycle paie valide'), findsOneWidget);
  });
}
