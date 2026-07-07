import 'package:flutter_test/flutter_test.dart';
import 'package:geotime_enterprise_hr_suite/main.dart';

void main() {
  testWidgets('GeoTime launches dashboard', (tester) async {
    await tester.pumpWidget(const GeoTimeApp());
    await tester.pumpAndSettle();

    expect(find.byType(GeoTimeApp), findsOneWidget);
    expect(find.text('Presents'), findsOneWidget);
  });
}
