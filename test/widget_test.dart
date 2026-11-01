import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:suara_kampus/main.dart';

void main() {
  testWidgets('SuaraKampusApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SuaraKampusApp(),
      ),
    );

    expect(find.byType(SuaraKampusApp), findsOneWidget);
  });
}
