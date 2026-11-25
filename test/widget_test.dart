import 'package:flutter_test/flutter_test.dart';

import 'package:modul_1_application/app.dart';

void main() {
  testWidgets('Markas Gamer Beranda smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Beranda'), findsWidgets);
    expect(find.text('Markas Gamer'), findsOneWidget);
    expect(find.text('Fitur Utama'), findsOneWidget);
  });
}
